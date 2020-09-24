#!/usr/bin/env bash

# Environmental variables
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
start_time=`date`
printf "Starting at $start_time\n"

tests=('0010-basic_connectivity')

for current_test in "${tests[@]}"
do 
    robot --noncritical non_critical --outputdir ./reports -o $current_test.xml -l $current_test.log.html -r $current_test.report.html ./$current_test.robot
done

########################################
# Executing Rebot Report Summarization
########################################

printf "Running Rebot Report Summarization"
# Compile all output into a single report
rebot --name "F5 Robot Framework Test Report" -l ./COMBINED-LOG.html -r ./COMBINED-REPORT.html ./*.xml
# Remove raw output files
fm -f ./*.xml

############################################
# Print the start and finish time and exit
############################################

printf "Started: $start_time\n"
printf "Completed: `date`\n"
printf "### Script execution complete.\n"