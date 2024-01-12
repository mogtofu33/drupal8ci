ARG IMAGE_TAG='10.2'
ARG PHP_VERSION='8.2'

# https://github.com/docker-library/drupal/blob/master/$IMAGE_TAG/php$PHP_VERSION/apache-buster/Dockerfile
FROM drupal:${IMAGE_TAG}-php${PHP_VERSION}

ARG IMAGE_TAG='10.2'
ARG PHP_VERSION='8.2'
ARG IMAGE_VERSION='1.3'
ARG NODE_VERSION='18'

SHELL [ "bash", "-c" ]

COPY bash.bashrc /etc/bash.bashrc

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

# Install fnm and initiate it
RUN \
  apt-get update ; \
  apt-get install --no-install-recommends -y \
    apt-transport-https \
    bc \
    ca-certificates \
    curl \
    gettext-base \
    git \
    gnupg2 \
    jq \
    software-properties-common \
    ssh \
    sudo \
    unzip \
    vim \
    xsltproc \
    # Required for Drush sql commands.
    mariadb-client \
    postgresql-client \
    # Install PHP extensions.
    libicu-dev \
    imagemagick \
    libmagickwand-dev \
    libnss3-dev \
    libssl-dev \
    libxslt-dev ; \
  #==================
  # Install Nodejs with fnm, Yarn.
  # @see https://github.com/Schniz/fnm
  curl -fsSL https://fnm.vercel.app/install | bash -s -- --install-dir "/opt/fnm" --skip-shell ; \
  ln -s /opt/fnm/fnm /usr/bin/ && chmod +x /usr/bin/fnm ; \
  # Install node version as default
  /bin/bash -c "source /etc/bash.bashrc && fnm install ${NODE_VERSION}" ; \
  /bin/bash -c "source /etc/bash.bashrc && fnm alias default ${NODE_VERSION}" ; \
  # Add fnm for bash
  /bin/bash -c "source /etc/bash.bashrc && fnm use default" ; \
  /bin/bash -c 'source /etc/bash.bashrc && /bin/ln -s "/opt/fnm/aliases/default/bin/node" /usr/bin/node' ; \
  /bin/bash -c 'source /etc/bash.bashrc && /bin/ln -s "/opt/fnm/aliases/default/bin/npm" /usr/bin/npm' ; \
  /bin/bash -c 'source /etc/bash.bashrc && /bin/ln -s "/opt/fnm/aliases/default/bin/npx" /usr/bin/npx' ; \
  curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - ; \
  echo "deb [trusted=yes] https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list ; \
  apt-get update && apt-get install -y --no-install-recommends yarn ; \
  echo -e ' ' >> /etc/bash.bashrc ; \
  echo -e 'export PATH="$PATH:$(yarn global bin)"' >> /etc/bash.bashrc ; \
  # https://github.com/mlocati/docker-php-extension-installer
  docker-php-ext-install intl xsl mysqli bcmath calendar sockets pcntl opcache exif ftp ; \
  # Pin xdebug for db error, @see https://www.drupal.org/project/drupal/issues/3405976#comment-15346751
  pecl channel-update pecl.php.net && pecl install imagick xdebug-3.2.2 ; \
  docker-php-ext-enable imagick xdebug ; \
  # Cleanup.
  docker-php-source delete ; \
  apt-get autoremove -y ; \
  apt-get clean ; \
  rm -rf /var/lib/apt/lists/* ; \
  # clean up tmp
  rm -rf /tmp/*

#==================
# Install composer third party.
RUN /usr/local/bin/composer selfupdate
COPY --chown=www-data:www-data composer.json /var/www/.composer/composer.json

USER www-data

# Manage Composer.
WORKDIR /var/www/.composer

# Install our tools, see composer.json
RUN COMPOSER_MEMORY_LIMIT=-1 COMPOSER_ALLOW_SUPERUSER=1 composer install -n ; \
  composer clear-cache

WORKDIR /opt/drupal

USER root

#==================
# Install Drupal core:dev, Drush for a module.
# @todo remove phpspec/prophecy-phpunit when Drupal 9 is deprecated.
RUN COMPOSER_MEMORY_LIMIT=-1 COMPOSER_ALLOW_SUPERUSER=1 \
  composer require -n --dev --working-dir="/opt/drupal" \
    "drupal/core-dev:^${IMAGE_TAG}" "drush/drush" "phpspec/prophecy-phpunit:^2" ; \
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
    # Set bash for root and www-data
  rm -f /root/.bashrc ; \
  ln -s /etc/bash.bashrc /root/.bashrc ; \
  ln -s /etc/bash.bashrc /var/www/.bashrc ; \
  chown www-data:www-data /var/www/.bashrc ;

#==================
# Stay as root because it's a ci image.
# For obvious security reason, this image is NOT meant to be used by any production system.
# USER www-data
