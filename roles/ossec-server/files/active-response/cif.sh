#!/bin/bash
# Generates intel feed entries for CIF
# Author: Jon Schipp
ACTION=$1
USER=$2
IP=$3
ALERTID=$4
RULEID=$5
DESCRIPTION=$(grep -h -A 10 '<rule id="'"$RULEID"'"' /var/ossec/rules/*.xml | awk -F '[<>]' '/description/ { printf("%s", $3) } END { printf("\n") }')
FILE=/var/ossec/logs/intel.log

# Logging the call
printf "$(date) $0 $1 $2 $3 $4 $5 $6 $7 $8\n" >> ${PWD}/../logs/active-responses.log

[[ $IP ]] || exit

# RFC 1918
[[ $IP =~ ^10\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]] && exit
[[ $IP =~ ^172\.16\.[0-9]{1,3}\.[0-9]{1,3}$ ]] && exit
[[ $IP =~ ^192\.168\.[0-9]{1,3}\.[0-9]{1,3}$ ]] && exit

# In case it's really a DNS name
#[[ $IP =~ company.com ]] && exit

printf "${IP},OSSEC,${RULEID},${DESCRIPTION}\n" >> $FILE
