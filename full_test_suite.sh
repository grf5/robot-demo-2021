#!/usr/bin/env bash

# Environmental variables
robot_fullpath=/home/centos/f5_robot_testing/f5_robot_venv/bin/robot
export PYTHONWARNINGS='ignore:Unverified HTTPS request'

# Test case variables
export ROBOT_HOST_IP=`hostname -I`

# BIG-IP Devices
export PRIMARY_HOSTNAME=''
export PRIMARY_MGMT_IP=''
export SECONDARY_HOSTNAME=''
export SECONDARY_MGMT_IP=''

# Device Credentials
export PRIMARY_SSH_USERNAME=''
export PRIMARY_SSH_PASSWORD=''
export PRIMARY_HTTP_USERNAME=''
export PRIMARY_HTTP_PASSWORD=''

printf "##############################\n"
printf "## Starting script execution  \n"
printf "##############################\n"
date
start_time=`date`

tests=('0010-basic-connectivity')

for current_test in tests
do 
    $robot_fullpath --noncritical non_critical --outputdir ./reports -o $test.xml -l $test.log.html -r $test.report.html ./bin/$test.robot
done

########################################
# Executing Rebot Report Summarization
########################################

printf "Running Rebot Report Summarization"
rebot --name "F5 Robot Framework Test Report" -l ./COMBINED-LOG.html -r ./COMBINED-REPORT.html ./*.xml
fm -f ./*.xml

printf "Started: $start_time\n"
printf "Completed: `date`\n"
printf "### Script execution complete.\n"