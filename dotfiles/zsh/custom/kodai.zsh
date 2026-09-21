# Public extra zsh settings. Machine-specific secrets go in ~/.zshrc.local.

alias ll='ls -alF'

if command -v peco >/dev/null 2>&1; then
  peco-select-history() {
    local reverse
    if command -v tac >/dev/null 2>&1; then
      reverse="tac"
    else
      reverse="tail -r"
    fi
    BUFFER="$(fc -l -n 1 | eval "$reverse" | peco --query "$LBUFFER")"
    CURSOR="${#BUFFER}"
    zle clear-screen
  }
  zle -N peco-select-history
  bindkey '^R' peco-select-history
fi
