FROM quay.io/devfile/universal-developer-image:latest

USER root

# Add fish repo 
RUN cd /etc/yum.repos.d && \
    wget https://download.opensuse.org/repositories/shells:fish:release:3/CentOS_8/shells:fish:release:3.repo 

# Add epel repo
RUN yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm

# Install dependencies
RUN yum install -y curl fish neovim vim wget zsh

# Clean dnf cache
RUN yum clean all

# Install chectl
RUN curl -Lo chectl.sh  https://www.eclipse.org/che/chectl/ && \
    bash chectl.sh

# Download and install FiraCode Nerd Font from https://www.nerdfonts.com/font-downloads
RUN mkdir -p /usr/local/share/fonts/FiraCode && \
    cd /tmp && curl -Lo FiraCode.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/FiraCode.zip && \
    unzip /tmp/FiraCode.zip -d /usr/local/share/fonts/FiraCode && \
    rm /tmp/FiraCode.zip && \
    fc-cache /usr/local/share/fonts/

# Install starship
# RUN sh -c "$(curl -fsSL https://starship.rs/install.sh)" -- --yes
RUN yum copr enable -y atim/starship && \
    yum install -y starship

USER 1001060000

# Add the init script to bashrc
RUN echo 'eval "$(starship init bash)"' >> ~/.bashrc

# Add the init script to zshrc
RUN echo 'eval "$(starship init zsh)"' >> ~/.zshrc

# Add the init script to fish config
RUN mkdir -p ~/.config/fish && echo 'starship init fish | source' >> ~/.config/fish/config.fish

# Set fish as default shell
ENV SHELL="/usr/bin/fish"
