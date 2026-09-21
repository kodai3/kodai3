#!/usr/bin/env bash
set -euo pipefail

# shellcheck source=lib.sh
source "$(cd "$(dirname "$0")" && pwd)/lib.sh"
parse_args "$@"

require_macos

if [[ "$FORCE" -eq 1 ]]; then
  "${ROOT}/scripts/install-apps.sh" --force
  "${ROOT}/scripts/setup-zsh.sh" --force
  "${ROOT}/scripts/setup-gh.sh" --force
else
  "${ROOT}/scripts/install-apps.sh"
  "${ROOT}/scripts/setup-zsh.sh"
  "${ROOT}/scripts/setup-gh.sh"
fi

echo
echo "setup finished. Remaining manual steps:"
cat "${ROOT}/CHECKLIST.md"
