FROM debian:bullseye-slim

ARG IMAGE_VERSION='1.3'

LABEL name="chrome-headless"
LABEL maintainer="jean@dev-drupal.com"
LABEL version="${IMAGE_VERSION}"
LABEL description="Google Chrome Headless for CI usage"
LABEL org.label-schema.schema-version="${IMAGE_VERSION}"
LABEL org.label-schema.vendor="dev-drupal.com"

ARG CHROME_OPTS="--headless --no-sandbox --window-size=1600,800 --remote-debugging-address=0.0.0.0 --remote-debugging-port=9222"
ENV CHROME_OPTS=$CHROME_OPTS

RUN \
  apt-get update ; \
  apt-get install --no-install-recommends -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    procps ; \
  curl -sS -o - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - ; \
  echo "deb [arch=amd64] https://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list ; \
  apt-get update && apt-get install --no-install-recommends -y \
    google-chrome-stable ; \
  # Cleanup.
  apt-get purge --auto-remove -y curl gnupg ; \
  apt-get clean ; \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY start-chrome.sh /scripts/start-chrome.sh

RUN chmod +x /scripts/start-chrome.sh

RUN groupadd -r chrome && useradd -r -g chrome -G audio,video chrome ; \
  mkdir -p /home/chrome && chown -R chrome:chrome /home/chrome

USER chrome

EXPOSE 9222

ENTRYPOINT [ "/scripts/start-chrome.sh" ]