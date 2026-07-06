#!/bin/bash
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

export IMPALA_HOME=/opt/impala
export LD_LIBRARY_PATH=/opt/impala/lib

DISTRIBUTION=Unknown
if [[ -f /etc/redhat-release ]]; then
  DISTRIBUTION=Redhat
else
  source /etc/lsb-release
  if [[ $DISTRIB_ID == Ubuntu ]]; then
    DISTRIBUTION=Ubuntu
  fi
fi

if [[ $DISTRIBUTION == Unknown ]]; then
  echo "ERROR: Did not detect supported distribution."
  exit 1
fi

JAVA_HOME=Unknown
if [[ $DISTRIBUTION == Ubuntu ]]; then
  if compgen -G "/usr/lib/jvm/java-17-openjdk*" ; then
    JAVA_HOME=$(compgen -G "/usr/lib/jvm/java-17-openjdk*")
  elif compgen -G "/usr/lib/jvm/java-11-openjdk*" ; then
    JAVA_HOME=$(compgen -G "/usr/lib/jvm/java-11-openjdk*")
  elif compgen -G "/usr/lib/jvm/java-8-openjdk*" ; then
    JAVA_HOME=$(compgen -G "/usr/lib/jvm/java-8-openjdk*")
  fi
elif [[ $DISTRIBUTION == Redhat ]]; then
  if [[ -d /usr/lib/jvm/jre-17 ]]; then
    JAVA_HOME=/usr/lib/jvm/jre-17
  elif [[ -d /usr/lib/jvm/jre-11 ]]; then
    JAVA_HOME=/usr/lib/jvm/jre-11
  elif [[ -d /usr/lib/jvm/jre-1.8.0 ]]; then
    JAVA_HOME=/usr/lib/jvm/jre-1.8.0
  fi
fi

if [[ $JAVA_HOME == Unknown ]]; then
  echo "ERROR: Did not find Java in any expected location."
  exit 1
fi

export JAVA_HOME
LIB_JSIG_DIR=$(find -L "${JAVA_HOME}" -name libjsig.so | head -1 | xargs dirname)
LIB_JVM_DIR=$(find -L "${JAVA_HOME}" -name libjvm.so | head -1 | xargs dirname)
LD_LIBRARY_PATH+=:${LIB_JSIG_DIR}:${LIB_JVM_DIR}
LD_LIBRARY_PATH+=:/opt/impala/lib/plugins

export CLASSPATH=/opt/impala/conf
for jar in /opt/impala/lib/*.jar; do
  CLASSPATH+=:${jar}
done

if [[ -d /opt/impala/aux-jars ]]; then
  for jar in /opt/impala/aux-jars/*.jar; do
    CLASSPATH+=:${jar}
  done
fi

export JAVA_TOOL_OPTIONS="-Xmx2g ${JAVA_TOOL_OPTIONS:-}"

if ! whoami ; then
  export USER=${HADOOP_USER_NAME:-dummyuser}
  echo "${USER}:x:$(id -u):$(id -g):,,,:/opt/impala:/bin/bash" >> /etc/passwd
fi

LOG_DIR=$IMPALA_HOME/logs
if [[ ! -w "$LOG_DIR" ]]; then
  echo "$LOG_DIR is not writable"
  exit 1
fi

ulimit -c 0

if ! command -v pgrep ; then
  echo "ERROR: 'pgrep' is not present."
  exit 1
fi

if locale -a | grep en_US.utf8 ; then
  :
else
  echo "ERROR: en_US.utf8 locale is not present."
  exit 1
fi

if locale -a | grep -e "^C.UTF-8" -e "^C.utf8" ; then
  export LC_ALL=C.UTF-8
else
  export LC_ALL=en_US.utf8
fi

exec "$@"
