#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
dev.sh <command>

Commands:
  format       Run code formatters (ruff format + black + isort)
  lint         Run static lint (ruff check)
  lint-fix     Run lint and auto-fix (ruff --fix)
  typecheck    Run mypy with strict settings
  test         Run pytest with xdist + reruns
  all-checks   Format, lint-fix, typecheck, then tests
  versions     Print Python, Torch, and CUDA info

Examples:
  ./dev.sh all-checks
USAGE
}

cmd=${1:-}
if [[ -z "$cmd" ]]; then
  usage
  exit 1
fi

case "$cmd" in
  format)
    echo "[format] ruff format, black, isort"
    ruff format .
    black .
    isort .
    ;;
  lint)
    echo "[lint] ruff check"
    ruff check .
    ;;
  lint-fix)
    echo "[lint-fix] ruff check --fix"
    ruff check --fix .
    ;;
  typecheck)
    echo "[typecheck] mypy"
    mypy .
    ;;
  test)
    echo "[test] pytest (uses pyproject addopts)"
    pytest
    ;;
  versions)
    echo "[versions] Python, torch, CUDA"
    python - <<'PY'
import sys
print("python:", sys.version.replace("\n"," "))
try:
    import torch
    print("torch:", torch.__version__)
    print("torch.cuda.is_available():", torch.cuda.is_available())
    print("torch.version.cuda:", torch.version.cuda)
    try:
        from torch.utils.cpp_extension import CUDA_HOME
        print("CUDA_HOME:", CUDA_HOME)
    except Exception as e:
        print("CUDA_HOME: n/a (", e, ")")
except Exception as e:
    print("torch import failed:", e)
PY
    ;;
  all-checks)
    "$0" format
    "$0" lint-fix
    "$0" typecheck
    "$0" test
    ;;
  *)
    usage
    exit 1
    ;;
esac
