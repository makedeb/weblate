#!/usr/bin/bash
#
# This file is maintained as part of the Weblate fork. It is not part of the upstream.
set -e

cd "$(dirname "${0}")"

case "${1}" in
  start) docker-compose up -d ;;
  stop) docker-compose down --remove-orphans -v ;;
  update) docker-compose pull ;;
esac

# vim: expandtab ts=2 sw=2
