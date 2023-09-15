import pytest
import configparser

config = configparser.ConfigParser()

def test_php_ini(host):
  assert host.file("/usr/local/etc/php/php.ini").exists

def test_php_ini_values(host):
  ''' Check important config that should be highlighted when changed '''
  config.read('/usr/local/etc/php/php.ini')
  assert config['PHP']['max_execution_time'] == '90'
  assert config['PHP']['max_input_nesting_level'] == '512'
  assert config['PHP']['memory_limit'] == '4G'
