#!/bin/bash

version='118.0.5993.175'
data=$(curl https://chromium.googlesource.com/chromium/src/+/refs/tags/${version}) 
position=$(echo $data | grep Cr-Branched-From: | grep -oP '\{#(\d+)\}' | grep -oP '\d+')
echo "this is $position"
# uri=$(echo $data | grep -oP '(?<=parent).*?(?=diff)' | grep -oP '<a[^>]*href="\K[^"]*' | sed -n 1p)
# url="https://chromium.googlesource.com${uri}"

while [ -z "$position" ]; do
    uri=$(echo $data | grep -oP '(?<=parent).*?(?=diff)' | grep -oP '<a[^>]*href="\K[^"]*' | sed -n 1p)
    url="https://chromium.googlesource.com${uri}"
    echo $url
    echo "in while"
    data=$(curl $url)
    position=$(echo $data | grep Cr-Branched-From: | grep -oP '\{#(\d+)\}' | grep -oP '\d+')
    echo $position
    sleep 5
done

# DOWNLOAD_LINK=$(jq -r ".linux64.\"${CHROMIUM_VERSION}\".download_url" chromium.stable.json) 
# wget --no-check-certificate -O chromium.zip ${DOWNLOAD_LINK} 
# unzip chromium.zip 
# rm -f chromium.zip chromium.stable.json 
# # Configure --no-sandbox and --ignore-certificate-errors
# sed -i 's/\"$@\"/--no-sandbox --ignore-certificate-errors \"$@\"/' chrome-linux/chrome-wrapper 
# ln -s /opt/chrome-linux/chrome-wrapper /usr/bin/chromium