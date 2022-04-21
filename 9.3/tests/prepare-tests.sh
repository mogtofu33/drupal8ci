#!/bin/bash
set -eu

_install_packages() {
  if ! [ -x "$(command -v python3)" ]; then
    apk add --no-cache --no-progress --quiet python3
  fi
  if ! [ -x "$(command -v pip3)" ]; then
    # https://pip.pypa.io/en/stable/installing/
    curl -s https://bootstrap.pypa.io/get-pip.py -o get-pip.py
    python3 get-pip.py --quiet
  fi
  # nettoolsis needed for infratest 'socket' using netstat.
  # default one on Alpine (busybox) is a limited versions.
  apk add --no-cache --no-progress --quiet net-tools
}

_install_testinfra() {
  if ! [ -x "$(command -v pytest)" ]; then
    # https://github.com/pytest-dev/pytest-testinfra
    pip3 install pytest-testinfra --quiet
  fi
}

_main() {
  echo -e "[notice] Install packages for tests..."
  _install_packages
  _install_testinfra
  echo -e "[notice] Done!"
}

# Call `_main` after everything has been defined.
_main
