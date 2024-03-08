#!/usr/bin/env bash

start=${1:-100}
out=${2:-"out.tsv"}

unset DOCKER_BUILDKIT
docker build .
image=$(docker build . -q)

printf "n\tenums\trelease\ttime\n" | tee "$out"

for i in $(seq "$start" 100 20000); do
  docker run -t --rm "$image" /bin/bash -c "(cd migrations; ./migrations.sh 6 $i); RUSTFLAGS=-Awarnings /usr/bin/time -f \"$i\tfalse\tfalse\t%Ss\" cargo build -q" | tee -a "$out"
  docker run -t --rm "$image" /bin/bash -c "(cd migrations; ./migrations.sh 6 $i); RUSTFLAGS=-Awarnings /usr/bin/time -f \"$i\ttrue\tfalse\t%Ss\" cargo build --features=enums -q" | tee -a "$out"
  docker run -t --rm "$image" /bin/bash -c "(cd migrations; ./migrations.sh 6 $i); RUSTFLAGS=-Awarnings /usr/bin/time -f \"$i\tfalse\ttrue\t%Ss\" cargo build --release -q" | tee -a "$out"
  docker run -t --rm "$image" /bin/bash -c "(cd migrations; ./migrations.sh 6 $i); RUSTFLAGS=-Awarnings /usr/bin/time -f \"$i\ttrue\ttrue\t%Ss\" cargo build --release --features=enums -q" | tee -a "$out"
done