set shell := ["bash", "-euo", "pipefail", "-c"]

verify:
    @bash scripts/assert.sh

verify-docker:
    @docker build --tag sops-just-runtime-fixture . >/dev/null
    @docker run --rm sops-just-runtime-fixture
