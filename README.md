# Drupal 9/10 CI Docker image for Gitlab CI

## Details

[Drupal 9/10](https://www.drupal.org) ci image based on official [docker Drupal](https://github.com/docker-library/drupal)
with some Php/NodeJs tools needed for CI or Local Build/Test/Lint.

Used with project [Gitlab CI Drupal](https://gitlab.com/mog33/gitlab-ci-drupal).

* Fork from [juampynr/drupal8ci](https://hub.docker.com/r/juampynr/drupal8ci/~/dockerfile/)
* Based on [Drupal official image](https://github.com/docker-library/drupal), added
  * [Node.js](https://nodejs.org/en/) + [Yarn](https://yarnpkg.com)
  * [Google chrome stable](https://dl.google.com/linux/chrome/deb/) + [Chromedriver](http://chromedriver.chromium.org)
  * [Robo CI](http://robo.li)
  * [Phpqa](https://github.com/EdgedesignCZ/phpqa) including:
    * [Phpmetrics](https://www.phpmetrics.org)
    * [Phploc](https://github.com/sebastianbergmann/phploc)
    * [Phpcs](https://github.com/squizlabs/PHP_CodeSniffer)
    * [Phpmd](https://phpmd.org)
    * [Pdepend](https://pdepend.org)
    * [Phpcpd](https://github.com/sebastianbergmann/phpcpd)
  * [Security checker](https://github.com/fabpot/local-php-security-checker)
  * [phpstan](https://github.com/phpstan/phpstan)
  * [phpstan-drupal](https://github.com/mglaman/phpstan-drupal)
  * [Drupal Coder](https://www.drupal.org/project/coder)
  * Mariadb (MySQL) client (For Drush sql commands)
  * Php with extensions:
    *  intl xsl mysqli bcmath calendar sockets pcntl opcache exif ftp imagick xdebug
  * [jq](https://stedolan.github.io/jq/)
  * [bc](https://www.gnu.org/software/bc/)

## Basic usage (local)

All images are based on official [docker Drupal](https://github.com/docker-library) images managed by Composer.

To use with a local Drupal 9/10 managed by Composer, mount your Drupal on `/opt/drupal/`

## Issues

* ...

## Build

CI variable `CI_DO_RELEASE`, default to `1` to push to Docker hub.

```bash
make prepare
```

## Tests

Basic version check tests with [Obvious Shell Testing (osht)](https://github.com/coryb/osht).

```bash
docker run -it --rm mogtofu33/drupal8ci:3.x-dev-9.3 /scripts/run-tests.sh
```

----
Want some help implementing this on your project? I provide Drupal expertise as a freelance, just [contact me](https://developpeur-drupal.com/en).
