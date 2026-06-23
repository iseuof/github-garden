#!/bin/bash

set -e

mkdir -p garden
touch garden/grass.txt

start_date="2020-01-01"
end_date="2026-06-21"
current="$start_date"

while [[ "$current" < "$end_date" || "$current" == "$end_date" ]]; do
  level=$((RANDOM % 100))

  if [ $level -lt 10 ]; then
    commits=1
  elif [ $level -lt 45 ]; then
    commits=$((RANDOM % 2 + 2))
  elif [ $level -lt 80 ]; then
    commits=$((RANDOM % 4 + 4))
  else
    commits=$((RANDOM % 8 + 8))
  fi

  for i in $(seq 1 $commits); do
    hour=$((RANDOM % 12 + 9))
    minute=$((RANDOM % 60))
    second=$((RANDOM % 60))

    echo "$current $i $RANDOM" >> garden/grass.txt
    git add garden/grass.txt

    GIT_AUTHOR_DATE="${current}T$(printf "%02d:%02d:%02d" $hour $minute $second)" \
    GIT_COMMITTER_DATE="${current}T$(printf "%02d:%02d:%02d" $hour $minute $second)" \
    git commit -m "garden: $current #$i" >/dev/null
  done

  current=$(date -j -v+1d -f "%Y-%m-%d" "$current" "+%Y-%m-%d")
done

git push origin main
