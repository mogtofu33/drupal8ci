# https://github.com/docker-library/drupal/blob/master/9.5/php8.1/apache-buster/Dockerfile
FROM drupal:9.5-php8.1

LABEL name="drupal-ci-9.5"
LABEL maintainer="jean@dev-drupal.com"
LABEL version="1.1"
LABEL description="Drupal CI images for project https://gitlab.com/mog33/gitlab-ci-drupal"
LABEL org.label-schema.schema-version="1.2"
LABEL org.label-schema.name="gitlab-ci-drupal/drupal-ci-images"
LABEL org.label-schema.description="Drupal CI images for project https://gitlab.com/mog33/gitlab-ci-drupal"
LABEL org.label-schema.url="https://mog33.gitlab.io/gitlab-ci-drupal"
LABEL org.label-schema.vcs-url="https://gitlab.com/gitlab-ci-drupal/drupal-ci-images"
LABEL org.label-schema.vendor="dev-drupal.com"

# Install needed programs.
RUN apt-get update ; \
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
    xsltproc ; \
  apt-get clean ; \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* ;

#==================
# Install Nodejs, Yarn.
# https://github.com/nodesource/distributions#installation-instructions
RUN set -uex; \
  mkdir -p /etc/apt/keyrings; \
  curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key \
    | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg; \
  echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_18.x nodistro main" \
    > /etc/apt/sources.list.d/nodesource.list; \
  # Install Yarn.
  curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - ; \
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list ; \
  apt-get update ; \
  apt-get install --no-install-recommends -y \
    nodejs \
    yarn \
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
  # https://github.com/mlocati/docker-php-extension-installer
  docker-php-ext-install intl xsl mysqli bcmath calendar sockets pcntl opcache exif ftp ; \
  # Pin xdebug for db error, @see https://www.drupal.org/project/drupal/issues/3405976#comment-15346751
  pecl channel-update pecl.php.net && pecl install imagick xdebug-3.2.2 ; \
  docker-php-ext-enable imagick xdebug ; \
  # Cleanup.
  docker-php-source delete ; \
  apt-get clean ; \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* ;

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
    "drupal/core-dev:^9.5" "drush/drush" "phpspec/prophecy-phpunit:^2" ; \
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
