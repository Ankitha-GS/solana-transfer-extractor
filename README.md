# Solana Transfer Extractor

A Rust-based Substreams project that extracts SOL and token transfer information from Solana blockchain blocks.

## Overview

The program processes selected Solana blocks and extracts:

- Sender address
- Receiver address
- Transfer amount

Each transfer is represented as a JSON object:

```json
{"from":"sender_address","to":"receiver_address","amount":325253}
```

## Tech Stack

- Rust
- Substreams
- Solana
- WebAssembly (WASM)
- jq

## Project Structure

```text
├── Cargo.toml
├── Cargo.lock
├── rust-toolchain.toml
├── substreams.yaml
├── solana-transfers-v0.1.0.spkg
├── setup.sh
├── run.sh
├── scratch.txt
└── task.md
```

## Setup

Run the setup script:

```bash
chmod +x setup.sh run.sh
./setup.sh
```

Load the Rust environment:

```bash
source "$HOME/.cargo/env"
```

## Configuration

Set your Substreams API key:

```bash
export SUBSTREAMS_API_KEY="YOUR_API_KEY"
```

## Run

```bash
./run.sh
```

## Output

The extracted transfers are displayed in the terminal and saved to:

```text
transfers_output.jsonl
```

Each line contains one transfer in JSON format.

## Author

Ankitha G S

GitHub: [Ankitha-GS](https://github.com/Ankitha-GS)
