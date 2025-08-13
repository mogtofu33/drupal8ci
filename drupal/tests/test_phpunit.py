import pytest
import os

def test_drush(host):
  ''' Test phpunit exist '''
  assert host.file("/opt/drupal/vendor/bin/phpunit").exists
  assert host.file("/opt/drupal/vendor/bin/phpunit").mode == 0o755
  assert host.check_output("phpunit --version").startswith("PHPUnit 11")
