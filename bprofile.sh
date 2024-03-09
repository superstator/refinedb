#!/usr/bin/env bash

start=${1:-500}
out=${2:-"out.tsv"}

unset DOCKER_BUILDKIT
docker build .
image=$(docker build . -q)

printf "n\tenums\trelease\telapsed\tkernel\tuser\n" | tee "$out"

for i in $(seq "$start" 500 20000); do
  docker run -t --rm "$image" /bin/bash -c "(cd migrations; ./migrations.sh 6 $i); RUSTFLAGS=-Awarnings /usr/bin/time -f \"$i\tfalse\tfalse\t%e\t%S\t%U\" cargo build -q" | tee -a "$out"
  docker run -t --rm "$image" /bin/bash -c "(cd migrations; ./migrations.sh 6 $i); RUSTFLAGS=-Awarnings /usr/bin/time -f \"$i\ttrue\tfalse\t%e\t%S\t%U\" cargo build --features=enums -q" | tee -a "$out"
  docker run -t --rm "$image" /bin/bash -c "(cd migrations; ./migrations.sh 6 $i); RUSTFLAGS=-Awarnings /usr/bin/time -f \"$i\tfalse\ttrue\t%e\t%S\t%U\" cargo build --release -q" | tee -a "$out"
  docker run -t --rm "$image" /bin/bash -c "(cd migrations; ./migrations.sh 6 $i); RUSTFLAGS=-Awarnings /usr/bin/time -f \"$i\ttrue\\ttrue\t%e\t%S\t%U\" cargo build --release --features=enums -q" | tee -a "$out"
done