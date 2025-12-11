#!/bin/bash
# Lessig-Hardt Slide Generator Installer
# Usage: curl -fsSL https://raw.githubusercontent.com/fkchang/lessig-hardt/main/install.sh | bash
#
# Or manually:
#   git clone https://github.com/fkchang/lessig-hardt.git
#   cd lessig-hardt
#   ./install.sh

set -e

INSTALL_DIR="${LESSIG_HARDT_HOME:-$HOME/.lessig-hardt}"
REPO_URL="https://github.com/fkchang/lessig-hardt.git"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

info() { echo -e "${GREEN}==>${NC} $1"; }
warn() { echo -e "${YELLOW}Warning:${NC} $1"; }
error() { echo -e "${RED}Error:${NC} $1"; exit 1; }

# Check prerequisites
check_prereqs() {
    info "Checking prerequisites..."

    # Must be macOS
    if [[ "$(uname)" != "Darwin" ]]; then
        error "This tool requires macOS (uses Keynote and AppleScript)"
    fi

    # Check for Keynote
    if ! [ -d "/Applications/Keynote.app" ]; then
        error "Keynote.app not found. Please install Keynote from the App Store."
    fi

    # Check for osacompile
    if ! command -v osacompile &> /dev/null; then
        error "osacompile not found. Please install Xcode Command Line Tools:\n  xcode-select --install"
    fi

    info "Prerequisites OK"
}

# Install from git or local directory
install_lessig_hardt() {
    # If we're already in the repo directory (manual install)
    if [ -f "slide_generator_lib.applescript" ]; then
        info "Installing from current directory..."
        INSTALL_DIR="$(pwd)"
    else
        # Clone the repo
        info "Cloning repository to $INSTALL_DIR..."
        if [ -d "$INSTALL_DIR" ]; then
            warn "Directory exists, updating..."
            cd "$INSTALL_DIR"
            git pull
        else
            git clone "$REPO_URL" "$INSTALL_DIR"
            cd "$INSTALL_DIR"
        fi
    fi

    # Compile AppleScript
    info "Compiling AppleScript..."
    if command -v rake &> /dev/null; then
        rake compile
    else
        # Fallback if rake not available
        osacompile -o slide_generator_lib.scpt slide_generator_lib.applescript
        osacompile -o slide_generator.scpt slide_generator.applescript
    fi

    # Make bin executable
    chmod +x bin/lessig_hardt
}

# Add to PATH
setup_path() {
    local shell_rc=""
    local bin_path="$INSTALL_DIR/bin"

    # Detect shell
    case "$SHELL" in
        */zsh)  shell_rc="$HOME/.zshrc" ;;
        */bash) shell_rc="$HOME/.bashrc" ;;
        *)      shell_rc="$HOME/.profile" ;;
    esac

    # Check if already in PATH
    if [[ ":$PATH:" == *":$bin_path:"* ]]; then
        info "Already in PATH"
        return
    fi

    # Add to shell config
    echo "" >> "$shell_rc"
    echo "# Lessig-Hardt Slide Generator" >> "$shell_rc"
    echo "export PATH=\"$bin_path:\$PATH\"" >> "$shell_rc"

    info "Added to PATH in $shell_rc"
    warn "Run 'source $shell_rc' or open a new terminal to use lessig_hardt"
}

# Main
main() {
    echo ""
    echo "╔═══════════════════════════════════════════╗"
    echo "║   Lessig-Hardt Slide Generator Installer  ║"
    echo "╚═══════════════════════════════════════════╝"
    echo ""

    check_prereqs
    install_lessig_hardt
    setup_path

    echo ""
    info "Installation complete!"
    echo ""
    echo "  Usage:"
    echo "    lessig_hardt slides.txt    # Generate from file"
    echo "    lessig_hardt               # Open file picker"
    echo ""
    echo "  Example files in: $INSTALL_DIR/examples/"
    echo ""
}

main
