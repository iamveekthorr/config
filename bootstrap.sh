#!/usr/bin/env bash
# Bootstrap dotfiles on a new machine.
#
# This repo lives at ~/.config and tracks tool configs that already sit inside
# the XDG config directory (nvim, alacritty, ghostty, starship). Anything that
# *has* to live outside ~/.config (like ~/.editorconfig) is stored here under a
# non-dot name and symlinked into place by this script.
#
# Idempotent: re-running is safe. Existing real files are backed up to *.bak.

set -euo pipefail

# Resolve this script's directory (the dotfiles root).
DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

color_info()  { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
color_ok()    { printf '\033[1;32m  ok\033[0m %s\n' "$*"; }
color_warn()  { printf '\033[1;33m warn\033[0m %s\n' "$*"; }

# link <source-relative-to-DOTFILES> <target-absolute-path>
#
# Creates a symlink at <target> pointing to <DOTFILES>/<source>.
# - If target is already the correct symlink: no-op.
# - If target is a regular file/dir: backed up to <target>.bak then replaced.
# - If target is a wrong symlink: replaced.
link() {
  local src="$DOTFILES/$1"
  local dst="$2"

  if [[ ! -e "$src" ]]; then
    color_warn "source missing, skipping: $src"
    return
  fi

  # Already correctly linked.
  if [[ -L "$dst" && "$(readlink "$dst")" == "$src" ]]; then
    color_ok "$dst -> $src"
    return
  fi

  # Real file/dir or wrong symlink in place — back it up.
  if [[ -e "$dst" || -L "$dst" ]]; then
    local backup="${dst}.bak.$(date +%Y%m%d%H%M%S)"
    color_warn "moving existing $dst to $backup"
    mv "$dst" "$backup"
  fi

  mkdir -p "$(dirname "$dst")"
  ln -s "$src" "$dst"
  color_ok "$dst -> $src"
}

color_info "Pinning hostname (prevents DHCP from overriding it)"

# macOS derives the kernel hostname from DHCP when HostName is unset, which
# causes the prompt to show a router-assigned name instead of the machine name.
# Pinning HostName to match LocalHostName locks it permanently.
_local_host="$(scutil --get LocalHostName 2>/dev/null || true)"
_current_host="$(scutil --get HostName 2>/dev/null || true)"
if [[ -n "$_local_host" && "$_current_host" != "$_local_host" ]]; then
  sudo scutil --set HostName "$_local_host"
  color_ok "HostName set to $_local_host"
else
  color_ok "HostName already pinned ($_current_host)"
fi

color_info "Setting up tmux plugin manager (TPM)"

TPM_DIR="$HOME/.config/tmux/plugins/tpm"
if [[ -d "$TPM_DIR/.git" ]]; then
  color_ok "TPM already present"
else
  git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
  color_ok "TPM cloned to $TPM_DIR"
fi

color_info "Linking dotfiles from $DOTFILES"

# ---- symlinks ----------------------------------------------------------------
# Files that must live outside ~/.config go here.

# Global EditorConfig — used by Roslyn / dotnet format / IDEs for C# style.
link "editorconfig" "$HOME/.editorconfig"

# Add new symlinks above this line. Example:
# link "gitconfig" "$HOME/.gitconfig"

color_info "Done."
