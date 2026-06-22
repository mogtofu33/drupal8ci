ARG IMAGE_TAG=11.3
ARG PHP_VERSION=8.5

# https://github.com/docker-library/drupal/blob/master/$IMAGE_TAG/php$PHP_VERSION
FROM drupal:${IMAGE_TAG}-php${PHP_VERSION}

ARG IMAGE_VERSION=1.0
ARG NODE_VERSION=22

ARG IMAGE_TAG=11.3
ARG PHP_VERSION=8.5

LABEL name="drupal-ci-${IMAGE_TAG}"
LABEL maintainer="jean@dev-drupal.com"
LABEL version="${IMAGE_VERSION}"
LABEL description="Drupal CI images for project https://gitlab.com/mog33/gitlab-ci-drupal"
LABEL org.label-schema.schema-version="${IMAGE_VERSION}"
LABEL org.label-schema.name="gitlab-ci-drupal/drupal-ci-images"
LABEL org.label-schema.description="Drupal CI images for project https://gitlab.com/mog33/gitlab-ci-drupal"
LABEL org.label-schema.url="https://mog33.gitlab.io/gitlab-ci-drupal"
LABEL org.label-schema.vcs-url="https://gitlab.com/gitlab-ci-drupal/drupal-ci-images"
LABEL org.label-schema.vendor="dev-drupal.com"

# Install needed programs, PHP extensions, and update composer.
RUN set -ue ; \
  apt-get -qq update ; \
  apt-get -qq install --no-install-recommends -y \
    apt-transport-https \
    bc \
    gettext-base \
    git \
    gnupg2 \
    jq \
    ssh \
    sudo \
    unzip \
    vim \
    mariadb-client \
    postgresql-client \
    libicu-dev \
    imagemagick \
    libmagickwand-dev \
    libnss3-dev \
    libssl-dev \
    libxslt-dev \
    xsltproc ; \
  docker-php-ext-install intl xsl mysqli bcmath calendar sockets pcntl exif ; \
  pecl channel-update pecl.php.net && \
    pecl install apcu xdebug imagick ; \
  docker-php-ext-enable apcu xdebug imagick ; \
  docker-php-source delete ; \
  /usr/local/bin/composer selfupdate ; \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#==================
# Install Nodejs, Yarn.
# https://github.com/nodesource/distributions#installation-instructions
RUN set -ue ; \
  curl -fsSL https://deb.nodesource.com/setup_${NODE_VERSION}.x | bash - ; \
  apt-get install -y nodejs ; \
  rm -rf /var/lib/apt/lists/* ; \
  corepack enable ; \
  corepack prepare yarn@4.2.2 --activate

COPY --chown=www-data:www-data composer.json /var/www/.composer/composer.json

USER www-data

# Manage Composer.
WORKDIR /var/www/.composer

# Install our tools, see composer.json
RUN COMPOSER_MEMORY_LIMIT=-1 COMPOSER_ALLOW_SUPERUSER=1 composer install ; \
  composer clear-cache

WORKDIR /opt/drupal

USER root

#==================
# Install Drupal core:dev and Drush.
RUN COMPOSER_MEMORY_LIMIT=-1 COMPOSER_ALLOW_SUPERUSER=1 \
    composer require --dev --working-dir="/opt/drupal" "drupal/core-dev:^${IMAGE_TAG}" drush/drush --with-all-dependencies ; \
  composer clear-cache

#==================
# Include testing code.
COPY --chown=www-data:www-data ./tests/ /tests/

#==================
# Manage final tasks.
RUN chmod 777 /var/www ; \
  chown -R www-data:www-data /var/www ; \
  # Symlink composer downloaded binaries.
  ln -sf /var/www/.composer/vendor/bin/* /usr/local/bin ; \
  # Phpunit 9+ cache.
  chown www-data:www-data /opt/drupal/web/core ; \
  # Tests scripts.
  chmod +x /tests/*.sh ; \
  # Fix Php performances.
  mv /usr/local/etc/php/php.ini-development /usr/local/etc/php/php.ini ; \
  sed -i "s#memory_limit = 128M#memory_limit = 4G#g" /usr/local/etc/php/php.ini ; \
  sed -i "s#max_execution_time = 30#max_execution_time = 90#g" /usr/local/etc/php/php.ini ; \
  sed -i "s#;max_input_nesting_level = 64#max_input_nesting_level = 512#g" /usr/local/etc/php/php.ini ; \
  # Convenient alias for root and www-data.
  echo "alias ls='ls --color=auto -lAh'" >> /root/.bashrc ; \
  echo "alias l='ls --color=auto -lAh'" >> /root/.bashrc ; \
  echo "alias dr='drush --root=/opt/drupal/web'" >> /root/.bashrc ; \
  cp /root/.bashrc /var/www/.bashrc ; \
  chown www-data:www-data /var/www/.bashrc ;

#==================
# Stay as root because it's a ci image.
# For obvious security reason, this image is NOT meant to be used by any production system.
# USER www-data
