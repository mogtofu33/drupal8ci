import pytest

@pytest.mark.parametrize("name", [
  ("bash"),
  ("bc"),
  ("curl"),
  ("git"),
  ("jq"),
  ("gettext-base"),
  ("ssh"),
  ("xsltproc"),
  ("mariadb-client"),
  ("postgresql-client"),
  ("nodejs"),
  ("yarn"),
])
def test_packages_installed(host, name):
  ''' Test a minimum of required packages '''
  pkg = host.package(name)
  assert pkg.is_installed

def test_node(host):
  assert host.check_output('node -v').startswith('v18')
