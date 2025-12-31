#!/usr/bin/env bash
set -euo pipefail

repo="${1:-$(basename "${PWD}")}"

# Pick a writable root. Prefer WSL ext4 if present, else /data on native Linux.
host_root="/data"
if [ -n "${WSL_DISTRO_NAME:-}" ] && [ -d "/mnt/wsl/${WSL_DISTRO_NAME}" ]; then
  host_root="/mnt/wsl/${WSL_DISTRO_NAME}/data"
elif [ -d /mnt/wsl/Ubuntu ]; then
  host_root="/mnt/wsl/Ubuntu/data"
fi

# Use sudo if available; otherwise run plain (e.g., docker-desktop already root).
SUDO=""
if command -v sudo >/dev/null 2>&1; then
  SUDO="sudo"
fi

# If we’re on WSL and /data isn’t the same tree, make /data point at the WSL-backed path.
if [ "${host_root}" != "/data" ] && [ ! -e /data ]; then
  ${SUDO} ln -sfn "${host_root}" /data
fi

${SUDO} mkdir -p \
  "${host_root}/caches/torch" \
  "${host_root}/caches/huggingface" \
  "${host_root}/projects/${repo}/data" \
  "${host_root}/projects/${repo}/datasets"

# Best-effort ownership fix to UID/GID of the current user (or the sudo caller).
uid="${SUDO_UID:-$(id -u)}"
gid="${SUDO_GID:-$(id -g)}"
${SUDO} chown -R "${uid}:${gid}" "${host_root}/caches" "${host_root}/projects/${repo}" || true
