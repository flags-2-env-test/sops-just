FROM debian:bookworm-slim

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
      age bash ca-certificates coreutils curl git python3 tar \
    && rm -rf /var/lib/apt/lists/*

COPY scripts/install-tools.sh /tmp/install-tools.sh
RUN bash /tmp/install-tools.sh /usr/local/bin \
    && rm -f /tmp/install-tools.sh

WORKDIR /fixture
COPY . .

# The Docker build context intentionally excludes the caller's .git directory.
# Recreate a tiny repository so the same Git ignore/staging assertions run in
# the container without copying host Git metadata or history into the image.
RUN git init -q \
    && git config user.name fixture \
    && git config user.email fixture@example.invalid \
    && git add -A \
    && git commit -qm fixture

CMD ["just", "verify"]
