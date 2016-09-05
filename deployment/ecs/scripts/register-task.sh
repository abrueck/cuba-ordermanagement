#!/usr/bin/env bash
set +x;

source deployment/ecs/scripts/bash-print-functions.sh

# script parameters
TEMPLATE_FILE=$1
CUBA_VERSION=$2
TASK_FAMILY=$3


if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]
  then
    echo "usage: ./register-task.sh TEMPLATE_FILE CUBA_VERSION TASK_FAMILY"
    exit 1
fi

sed -e "s;%CUBA_VERSION%;${CUBA_VERSION};g" ${TEMPLATE_FILE} > CUBA-${CUBA_VERSION}.json



if aws ecs register-task-definition --family ${TASK_FAMILY} --cli-input-json file://CUBA-${CUBA_VERSION}.json >> build.log
then
    printInfo "Task definition registered"
else
    printError "Count not register task definition"
fi;