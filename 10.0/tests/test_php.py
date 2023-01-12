import pytest

def test_php_version(host):
  ''' Check PHP version so it's highlighted when changed '''
  assert host.check_output('php -v').startswith('PHP 8.2')

@pytest.mark.parametrize("name", [
  ("sockets"),
  ("ftp"),
  ("intl"),
  ("xsl"),
  ("mysqli"),
  ("pdo_mysql"),
  ("pdo_pgsql"),
  ("pdo_sqlite"),
  ("OPcache"),
  ("xdebug"),
])
def test_php_modules(host, name):
  ''' Test the minimum list of needed extensions '''
  assert host.check_output('php -m | grep ' + name)
