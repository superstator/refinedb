#!/usr/bin/env bash

#mapfile -t names < <(grep -E '^[a-z]{3,}$' /usr/share/dict/words | sort -Ru | xargs -n 3 echo | tr ' ' '_')
mapfile -t names < names

rs_frac=2

for i in $(seq "$1" "$2"); do
  name=${names[$i]}
  if [ $(($RANDOM % $rs_frac)) -eq 0 ]; then
    cat > "V${i}__t_${name}.rs" <<- HERE
use barrel::{types, Migration};

use crate::Sql;

pub fn migration() -> String {
    let mut m = Migration::new();

    m.inject_custom("insert into migrations (name, id) values ('$name', $i)");

    m.make::<Sql>()
}
HERE
  else
    cat > "V${i}__t_${name}.sql" <<- HERE
insert into migrations (name, id) values ('$name', $i);
HERE
  fi
done