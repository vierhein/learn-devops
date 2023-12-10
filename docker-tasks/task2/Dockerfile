FROM debian:latest

ARG CHROMIUM_VERSION

RUN apt-get update && apt-get install -y \
    apache2 \
    jq \
    php \
    unzip \ 
    wget

# Install dependencis for chromium
RUN apt-get install -y ca-certificates fonts-liberation libappindicator3-1 \
    libasound2 libatk-bridge2.0-0 libatk1.0-0 libc6 libcairo2 libcups2 \
    libdbus-1-3 libexpat1 libfontconfig1 libgbm1 libgcc1 libglib2.0-0 \
    libgtk-3-0 libnspr4 libnss3 libpango-1.0-0 libpangocairo-1.0-0 \
    libstdc++6 libx11-6 libx11-xcb1 libxcb1 libxcomposite1 libxcursor1 \
    libxdamage1 libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libxss1 \
    libxtst6 lsb-release xdg-utils

# Parse the json and download
WORKDIR /opt
COPY chromium.stable.json .
RUN DOWNLOAD_LINK=$(jq -r ".linux64.\"${CHROMIUM_VERSION}\".download_url" chromium.stable.json) \
    && wget --no-check-certificate -O chromium.zip ${DOWNLOAD_LINK} \
    && unzip chromium.zip \
    && rm -f chromium.zip chromium.stable.json \
    # Configure --no-sandbox and --ignore-certificate-errors
    && sed -i 's/\"$@\"/--no-sandbox --ignore-certificate-errors \"$@\"/' chrome-linux/chrome-wrapper \
    && ln -s /opt/chrome-linux/chrome-wrapper /usr/bin/chromium

# Delete unused dependencis
RUN apt-get remove -y jq unzip wget
