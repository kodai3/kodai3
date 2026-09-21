# Bootstrap this machine

Clone this repository, then run:

```bash
git clone https://github.com/kodai3/kodai3.git
cd kodai3
./scripts/setup.sh
```

Existing files are left alone. To replace them:

```bash
./scripts/setup.sh --force
```

## What the scripts do

- `scripts/install-apps.sh` installs Homebrew if missing, then the formulae and casks in `Brewfile` (`gh`, `direnv`, `fnm`, `peco`, and the GUI apps)
- `scripts/setup-zsh.sh` installs Oh My Zsh plus custom plugins (`zsh-syntax-highlighting`, `zsh-autosuggestions`, `zsh-completions`, `zsh-history-substring-search`), then symlinks `dotfiles/zsh/.zshrc` and `dotfiles/zsh/custom/kodai.zsh`. Built-in plugins `git`, `fnm`, and `direnv` are enabled in `.zshrc`. peco history search is bound to Ctrl-R. Machine-only secrets go in `~/.zshrc.local`.
- `scripts/setup-gh.sh` runs `gh auth login` when stdin is a TTY, then `gh auth setup-git`. Tokens stay off git.

Skills live in this repo at `.agents/skills`. `.claude/skills` and `.cursor/skills` are git symlinks to that directory, so Claude Code, Cursor, and Codex pick them up when this repository is open. They are not copied into `$HOME`.

The public CLI (`npx kodai3 whoami`) is unchanged. Machine setup is this git clone plus the scripts above.

Secrets, SSH keys, `.npmrc`, MCP OAuth, and plugin caches stay off git. See [CHECKLIST.md](../CHECKLIST.md) for the rest.
