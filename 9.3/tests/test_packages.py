import pytest

@pytest.mark.parametrize("name", [
  ("bash"),
  ("bc"),
  ("curl"),
  ("git"),
  ("jq"),
  ("gettext"),
  ("openssh"),
  ("xsltproc"),
  ("mariadb-client"),
  ("postgresql-client"),
  ("node"),
  ("yarn"),
])
def test_packages_installed(host, name):
  ''' Test a minimum of required packages '''
  pkg = host.package(name)
  assert pkg.is_installed
