FROM quay.io/devfile/universal-developer-image:latest

USER root

# Install EPEL repository, core dependencies, Python 3.12, and Starship
# Also clean yum caches to reduce image size.
RUN yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm && \
    yum install -y \
    fish \
    neovim \
    vim \
    wget \
    zsh \
    ripgrep \
    ca-certificates \
    # Python 3.12. The venv module should be included. If 'uv venv' later fails,
    # a specific venv package (e.g., python3-virtualenv or python3.12-venv variant)
    # might be needed, or Python installed differently.
    python3.12 && \
    yum copr enable -y atim/starship && \
    yum install -y starship && \
    yum clean all && \
    rm -rf /var/cache/yum

# Install uv - the fast Python package installer and resolver
RUN curl -LsSf https://astral.sh/uv/install.sh | sh

# Add uv's installation directory to the PATH for root and subsequent users
ENV PATH="/root/.cargo/bin:${PATH}"

# Create a Python virtual environment for ra-aid and install it
# Using /opt/ra_aid_venv for the virtual environment and pinning protobuf versions
RUN uv venv /opt/ra_aid_venv --python 3.12 \
    && . /opt/ra_aid_venv/bin/activate \
    && uv pip install protobuf==4.25.3 googleapis-common-protos==1.63.0 ra-aid

# Add the ra-aid venv bin to the PATH so its executables are accessible
ENV PATH="/opt/ra_aid_venv/bin:${PATH}"

# Install chectl
RUN curl -Lo /usr/local/bin/chectl https://che-incubator.github.io/chectl/install.sh && \
    chmod +x /usr/local/bin/chectl

# Download and install FiraCode Nerd Font
RUN mkdir -p /usr/local/share/fonts/FiraCode && \
    cd /tmp && \
    curl -Lo FiraCode.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/FiraCode.zip && \
    unzip FiraCode.zip -d /usr/local/share/fonts/FiraCode && \
    rm FiraCode.zip && \
    fc-cache -fv /usr/local/share/fonts/

# Configure Starship for system-wide use with /opt storage
RUN mkdir -p /opt/starship/config /opt/starship/cache && \
    touch /opt/starship/config/starship.toml && \
    chown -R 10001:0 /opt/starship && \
    chmod -R u=rwX,go=rX /opt/starship

# Set environment variables for Starship to use the /opt locations
ENV STARSHIP_CONFIG="/opt/starship/config/starship.toml"
ENV STARSHIP_CACHE="/opt/starship/cache"

# Bash: Add Starship init to a new script in /etc/profile.d/ for system-wide effect (Bash only)
RUN echo 'if [ -n "$BASH_VERSION" ]; then eval "$(starship init bash)"; fi' > /etc/profile.d/starship.sh && \
    chmod +x /etc/profile.d/starship.sh

# Zsh: Create /etc/zshrc with completion initialization and Starship init
RUN printf '%s\n' \
    '# System-wide Zshrc configured by Dockerfile' \
    '' \
    '# Initialize Zsh completion system to ensure SDKMAN and other tools work correctly' \
    'if typeset -f compinit >/dev/null; then' \
    '  autoload -Uz compinit && compinit -u' \
    'fi' \
    '' \
    '# Initialize Zsh bash completion compatibility (for SDKMAN, etc.)' \
    'if typeset -f bashcompinit >/dev/null; then' \
    '  autoload -Uz bashcompinit && bashcompinit' \
    'fi' \
    '' \
    '# Initialize Starship prompt' \
    'if command -v starship >/dev/null; then' \
    '  eval "$(starship init zsh)"' \
    'fi' > /etc/zshrc

# Fish: Add Starship init to a new script in /etc/fish/conf.d/ for system-wide effect
RUN mkdir -p /etc/fish/conf.d && \
    echo 'if command -v starship > /dev/null; starship init fish | source; end' > /etc/fish/conf.d/starship.fish

USER 10001

# Set fish as default shell for the user
ENV SHELL="/usr/bin/fish"
