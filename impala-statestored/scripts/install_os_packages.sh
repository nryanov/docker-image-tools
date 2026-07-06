#!/bin/bash
set -euo pipefail

INSTALL_DEBUG_TOOLS=none
JAVA_VERSION=8

while [ -n "${1:-}" ]; do
  case "$1" in
    --install-debug-tools)
      INSTALL_DEBUG_TOOLS="${2-}"
      shift
      ;;
    --java)
      JAVA_VERSION="${2-}"
      shift
      ;;
    *)
      echo "Unknown argument: $1" >&2
      exit 1
      ;;
  esac
  shift
done

export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y \
  hostname \
  krb5-user \
  language-pack-en \
  libsasl2-2 \
  libsasl2-modules \
  libsasl2-modules-gssapi-mit \
  openjdk-${JAVA_VERSION}-jre-headless \
  procps \
  tzdata

if [[ $INSTALL_DEBUG_TOOLS == full ]]; then
  apt-get install -y \
    curl \
    dnsutils \
    iproute2 \
    iputils-ping \
    less \
    netcat-openbsd \
    sudo \
    vim
fi

if ! locale -a | grep en_US.utf8 ; then
  echo "ERROR: en_US.utf8 locale is not present."
  exit 1
fi

chmod a=rwx,o+t /var/tmp /tmp
apt-get clean
rm -rf /var/lib/apt/lists/*
