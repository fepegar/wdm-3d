default:
    @just --list

@install_uv:
	if ! command -v uv >/dev/null 2>&1; then \
		echo "uv is not installed. Installing..."; \
		curl -LsSf https://astral.sh/uv/install.sh | sh; \
	fi

@setup: install_uv
    uv sync

login: setup
    uv run huggingface-cli login

download_model: setup
    #!/usr/bin/env bash
    path=$(uv run -- huggingface-cli download \
        pfriedri/wdm-3d \
        lidc-idri_unet_128_1200k.pt)
    mkdir -p checkpoints
    ln -sf $path checkpoints/
    ln -sf $path checkpoints/lidc-idri_0000.pt

run:
    bash run.sh
