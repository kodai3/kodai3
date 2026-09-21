if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

export ZSH="${ZSH:-$HOME/.oh-my-zsh}"
ZSH_THEME="ys"

zstyle ':omz:plugins:fnm' autostart on

plugins=(
  git
  fnm
  direnv
  zsh-syntax-highlighting
  zsh-completions
  zsh-autosuggestions
  zsh-history-substring-search
)

source "${ZSH}/oh-my-zsh.sh"

if [[ -f "${HOME}/.zshrc.local" ]]; then
  source "${HOME}/.zshrc.local"
fi
