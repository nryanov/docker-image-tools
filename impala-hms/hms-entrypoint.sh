#!/bin/bash
set -euo pipefail

DATA_DIR="/var/lib/hive"
LOG_DIR="$DATA_DIR/logs"
HIVE_HOME="/opt/hive"
export JAVA_HOME=$(readlink -f "$(which java)" | sed "s:/bin/java::")
export HADOOP_HOME=/opt/hadoop

function print_help {
  echo "Supported commands:"
  echo "  hms  - start the hive metastore service"
  echo "  help - print useful information and exit"
}

function run_hive_metastore() {
  if [ ! -d "${DATA_DIR}/metastore/metastore_db" ]; then
    "$HIVE_HOME/bin/schematool" -dbType derby -initSchema
  fi
  exec "$HIVE_HOME/bin/hive" --service metastore
}

if [[ $# -eq 0 ]]; then
  print_help
  exit 1
fi

mkdir -p "$DATA_DIR" "$LOG_DIR"

if [[ "$1" == "hms" ]]; then
  run_hive_metastore
elif [[ "$1" == "help" ]]; then
  print_help
else
  exec "$@"
fi
