#!/bin/bash

set -e
umask 0027

: ${JAVA_OPTS:=}

export JAVA_OPTS="${JAVA_OPTS}"

entrypoint.py

cat ${ZK_HOME}/conf/zoo.cfg

bin/zkServer.sh start-foreground