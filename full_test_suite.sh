#!/usr/bin/env bash

# Environmental variables
export PYTHONWARNINGS='ignore:Unverified HTTPS request'

# Test case variables
export ROBOT_HOST_IP=`hostname -I`

# BIG-IP Devices
export PRIMARY_HOSTNAME='ip-10-1-1-5.us-west-2.compute.internal'
export PRIMARY_MGMT_IP='10.1.1.5'
export SECONDARY_HOSTNAME='ip-10-1-1-6.us-west-2.compute.internal'
export SECONDARY_MGMT_IP='10.1.1.6'

# Device Credentials
export PRIMARY_SSH_USERNAME='admin'
export PRIMARY_SSH_PASSWORD='f5r0b0t!'
export PRIMARY_HTTP_USERNAME='admin'
export PRIMARY_HTTP_PASSWORD='f5r0b0t!'
export SECONDARY_SSH_USERNAME='admin'
export SECONDARY_SSH_PASSWORD='f5r0b0t!'
export SECONDARY_HTTP_USERNAME='admin'
export SECONDARY_HTTP_PASSWORD='f5r0b0t!'


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
rebot --name "F5 Robot Framework Test Report" -l ./reports/COMBINED-LOG.html -r ./reports/COMBINED-REPORT.html ./reports/*.xml
# Remove raw output files
rm -f ./*.xml

############################################
# Print the start and finish time and exit
############################################

printf "Started: $start_time\n"
printf "Completed: `date`\n"
printf "### Script execution complete.\n"