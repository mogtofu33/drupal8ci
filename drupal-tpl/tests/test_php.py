import pytest

def test_php_version(host):
  ''' Check PHP version so it's highlighted when changed '''
  assert host.check_output('php -v').startswith('PHP $PHP_VERSION')

@pytest.mark.parametrize("name", [
  ("bcmath"),
  ("calendar"),
  ("exif"),
  ("ftp"),
  ("intl"),
  ("mysqli"),
  ("OPcache"),
  ("pcntl"),
  ("pdo_mysql"),
  ("pdo_pgsql"),
  ("pdo_sqlite"),
  ("sockets"),
  ("xdebug"),
  ("xsl"),
])
def test_php_modules(host, name):
  ''' Test the minimum list of needed extensions '''
  assert host.check_output('php -m | grep ' + name)
