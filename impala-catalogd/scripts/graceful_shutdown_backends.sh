#!/bin/bash
set -euxo pipefail

export IMPALA_HOME=${IMPALA_HOME:-"/opt/impala"}
LOG_FILE="$IMPALA_HOME/logs/shutdown.log"

function LOG() {
  echo "$*" | tee -a "$LOG_FILE" || true
}

GRACE_TIMEOUT=$((120 + 10))
if [[ $# -ge 1 ]]; then
  GRACE_TIMEOUT=$1
fi

LOG "Initiating graceful shutdown."
for pid in $(pgrep impalad); do
  LOG "Sending signal to daemon with pid $pid"
  kill -SIGRTMIN "$pid"
done

LOG "Waiting for daemons to exit, up to $GRACE_TIMEOUT s."
for ((i=0; i<GRACE_TIMEOUT; ++i)); do
  pids=$(pgrep impalad || true)
  if [[ -z "$pids" ]]; then
    LOG "All daemons have exited after $i s."
    break
  fi
  sleep 1
done

LOG "Graceful shutdown process complete."
