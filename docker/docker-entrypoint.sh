#!/usr/bin/env bash

# If unspecified, the hostname of the container is used
MASTER_ADDRESS=${MASTER_ADDRESS:-$(hostname -f)}
export SPARK_MASTER_HOST=${MASTER_ADDRESS}

# SPARK_MASTER_PORT is set by k8s in the tcp://ip:port format
MASTER_PORT=${SPARK_MASTER_SERVICE_PORT:-7077}
export SPARK_MASTER_PORT=${MASTER_PORT}

if [ "$1" = "help" ]; then
    echo "Usage: $(basename "$0") (master|worker|help)"
    exit 0
fi

if [ "$CORE_SITE_URL" != "" ]; then
    temp="${CORE_SITE_URL%\"}"
    temp="${temp#\"}"
    wget "$temp" -k -O core-site.xml
    mv core-site.xml "$HADOOP_CONF_DIR/";
fi

if [ "$1" = "master" ]; then
    echo "Starting master"
    # must run from bash, this script launch process as daemon and returns immediately
    /usr/bin/env bash "$SPARK_HOME/sbin/start-master.sh"
    # block the script to not return and redirect log
    exec tail -f "$SPARK_HOME"/logs/spark--org.apache.spark.deploy.master.Master-*.out
elif [ "$1" = "worker" ]; then
    echo "Starting woker"
    /usr/bin/env bash "$SPARK_HOME/sbin/start-slave.sh" "$MASTER_URL"
    exec tail -F "$SPARK_HOME"/logs/spark--org.apache.spark.deploy.worker.Worker-*.out
fi

# do nothing
