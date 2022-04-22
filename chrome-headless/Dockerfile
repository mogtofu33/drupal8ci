FROM debian:bullseye-slim

LABEL name="chrome-headless" \
	maintainer="dev-drupal.com" \
	version="1.0" \
	description="Google Chrome Headless for CI usage"

ENV CHROME_OPTS="--headless --no-sandbox --window-size=1920,1080 --remote-debugging-address=0.0.0.0 --remote-debugging-port=9222"

RUN apt-get update && apt-get install -y \
	apt-transport-https \
	ca-certificates \
	curl \
	gnupg \
	procps \
	--no-install-recommends \
	&& curl -sS -o - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
	&& echo "deb [arch=amd64] https://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list \
	&& apt-get update && apt-get install --no-install-recommends -y \
	google-chrome-stable \
	&& apt-get purge --auto-remove -y curl gnupg \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY start-chrome.sh /scripts/start-chrome.sh

RUN chmod +x /scripts/start-chrome.sh

RUN groupadd -r chrome && useradd -r -g chrome -G audio,video chrome \
	&& mkdir -p /home/chrome && chown -R chrome:chrome /home/chrome

USER chrome

EXPOSE 9222

ENTRYPOINT [ "/scripts/start-chrome.sh" ]