import pytest

@pytest.mark.parametrize("folder", [
  ("/opt/drupal/web/core"),
  ("/opt/drupal/web/modules"),
  ("/opt/drupal/web/themes"),
  ("/opt/drupal/web/sites"),
  ("/var/www"),
])
def test_permissions(host, folder):
  ''' Test folder permissions '''
  assert host.file(folder).user == "www-data"
  assert host.file(folder).group == "www-data"