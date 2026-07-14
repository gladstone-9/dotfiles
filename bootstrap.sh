#!/usr/bin/env bash
#
# bootstrap.sh — set up shell enhancements on a new machine.
#
# Usage:
#   ./bootstrap.sh
#
# What it does:
#   1. Installs Homebrew if missing (macOS only).
#   2. Installs external CLI tools required by enhancements.zsh that aren't
#      self-bootstrapped by zinit (fzf, zoxide, eza, bat, git).
#   3. Symlinks enhancements.zsh and p10k.zsh into your home directory.
#
# What it does NOT do:
#   - Touch your ~/.zshrc. You add `source ~/.zsh-enhancements` yourself
#     (see zshrc.reference for a full template).
#   - Install other machine-specific tools.
#     Those belong in your regular ~/.zshrc config (see README.md).
#
# Safe to re-run: all steps are idempotent.

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ZSH_SRC_DIR="$DOTFILES_DIR/zsh"
TIMESTAMP="$(date +%Y%m%d%H%M%S)"

log()  { printf '\033[1;34m[bootstrap]\033[0m %s\n' "$1"; }
warn() { printf '\033[1;33m[bootstrap][warn]\033[0m %s\n' "$1"; }

# --- 1. Homebrew -------------------------------------------------------
if [[ "$(uname -s)" != "Darwin" ]]; then
  warn "This bootstrap script is written for macOS (Homebrew). Adjust for your OS."
fi

if ! command -v brew >/dev/null 2>&1; then
  log "Homebrew not found. Installing..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
else
  log "Homebrew already installed."
fi

# --- 2. Enhancement dependencies ----------------------------------------
BREW_PACKAGES=(fzf zoxide eza bat git)
for pkg in "${BREW_PACKAGES[@]}"; do
  if command -v "$pkg" >/dev/null 2>&1; then
    log "$pkg already installed, skipping."
  else
    log "Installing $pkg via Homebrew..."
    brew install "$pkg"
  fi
done

# --- 3. Symlink enhancements --------------------------------------------
link_file() {
  local src="$1" dest="$2"
  if [[ -e "$dest" || -L "$dest" ]]; then
    if [[ -L "$dest" && "$(readlink "$dest")" == "$src" ]]; then
      log "$dest already linked correctly, skipping."
      return
    fi
    local backup="${dest}.backup.${TIMESTAMP}"
    log "Backing up existing $dest -> $backup"
    mv "$dest" "$backup"
  fi
  ln -s "$src" "$dest"
  log "Linked $dest -> $src"
}

link_file "$ZSH_SRC_DIR/enhancements.zsh" "$HOME/.zsh-enhancements"
link_file "$ZSH_SRC_DIR/p10k.zsh"         "$HOME/.p10k.zsh"

log ""
log "Done! Next steps:"
log "  1. Add this line to the TOP of your ~/.zshrc:"
log "       source ~/.zsh-enhancements"
log "  2. Open a new terminal (or run 'exec zsh') — zinit will auto-install plugins."
