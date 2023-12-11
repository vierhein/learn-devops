#!/bin/bash
file_path="/home/reload-php"
while true; do
  if grep -q "1" "$file_path"; then
    sudo systemctl restart ${1}.service
    echo '' > $file_path
  fi
  sleep 1
done
