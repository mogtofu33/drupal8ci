import pytest

def test_drush(host):
  ''' Test drush exist '''
  assert host.file("/opt/drupal/vendor/bin/drush").exists
  assert host.file("/opt/drupal/vendor/bin/drush").mode == 0o755
  assert host.file("drush --version").startwith("Drush Commandline Tool")
  assert host.file("drush --root=/opt/drupal/web status --field=drupal-version").startwith("$DRUPAL_VERSION")
