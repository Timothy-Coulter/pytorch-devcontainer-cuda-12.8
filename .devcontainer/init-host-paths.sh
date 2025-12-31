#!/usr/bin/env bash
set -euo pipefail

REPO_NAME="${1:-}"
if [ -z "${REPO_NAME}" ]; then
  echo "[devcontainer] Repository name argument required" >&2
  exit 1
fi

mkdir -p .devcontainer
if [ -f "$HOME/.env" ]; then
  cp "$HOME/.env" .devcontainer/.env.devcontainer
else
  : > .devcontainer/.env.devcontainer
fi

create_host_path() {
  mkdir -p "$1" 2>/dev/null && return 0
  if command -v sudo >/dev/null 2>&1; then
    sudo -n mkdir -p "$1" 2>/dev/null && return 0
  fi
  echo "[devcontainer] Warning: could not create $1 (check permissions)" >&2
}

for path in \
  /data/caches/torch \
  /data/caches/huggingface \
  /data/projects/${REPO_NAME}/data \
  /data/projects/${REPO_NAME}/datasets; do
  create_host_path "$path"
done
