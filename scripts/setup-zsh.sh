#!/usr/bin/env bash
set -euo pipefail

# shellcheck source=lib.sh
source "$(cd "$(dirname "$0")" && pwd)/lib.sh"
parse_args "$@"

require_macos
command -v git >/dev/null 2>&1 || die "git is required to install Oh My Zsh"

omz_dir="${HOME}/.oh-my-zsh"
if [[ ! -d "$omz_dir" ]]; then
  echo "zsh: installing Oh My Zsh"
  git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$omz_dir"
else
  echo "zsh: Oh My Zsh already present"
fi

clone_omz_plugin() {
  local name="$1"
  local url="$2"
  local dest="${omz_dir}/custom/plugins/${name}"
  if [[ ! -d "$dest" ]]; then
    echo "zsh: installing plugin ${name}"
    git clone --depth=1 "$url" "$dest"
  else
    echo "zsh: plugin ${name} already present"
  fi
}

clone_omz_plugin zsh-syntax-highlighting https://github.com/zsh-users/zsh-syntax-highlighting.git
clone_omz_plugin zsh-autosuggestions https://github.com/zsh-users/zsh-autosuggestions.git
clone_omz_plugin zsh-completions https://github.com/zsh-users/zsh-completions.git
clone_omz_plugin zsh-history-substring-search https://github.com/zsh-users/zsh-history-substring-search.git

link_path "${ROOT}/dotfiles/zsh/.zshrc" "${HOME}/.zshrc"
link_path "${ROOT}/dotfiles/zsh/custom/kodai.zsh" "${omz_dir}/custom/kodai.zsh"

echo "zsh: extra public settings live in dotfiles/zsh/custom/."
echo "zsh: secrets and machine-only config go in ~/.zshrc.local (not git)."
echo "zsh: restart the shell or run: source ~/.zshrc"
