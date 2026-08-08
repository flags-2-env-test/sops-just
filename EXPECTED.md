# Expected behavior

`just verify` and the container job run the same `scripts/assert.sh` contract. A passing run proves all of the following without committing or printing a private identity:

1. A fresh age identity is generated at runtime with private-file mode `0600`.
2. Exact creation rules select `env/enc/dev.env.enc` and `env/enc/prod.env.enc`.
3. SOPS treats `.env.enc` as dotenv explicitly and encrypts values while leaving variable names reviewable.
4. Synthetic plaintext values do not appear in generated ciphertext.
5. Decryption without the generated identity fails.
6. Dev and prod values round-trip exactly, including values containing additional `=` and `&` characters.
7. Decrypted files are written only under ignored `env/dec/` and remain mode `0600`.
8. An unmanaged root `.env` is never overwritten.
9. Managed root `.env` is a relative symlink to an approved `env/dec/*.env` target.
10. Plaintext `.env`, nested `.env.local`, and `env/dec/**` are ignored, while only the two canonical ciphertext paths are allowlisted.
11. A normal temporary Git index cannot add ignored plaintext state but can add exactly the two approved ciphertext paths.
12. The committed branch contains no private age identity and no tracked plaintext dotenv path.
13. All generated identity, config, ciphertext, decrypted files, and root symlink are removed when the assertion exits.
