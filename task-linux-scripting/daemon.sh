#!/bin/bash
file_path="/home/reload-php" 
while true; do
  if grep -q "1" "$file_path"; then
    sudo systemctl restart php7.4-fpm.service
    echo '' > $file_path
  fi
  sleep 1
done
