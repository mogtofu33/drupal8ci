import pytest

def test_php_version(host):
	''' Check PHP version so it's highlighted when changed '''
	assert host.check_output('php -v').startswith('PHP 8.0')

# @pytest.mark.parametrize("name", [
# 	("bcmath"),
# 	("gd"),
# 	("pdo_pgsql"),
# 	("intl"),
# 	("zip"),
# 	("xsl"),
# 	("OPcache"),
# 	("apcu"),
# 	("igbinary"),
# 	("redis"),
# ])
# def test_php_modules(host, name):
# 	''' Test the minimum list of needed extensions '''
# 	assert host.check_output('php -m | grep ' + name)

# def test_deploy_scripts_exists(host):
# 	assert host.file("/scripts/drupal-deploy.sh").exists
# 	assert host.file("/scripts/drupal-ensure-nfs.sh").exists
# 	assert host.file("/scripts/drupal-maintenance.sh").exists
