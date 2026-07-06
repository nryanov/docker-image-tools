#!/bin/bash
set -euo pipefail

# Adapt the official Impala .deb layout to the directory structure expected by
# the Docker daemon entrypoint scripts from the Impala source tree.

mkdir -p /opt/impala/bin /opt/impala/logs /opt/impala/conf /opt/impala/rangercache /opt/impala/lib/plugins

ln -sf ../sbin/impalad /opt/impala/bin/impalad
(
  cd /opt/impala/bin
  ln -sf impalad statestored
  ln -sf impalad catalogd
  ln -sf impalad admissiond
)

for jar in /opt/impala/lib/jars/*.jar; do
  ln -sf "jars/$(basename "${jar}")" "/opt/impala/lib/$(basename "${jar}")"
done

for lib in /opt/impala/lib/native/*; do
  [[ -e "${lib}" ]] || continue
  ln -sf "native/$(basename "${lib}")" "/opt/impala/lib/$(basename "${lib}")"
done
