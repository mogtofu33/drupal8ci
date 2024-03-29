import pytest
import os

def test_drush(host):
  ''' Test drush exist '''
  assert host.file("/opt/drupal/vendor/bin/drush").exists
  assert host.file("/opt/drupal/vendor/bin/drush").mode == 0o755
  assert host.check_output("drush --version").startswith("Drush Commandline Tool")
  # assert host.check_output("drush --root=/opt/drupal/web status --field=drupal-version").startswith("$DRUPAL_VERSION")