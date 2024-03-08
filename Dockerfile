FROM rust:1.75-slim

RUN apt-get update && apt-get install -y wamerican git libsqlite3-dev time

WORKDIR /root
RUN git clone --branch enum_migrations https://github.com/superstator/refinery.git

WORKDIR /root/refinedb

COPY migrations/ migrations/
COPY src/ src/
COPY Cargo.toml ./
COPY migrations.sh ./migrations/
COPY names ./migrations/

RUN rm -rf migrations/Generated
# prefetch crates
RUN cargo build && rm -rf target
