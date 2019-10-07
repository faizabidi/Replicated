#!/bin/bash

set -x

# Get a .tar.gz file from the user to analyze
if [ $# -ne 1 ]; then
    echo "Please provide the path of the tarred bundle to be analyzed."
    echo "For example: ./extract_data.bash ~/git/core-challenge-troubleshoot-analyzers/supportbundle.tar.gz"
    exit 1
fi

INPUT_FILE=$1

# We'll get a .tar.gz file. Let's extract it in the /tmp folder, get the data 
# that we are looking for, and delete the extracted folder. 
# We'll be storing the extracted data in a file called info.txt.

rm info.txt
mkdir /tmp/replicated 
tar -xf $1 -C /tmp/replicated

PROC_FILE_PATH="/tmp/replicated/default/proc"
DF_FILE_PATH="/tmp/replicated/default/commands/df"
DOCKER_FILE_PATH="/tmp/replicated/default/docker"

OS_DISTRO=$(cat $DOCKER_FILE_PATH/docker_info.json | grep OperatingSystem | awk '{print $2}' | tr -d \" | cut -c 1-)
OS_DISTRO_VERSION=$(cat $DOCKER_FILE_PATH/docker_info.json | grep OperatingSystem | awk '{print $3}')
NUM_CORES=$(cat $PROC_FILE_PATH/cpuinfo | grep "cpu cores" | awk {'print $4}' | head -1)
LOGICAL_CPUS=$(grep -c "processor" $PROC_FILE_PATH/cpuinfo)
AVG_LOAD_15MIN=$(awk '{print $NF}' $PROC_FILE_PATH/uptime)
# The below will give disk usage in KB
DISK_USAGE_ROOT=$(cat $DF_FILE_PATH/stdout | grep -w "/" | awk '{print $3}')
# Convert KB to Bytes
DISK_USAGE_ROOT=$(($DISK_USAGE_ROOT * 1024))
DOCKER_VERSION=$(cat $DOCKER_FILE_PATH/docker_version.json | grep "\"Version\"" | awk '{print $2}' | tr -d \")
DOCKER_STORAGE_DRIVER=$(cat $DOCKER_FILE_PATH/docker_info.json | grep "\"Driver\"" | awk '{print $2}' | tr -d \" | rev | cut -c 2- | rev)

echo "OS distro:" $OS_DISTRO >> info.txt
echo "OS distro version:" $OS_DISTRO_VERSION >> info.txt
echo "Number of physical cores:" $NUM_CORES >> info.txt
echo "Number of logical CPUs:" $LOGICAL_CPUS >> info.txt
echo "Average load in the last 15 minutes:" $AVG_LOAD_15MIN >> info.txt
echo "Disk usage in bytes on root:" $DISK_USAGE_ROOT >> info.txt
echo "Docker version:" $DOCKER_VERSION >> info.txt
echo "Docker storage driver:" $DOCKER_STORAGE_DRIVER >> info.txt

# Delete the /tmp/replicated folder
rm -rf /tmp/replicated

echo "Please check info.txt for the extracted data."

