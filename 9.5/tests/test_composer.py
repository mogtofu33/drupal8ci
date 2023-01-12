import pytest

def test_composer(host):
  assert host.check_output('composer -V').startswith('Composer version 2')
  assert host.file("/var/www/.composer/composer.json").exists

@pytest.mark.parametrize("bin", [
  ("parallel-lint"),
  ("pdepend"),
  ("phpcs"),
  ("phploc"),
  ("phpmd"),
  ("phpmetrics"),
  ("phpqa"),
  ("phpstan"),
  ("robo"),
])
def test_composer_bin(host, bin):
  ''' Test bin exist '''
  assert host.file("/var/www/.composer/vendor/bin/" + bin).exists
  assert host.file("/usr/local/bin/" + bin).is_symlink
  assert host.file("/usr/local/bin/" + bin).mode == 0o777

def test_phpcs_standard(host):
  '''' Test phpcs standards '''
  assert host.check_output('phpcs -i').__contains__('Drupal')
  assert host.check_output('phpcs -i').__contains__('DrupalPractice')
