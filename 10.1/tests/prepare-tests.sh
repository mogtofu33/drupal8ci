#!/usr/bin/env bash
set -eu

_main() {
  echo -e "[notice] Install packages for tests..."
  apt update && apt install -y python3 python3-testinfra
  echo -e "[notice] Done!"
}

# Call `_main` after everything has been defined.
_main
