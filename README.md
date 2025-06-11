# dev-tools

## Overview

This repository provides a pre-configured development environment, designed for use within Eclipse Che. It comes equipped with a comprehensive set of tools and configurations to support various development workflows, with a focus on Python and modern command-line utilities.

## Base Image

The environment is built upon the `quay.io/devfile/universal-developer-image:latest` base image.

## Key Features & Installed Software

### Shells
*   **Fish (`fish`)**: The default shell for the primary user.
*   **Zsh (`zsh`)**
*   **Bash (`bash`)**

### Editors
*   **Neovim (`nvim`)**
*   **Vim (`vim`)**

### Python Environment
*   **Python Version**: 3.12
*   **Package Manager**: `uv` (installed via `curl ... | sh` and available in `/root/.cargo/bin`)
*   **Virtual Environment**: Located at `/opt/ra_aid_venv`, created using Python 3.12.
*   **Key Python Packages Installed**:
    *   `protobuf==4.25.3`
    *   `googleapis-common-protos==1.63.0`
    *   `ra-aid`
    *   `aider-chat@latest`

### Command-Line Utilities
*   **Ripgrep (`rg`)**: A fast, line-oriented search tool.
*   **Wget (`wget`)**: Utility for non-interactive download of files from the Web.
*   `ca-certificates`

### Development Tools
*   **chectl**: CLI tool for Eclipse Che (installed at `/usr/local/bin/chectl`).

### Prompt Customization
*   **Starship**: A minimal, blazing-fast, and infinitely customizable cross-shell prompt. It is configured system-wide for Bash, Zsh, and Fish.

### Fonts
*   **FiraCode Nerd Font**: Version 3.4.0 installed system-wide for enhanced terminal aesthetics with ligatures and icons.

## Environment Configuration

### User
*   **Default User ID**: `10001`

### Default Shell
*   The default shell for user `10001` is **Fish (`fish`)**.

### PATH Configuration
The system `PATH` is augmented to include:
*   `/root/.cargo/bin`: For the `uv` Python package manager.
*   `/opt/ra_aid_venv/bin`: For executables from the Python virtual environment (e.g., `aider`, `ra-aid`).

### Starship Prompt
*   **System-wide Configuration**: Starship is initialized for:
    *   Bash: via `/etc/profile.d/starship.sh`
    *   Zsh: via `/etc/zshrc`
    *   Fish: via `/etc/fish/conf.d/starship.fish`
*   **Custom Paths**: To avoid issues with user home directories in containerized environments, Starship uses:
    *   `STARSHIP_CONFIG=/opt/starship/config/starship.toml`
    *   `STARSHIP_CACHE=/opt/starship/cache`

## Usage Notes

*   **Accessing Python Tools**: Python tools installed within the `/opt/ra_aid_venv` virtual environment (like `aider`, `uv`, and scripts from `ra-aid`) are directly accessible from the command line as their `bin` directory is in the `PATH`.
*   **Starship Prompt**: The Starship prompt is automatically active in all configured shells (Fish, Zsh, Bash) upon starting a terminal session.
