# sops-just

Reference fixture for the ORESoftware SOPS environment contract using **SOPS + age + just** without Nix.

This fixture intentionally has **no committed private identity and no committed ciphertext**. Every test run generates a fresh age identity under a private temporary directory, derives its public recipient, generates dummy dev/prod SOPS ciphertext at the canonical paths, validates decryption and the root `.env` symlink contract, then removes all runtime state.

The same contract runs on the GitHub Actions host and inside a clean container. This gives real encryption/decryption coverage without teaching a test-only exception to the production rule that private identities never belong in Git.

## Contract exercised

- plaintext dotenv paths are ignored everywhere;
- only `env/enc/dev.env.enc` and `env/enc/prod.env.enc` are allowlisted ciphertext paths;
- `.env.enc` operations force SOPS dotenv input/output types and use filename override for creation-rule selection;
- decrypted files live only under ignored `env/dec/`, mode `0600`;
- root `.env` is an ignored relative symlink and unmanaged root `.env` files are refused;
- a fresh/no-identity decrypt attempt fails;
- generated identities, decrypted values, and helper state are not tracked or emitted as artifacts;
- the host and container execute the same `scripts/assert.sh` contract.

All values in `fixtures/*.fixture.dotenv` are synthetic test data.

## Run

```sh
just verify
just verify-docker
```

Tracking: DEN-2919 / DEN-2636.
