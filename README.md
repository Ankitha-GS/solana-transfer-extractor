# Solana Transfer Extraction — Substreams

A Rust Substreams module that extracts transfers from Solana blocks
**385870151 → 385870156** and outputs one JSON line per transfer:

```json
{"from": "Eq1c3uNugn3FRpJ99K2q1ZyQrora3jntUqvkMnGroKkB", "to": "4XpSNfoNfireSgdg8hY6Ng3dWrHjewZhmCancypjbcCN", "amount": 325253}
```

## What counts as a transfer

The module walks **every instruction, including inner (CPI) instructions**, of every
**successful** transaction and extracts:

| Program | Instructions | Amount unit |
|---|---|---|
| System Program (`111...111`) | `Transfer`, `TransferWithSeed` | lamports (native SOL) |
| SPL Token & Token-2022 | `Transfer`, `TransferChecked` | token base units |

SPL token instructions reference *token accounts*, not wallets. To output real wallet
addresses, the module maps each token account to its owner using the transaction's
`pre_token_balances` / `post_token_balances` metadata.

## Project layout

```
proto/transfers.proto      Protobuf schema (Transfers / Transfer)
src/lib.rs                 map_transfers module (decoding logic)
src/pb/                    Rust types for the protobuf schema
substreams.yaml            Substreams manifest
solana-transfers-v0.1.0.spkg   Built package
.unifiedhiring/setup.sh    Installs Rust, WASM target, Substreams CLI, jq
.unifiedhiring/run.sh      Builds, packs, runs, and formats output
```

## How to run

```bash
./.unifiedhiring/setup.sh && source $HOME/.cargo/env   # one-time install
export SUBSTREAMS_API_KEY="<key from https://thegraph.market>"
./.unifiedhiring/run.sh
```

`run.sh` does: `cargo build` → `substreams pack` → `substreams run` on the 6 blocks →
formats each transfer with `jq` into the exact required JSON line, saved to `transfers_output.jsonl`.

### Why jq?
Protobuf's JSON encoding prints 64-bit integers as strings (`"amount": "325253"`).
The `jq` step prints the amount as a bare integer without any precision loss.

## Verification

Before having an API key, the decoding logic was cross-checked by applying the same rules
to the same six blocks fetched from the public Solana RPC (`getBlock`). Result: ~4,000
transfers across the 6 blocks (mix of SOL and SPL token transfers).
