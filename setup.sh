#!/bin/bash
# One-time installer for Linux / GitHub Codespaces: Rust, WASM target, Substreams CLI, jq.
set -e
if ! command -v cargo >/dev/null 2>&1; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --profile minimal
fi
. "$HOME/.cargo/env"
rustup target add wasm32-unknown-unknown

if ! command -v substreams >/dev/null 2>&1; then
  ARCH=$(uname -m); [ "$ARCH" = "aarch64" ] && ARCH=arm64
  OS=$(uname -s | tr '[:upper:]' '[:lower:]')
  curl -sL "https://github.com/streamingfast/substreams/releases/download/v1.26.0/substreams_${OS}_${ARCH}.tar.gz" | tar xz substreams
  sudo mv substreams /usr/local/bin/ 2>/dev/null || mv substreams "$HOME/.cargo/bin/"
fi

command -v jq >/dev/null 2>&1 || sudo apt-get install -y jq

echo "Setup complete:"; cargo --version; substreams --version; jq --version
echo "Now run:  source \$HOME/.cargo/env"
