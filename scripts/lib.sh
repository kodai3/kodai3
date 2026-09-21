#!/usr/bin/env bash
# shellcheck shell=bash

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
FORCE=0

parse_args() {
  local arg
  for arg in "$@"; do
    case "$arg" in
      --force) FORCE=1 ;;
      -h | --help) ;;
      *)
        echo "error: unknown argument: $arg" >&2
        exit 1
        ;;
    esac
  done
}

die() {
  echo "error: $*" >&2
  exit 1
}

require_macos() {
  if [[ "$(uname -s)" != "Darwin" ]]; then
    die "this setup is for macOS"
  fi
}

# Link dest -> src. Matching symlink is a no-op.
# --force replaces a different symlink, or moves a real file to *.kodai3.bak.
link_path() {
  local src="$1"
  local dest="$2"
  local current

  mkdir -p "$(dirname "$dest")"

  if [[ -L "$dest" ]]; then
    current="$(readlink "$dest")"
    if [[ "$current" == "$src" ]]; then
      echo "ok    $dest"
      return 0
    fi
    if [[ "$FORCE" -ne 1 ]]; then
      die "$dest already links to $current (want $src). Re-run with --force."
    fi
    rm "$dest"
  elif [[ -e "$dest" ]]; then
    if [[ "$FORCE" -ne 1 ]]; then
      die "$dest exists and is not a symlink. Back it up or re-run with --force."
    fi
    mv "$dest" "${dest}.kodai3.bak"
    echo "moved $dest -> ${dest}.kodai3.bak"
  fi

  ln -s "$src" "$dest"
  echo "link  $dest -> $src"
}
