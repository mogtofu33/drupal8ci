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
  # ("node"), # Installed with fnm
  ("yarn"),
])
def test_packages_installed(host, name):
  ''' Test a minimum of required packages '''
  pkg = host.package(name)
  assert pkg.is_installed

# def test_node(host):
#   assert host.check_output('bash -c "fnm -V"').startswith('fnm')

# def test_node(host):
#   assert host.check_output('bash -c "fnm current"').startswith('v18')
