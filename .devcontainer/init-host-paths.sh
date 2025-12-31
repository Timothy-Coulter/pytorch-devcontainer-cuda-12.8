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

# Primary root for WSL (visible to docker-desktop) and fallback for native Linux
WSL_ROOT="/mnt/wsl/${WSL_DISTRO_NAME:-Ubuntu}/data"
NATIVE_ROOT="/data"

for root in "$WSL_ROOT" "$NATIVE_ROOT"; do
  create_host_path "${root}/caches/torch"
  create_host_path "${root}/caches/huggingface"
  create_host_path "${root}/projects/${REPO_NAME}/data"
  create_host_path "${root}/projects/${REPO_NAME}/datasets"
done
