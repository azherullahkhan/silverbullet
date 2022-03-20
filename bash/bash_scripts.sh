
------------------------------------------------------------------------------------------
                                       Bash Scripts
------------------------------------------------------------------------------------------




#!/bin/bash
###########################################################
# Fetches dynamic values based on realm, region, cluster,
# and application
###########################################################

# Inputs
REALM=$1
REGION=$2
CLUSTER=$3
APP=$4

# Set variables
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
REALM_FILE="${SCRIPT_DIR}/../vars/helmfile/realms/${REALM}.yaml"

# Validation
if [[ ! -s ${REALM_FILE} ]]; then
  echo "ERROR: realm file for ${REALM} not found"
  exit 1
fi

# Output
yq e '{"company": .}' ${REALM_FILE}




#!/usr/bin/env bash
FAILURE=false

#https://github.com/hadolint/hadolint
# Test return code for failure
function error_check() {
  if [ $1 -gt 0 ]; then
    FAILURE=true
    echo "TEST: $2 , STATUS:  FAIL"
  else
    echo "TEST: $2 , STATUS:  PASS"
  fi
}

# Running hadolint on all dockerfiles in infra/docker_builds dir
echo "Checking hadolint results..."

cmd=$( find . -type f -iname 'Dockerfile' )
for file in $cmd; do
    echo "hadolinting $file"
    /usr/local/bin/hadolint --config .gitlab-ci/files/hadolint.config $file
    error_check $? "Hadolinting Dockerfile ${file}"
done


if [ "$FAILURE" == true ]; then
  echo "FAIL:  DOCKER LINTING TESTS FAILED."
  exit 1
else
  echo "SUCCESS:  DOCKER LINTING TESTS COMPLETED SUCCESSFULLY."
  exit 0
fi




[kafka@shared-kafka-dr-kafka-0 kafka]$ for topic_name in $(cat /tmp/test); do echo "Topic name: $topic_name"; PartitionCount=$(/opt/kafka/bin/kafka-topics.sh --zookeeper localhost --describe --topic us-phoenix-1..event | grep PartitionCount | awk '{print $4}'); ReplicationFactor=$(/opt/kafka/bin/kafka-topics.sh --zookeeper localhost --describe --topic us-phoenix-1.event | grep PartitionCount | awk '{print $6}'); PARTITION_COUNT=$(($PartitionCount * $ReplicationFactor)); echo " TOPIC: $topic_name PARTITION_COUNT: $PARTITION_COUNT" ; done
Topic name: us-phoenix-1.event
 TOPIC: us-phoenix-1.event PARTITION_COUNT: 90



[kafka@shared-kafka-dr-kafka-0 kafka]$ PARTITION_COUNT=0; TOTAL_COUNT=0; for topic_name in $(/opt/kafka/bin/kafka-topics.sh --zookeeper localhost --list); do echo "Topic name: $topic_name"; PartitionCount=$(/opt/kafka/bin/kafka-topics.sh --zookeeper localhost --describe --topic $topic_name | grep PartitionCount | awk '{print $4}'); ReplicationFactor=$(/opt/kafka/bin/kafka-topics.sh --zookeeper localhost --describe --topic $topic_name | grep PartitionCount | awk '{print $6}'); PARTITION_COUNT=$(($PartitionCount * $ReplicationFactor)); echo " TOPIC: $topic_name PARTITION_COUNT: $PARTITION_COUNT" ; TOTAL_COUNT=$(($PARTITION_COUNT + $TOTAL_COUNT)) ; echo "TOTAL_COUNT = $TOTAL_COUNT" ;done




