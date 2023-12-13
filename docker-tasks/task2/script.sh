#!/bin/bash
version='119.0.6045.58'
curl -L https://chromium.googlesource.com/chromium/src/+/refs/tags/${version} > tmp 
position=$(cat tmp | grep Cr-Branched-From: | grep -oP '/heads/main@\{#\K[^}]+')

echo "this is $position"
# uri=$(echo $data | grep -oP '(?<=parent).*?(?=diff)' | grep -oP '<a[^>]*href="\K[^"]*' | sed -n 1p)
# url="https://chromium.googlesource.com${uri}"

while [ -z "$position" ]; do
    uri=$(cat tmp | grep -oP '(?<=parent).*?(?=diff)' | grep -oP '<a[^>]*href="\K[^"]*' | sed -n 1p)
    url="https://chromium.googlesource.com${uri}"
    echo $url
    echo "in while"
    curl -L $url > tmp
    position=$(cat tmp | grep Cr-Branched-From: | grep -oP '/heads/main@\{#\K[^}]+')
    echo $position
done

DOWNLOAD_LINK="https://commondatastorage.googleapis.com/chromium-browser-snapshots/Linux_x64/${position}/chrome-linux.zip" 
wget --no-check-certificate -O chromium.zip ${DOWNLOAD_LINK} 
# unzip chromium.zip 
# rm -f chromium.zip 
# # Configure --no-sandbox and --ignore-certificate-errors
# sed -i 's/\"$@\"/--no-sandbox --ignore-certificate-errors \"$@\"/' chrome-linux/chrome-wrapper 
# ln -s /opt/chrome-linux/chrome-wrapper /usr/bin/chromium