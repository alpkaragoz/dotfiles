#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
BACKUP_DIR="${HOME}/.dotfiles-backup/$(date +%Y%m%d_%H%M%S)"

green='\033[0;32m'
yellow='\033[0;33m'
nc='\033[0m'

info() { echo -e "${green}[+]${nc} $1"; }
warn() { echo -e "${yellow}[!]${nc} $1"; }

backup_and_link() {
  local src="$1" dst="$2"
  if [[ -e "$dst" || -L "$dst" ]]; then
    mkdir -p "$BACKUP_DIR"
    mv "$dst" "$BACKUP_DIR/"
    warn "Backed up $(basename "$dst") -> ${BACKUP_DIR}/"
  fi
  ln -sf "$src" "$dst"
  info "Linked $(basename "$dst")"
}

echo ""
echo "  dotfiles installer"
echo "  ──────────────────"
echo ""

# ── Zsh ──────────────────────────────────────────────────────
backup_and_link "${DOTFILES_DIR}/zsh/.zshrc" "${HOME}/.zshrc"
backup_and_link "${DOTFILES_DIR}/zsh/.zsh"   "${HOME}/.zsh"

# Create local.zsh from template if it doesn't exist
if [[ ! -f "${DOTFILES_DIR}/zsh/.zsh/local.zsh" ]]; then
  cp "${DOTFILES_DIR}/zsh/.zsh/local.zsh.template" "${DOTFILES_DIR}/zsh/.zsh/local.zsh"
  info "Created local.zsh from template — edit with machine-specific config"
fi

# Ensure cache directory exists
mkdir -p "${DOTFILES_DIR}/zsh/.zsh/cache"

# ── Dependencies ─────────────────────────────────────────────
echo ""
if command -v apt &>/dev/null; then
  echo "Recommended packages (Debian/Ubuntu):"
  echo "  sudo apt install zsh-syntax-highlighting zsh-autosuggestions"
elif command -v pacman &>/dev/null; then
  echo "Recommended packages (Arch):"
  echo "  sudo pacman -S zsh-syntax-highlighting zsh-autosuggestions"
elif command -v brew &>/dev/null; then
  echo "Recommended packages (macOS):"
  echo "  brew install zsh-syntax-highlighting zsh-autosuggestions"
fi

echo ""
info "Done. Open a new terminal or run: source ~/.zshrc"
echo ""
