FROM debian:latest

ARG CHROMIUM_VERSION

RUN apt-get update && apt-get install -y \
    apache2 \
    php \
    jq \
    unzip \
    wget

# Parse the json and download
WORKDIR /opt
COPY chromium.stable.json .
RUN DOWNLOAD_LINK=$(jq -r ".linux64.\"${CHROMIUM_VERSION}\".download_url" chromium.stable.json) && \
    wget --no-check-certificate -O chromium.zip ${DOWNLOAD_LINK} && \
    unzip chromium.zip && \
    rm -f chromium.zip && \
    # Configure --no-sandbox and --ignore-certificate-errors
    sed -i 's/\"$@\"/--no-sandbox --ignore-certificate-errors \"$@\"/' chrome-linux/chrome-wrapper && \
    ln -s /opt/chrome-linux/chrome-wrapper /usr/bin/chromium

# Delete unused dependencis
RUN apt-get remove -y jq unzip wget
