#!/bin/bash

email="$1"  
base_dir="$2"  
for dir in "$base_dir"/*; do
  if [ -d "$dir/.git" ]; then
    echo "Updating email in: $dir"
    git -C "$dir" config user.email "$email"
  fi
done
