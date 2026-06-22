import pytest

def test_composer(host):
  assert host.check_output('composer -V').startswith('Composer version 2')
  assert host.file("/var/www/.composer/composer.json").exists

@pytest.mark.parametrize("bin,version", [
  ("parallel-lint", "PHP Parallel Lint"),
  ("pdepend", ""),
  ("phpcs", "PHP_CodeSniffer version"),
  ("phploc", "phploc"),
  ("phpmd", ""),
  ("phpmetrics", "\nPhpMetrics"),
  ("phpqa", "Robo"),
  ("phpstan", "PHPStan"),
  ("robo", "Robo"),
])
def test_composer_bin(host, bin, version):
  ''' Test bin exist '''
  assert host.file("/var/www/.composer/vendor/bin/" + bin).exists
  assert host.file("/usr/local/bin/" + bin).is_symlink
  assert host.check_output("/usr/local/bin/" + bin + " --version").startswith(version)

def test_phpcs_standard(host):
  '''' Test phpcs standards '''
  assert host.check_output('phpcs -i').__contains__('Drupal')
  assert host.check_output('phpcs -i').__contains__('DrupalPractice')
