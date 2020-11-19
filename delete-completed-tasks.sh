#!/usr/bin/env bash

usage() {
cat << EOF
Usage: $(basename $0) -t <token> [-b <backup_file> | -v]

Options:
  -t <token>         Your Todoist API token
  -b <backup_file>   Location of a backup file to append deleted tasks to (optional)
  -v                 Show verbose output (optional)
EOF
    exit
}

join_by() {
    local IFS="$1";
    shift;
    echo "$*";
}

TOKEN=
BACKUP_FILE=
VERBOSE=

while [[ "${1}" != "" ]]; do
    case "${1}" in
        -t ) TOKEN="${2}";;
        -b ) BACKUP_FILE="${2}";;
        -v ) VERBOSE=true;;
    esac
    shift
done

if [ -z "${TOKEN}" ]; then
    usage
fi

if ! command -v uuid 2>&1 > /dev/null; then
    echo "Error: uuid command required" 
fi

IDS=X
OFFSET=0
BATCH_SIZE=100

until [ -z "${IDS}" ]; do
    TASKS=$(curl -s https://api.todoist.com/sync/v8/completed/get_all \
        -d token=${TOKEN} \
        -d sync_token=* \
        -d offset=${OFFSET} \
        -d limit=${BATCH_SIZE} | jq ".items | .[] ")


    if [ -n "${BACKUP_FILE}" ]; then
        echo ${TASKS} | jq ".content" >> ${BACKUP_FILE}
    fi

    IDS=$(echo ${TASKS} | jq ".task_id")

    COMMANDS=()

    for ID in ${IDS}; do
        COMMANDS+=('{"type": "item_delete", "uuid": "'$(uuid)'", "args": {"id": '${ID}'}}')
    done

    COMMANDS=$(join_by , "${COMMANDS[@]}")

    if [ "${VERBOSE}" == "true" ]; then
        echo "Count: ${OFFSET}"
    	echo "Deleting: $(join_by ' ' ${IDS})"
    fi

    curl -s https://api.todoist.com/sync/v8/sync \
        -d token=${TOKEN}\
        -d commands="[${COMMANDS}]" > /dev/null

    OFFSET=$((${OFFSET} + ${BATCH_SIZE}))

    sleep 2
done

