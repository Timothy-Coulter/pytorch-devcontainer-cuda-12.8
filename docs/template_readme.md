PyTorch DevContainer (CUDA) Template — Quickstart
================================================

This template provides a ready-to-use VS Code Dev Container for PyTorch on NVIDIA GPUs, based on the NGC image `nvcr.io/nvidia/pytorch:25.08-py3`. It installs development tooling with `uv` while using the system Python and preinstalled PyTorch/CUDA from the base image — PyTorch is never re-downloaded.

Prerequisites
-------------
- Docker 24+
- NVIDIA GPU drivers + NVIDIA Container Toolkit (for GPU access)
- Access to NGC: `docker login nvcr.io` with your NGC API key
- VS Code + Dev Containers extension (or GitHub Codespaces)

What you get
------------
- Base image: `nvcr.io/nvidia/pytorch:25.08-py3` (Python 3.12, Torch 2.8.nv25.08, CUDA 13.0)
- `uv` package manager, strict typing (mypy), ruff/black/isort
- Useful caches mounted as volumes (pip, uv, torch, huggingface)
- GPU-enabled run args: `--gpus all --ipc host`
 - JupyterLab auto-starts on port 8888 (no token)

Repo Layout
-----------
- `src/`, `tests/`, `examples/`, `docs/`, `misc/`
- `.devcontainer/` with Dockerfile + devcontainer.json
- `dev.sh` with commands: `format`, `lint`, `lint-fix`, `typecheck`, `test`, `all-checks`, `versions`

Open in Dev Container (recommended)
-----------------------------------
Option A — Open Local Folder in Container
1) Clone the repo locally.
2) Open the folder in VS Code.
3) Use: Command Palette → “Dev Containers: Reopen in Container”.

Option B — Clone Repo in a Container Volume
1) VS Code → Command Palette → “Dev Containers: Clone Repository in Container Volume…”.
2) Paste this repo URL.
3) VS Code opens it directly inside the container.

When the container starts, it automatically runs:
- `uv venv --system-site-packages` (so the venv inherits system packages)
- `uv sync --extra dev` (installs project + dev tooling, but never PyTorch)
- JupyterLab on `http://localhost:8888` (no token)

Check versions:
- `./dev.sh versions`

GPU Access
----------
Run the dev container on a host with NVIDIA drivers and NVIDIA Container Toolkit. The devcontainer config includes `--gpus all --ipc host`. Inside the container, verify:

```
python -c "import torch; print(torch.cuda.is_available()); print(torch.version.cuda)"
```

Expect `True` and CUDA version output if GPU is available.

Installing additional packages
------------------------------
- Preferred: `uv add <pkg>` then `uv sync` (already uses a venv inheriting system site-packages). If `<pkg>` depends on torch, it will detect the preinstalled torch — no re-download.
- System environment: `uv pip install --system <pkg>` (installs into the base image Python).

Note: Do not add `torch`, `torchvision`, or `torchaudio` to the project’s default dependencies — they come from the base image. This avoids reinstalling PyTorch.

Data and Caches
---------------
- Caches are persisted via named volumes: pip, uv, torch, huggingface
- Local datasets folder is bind-mounted into `/workspaces/<repo>/datasets`
- Add your own data under `datasets/` or use the mounted `data/` volume

Developer Commands
------------------
- `./dev.sh format` — ruff format + black + isort
- `./dev.sh lint` — ruff check
- `./dev.sh lint-fix` — ruff check --fix
- `./dev.sh typecheck` — mypy (strict)
- `./dev.sh test` — pytest -n auto --reruns 2
- `./dev.sh all-checks` — format + lint-fix + typecheck + test
- `./dev.sh versions` — print Python / Torch / CUDA info

Using the Dev Container CLI (optional)
--------------------------------------
If you prefer the Dev Container CLI instead of VS Code UI:

- One-off via npx (no install):
  - `npx -y @devcontainers/cli build --workspace-folder .`
  - `npx -y @devcontainers/cli up --workspace-folder .`

The CLI requires Docker and access to `nvcr.io` (ensure `docker login nvcr.io`).

Notes
-----
- If you ever change the Python in the base image, update `requires-python` and tool target versions in `pyproject.toml`.
- If an added package hard-pins a different torch version, the resolver may try to fetch it. Keep torch out of project deps and rely on the preinstalled version.

Happy hacking!
