#!/usr/bin/env bash
set -euo pipefail

# shellcheck source=lib.sh
source "$(cd "$(dirname "$0")" && pwd)/lib.sh"
parse_args "$@"

require_macos

command -v gh >/dev/null 2>&1 || die "gh is not installed. Run scripts/install-apps.sh first."

if gh auth status >/dev/null 2>&1; then
  echo "gh: already authenticated"
else
  if [[ -t 0 ]]; then
    echo "gh: logging in to GitHub"
    gh auth login
  else
    echo "gh: not logged in. Run: gh auth login"
  fi
fi

if gh auth status >/dev/null 2>&1; then
  gh auth setup-git
  echo "gh: git credential helper configured"
fi
