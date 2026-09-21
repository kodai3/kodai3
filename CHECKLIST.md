# New Mac checklist

Automated by `scripts/setup.sh`: Homebrew apps, `~/.zshrc`, and `gh` login when the session is interactive.

Do these by hand:

1. Sign in to Apple ID, 1Password, Cursor, Claude, ChatGPT, and Dia.
2. If `gh auth login` was skipped, run it. Create an SSH key and add it to GitHub if you use SSH. Do not commit keys.
3. Point iTerm2 at zsh (`/bin/zsh` or Homebrew zsh) and pick a font.
4. Install Claude Code / Cursor / Codex plugins you actually use. Do not vendor plugin caches in git.
5. Put machine-only shell config (pyenv, work aliases) in `~/.zshrc.local`. Do not commit that file.
