#!/bin/bash
# Build the Substreams package and stream transfers for Solana blocks 385870151-385870156.
#
# Requirements: Rust (rustup), substreams CLI, jq, and an API key from https://thegraph.market
#   export SUBSTREAMS_API_KEY="your-key-here"
set -e
cd "$(dirname "$0")/.."

if [ -z "$SUBSTREAMS_API_KEY" ]; then
  echo "ERROR: set your key first:  export SUBSTREAMS_API_KEY=\"your-key\"" >&2
  exit 1
fi

# 1. Compile Rust -> WASM
rustup target add wasm32-unknown-unknown >/dev/null 2>&1 || true
cargo build --target wasm32-unknown-unknown --release

# 2. Package into an .spkg
substreams pack ./substreams.yaml

# 3. Run on blocks 385870151..385870156 (stop block is exclusive, so +6)
#    and print one JSON line per transfer in the required format.
substreams run ./solana-transfers-v0.1.0.spkg map_transfers \
  -e mainnet.sol.streamingfast.io:443 \
  -s 385870151 -t +6 \
  -o jsonl \
| jq -r --unbuffered '
    select(.["@data"] != null)
    | .["@data"].transfers[]?
    | "{\"from\": \"\(.from)\", \"to\": \"\(.to)\", \"amount\": \(.amount // 0)}"
  ' | tee transfers_output.jsonl

echo "Done. $(wc -l < transfers_output.jsonl) transfers saved to transfers_output.jsonl" >&2
