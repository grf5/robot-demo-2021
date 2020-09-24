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
export MGMT_NETWORK_GATEWAY='10.1.1.1'

# Device Credentials
export PRIMARY_SSH_USERNAME='admin'
export PRIMARY_SSH_PASSWORD='f5r0b0t!'
export PRIMARY_HTTP_USERNAME='admin'
export PRIMARY_HTTP_PASSWORD='f5r0b0t!'
export SECONDARY_SSH_USERNAME='admin'
export SECONDARY_SSH_PASSWORD='f5r0b0t!'
export SECONDARY_HTTP_USERNAME='admin'
export SECONDARY_HTTP_PASSWORD='f5r0b0t!'

# Base provisioning UCS (reset to this before test)
export PRIMARY_BASE_UCS_FILENAME='/var/local/ucs/firstboot_licensed.ucs'
export SECONDARY_BASE_UCS_FILENAME='/var/local/ucs/firstboot_licensed.ucs'

# sys ntp
export NTP_SERVER_LIST='["52.0.56.137","45.63.54.13","204.11.201.12","172.98.193.44"]'

# net interface
export PRIMARY_INTERFACE_DETAILS='[{"name":"1.1","description":"Configured by Robot Framework","lldpAdmin":"txrx"},{"name":"1.2","description":"Configured by Robot Framework","lldpAdmin":"txrx"}]'
export SECONDARY_INTERFACE_DETAILS='[{"name":"1.1","description":"Configured by Robot Framework","lldpAdmin":"txrx"},{"name":"1.2","description":"Configured by Robot Framework","lldpAdmin":"txrx"}]'

# net vlan
export OUTSIDE_VLAN_NAME='uplink'
export OUTSIDE_VLAN_TAG='none'
export OUTSIDE_VLAN_TAGGED='False'
export OUTSIDE_INTERFACE_NAME='1.1'
export INSIDE_VLAN_NAME='downlink'
export INSIDE_VLAN_TAG='none'
export INSIDE_VLAN_TAGGED='False'
export INSIDE_INTERFACE_NAME='1.2'

# Delete existing reports
rm -f ./reports/*.html
rm -f ./reports/*.xml

# When developing, load base configs; when running full test, load the default
# ONLY ENABLE ONE OF THE FOLLOWING TWO LINES AT ANY TIME!
test=DCNETARCH-SLB-LOAD-SYS-UCS-BASEPROVISIONING; $robot_fullpath --noncritical non_critical  --outputdir ./reports -o $test.xml -l $test.log.html -r $test.report.html ./bin/$test.robot
# test=DCNETARCH-SLB-LOAD-SYS-CONFIG-DEFAULT; $robot_fullpath --noncritical non_critical  --outputdir ./reports -o $test.xml -l $test.log.html -r $test.report.html ./bin/$test.robot

printf "##############################\n"
printf "## Starting script execution  \n"
printf "##############################\n"
start_time=`date`

# Execute tests in order via this array
tests=('000a-reset_environment' '0010-basic_connectivity' '0020-sys_global_settings' '0030-ntp' '0040-net_interface')

# Cycle through list of tests and create a per-test report in /reports
for current_test in "${tests[@]}"
do 
    robot --noncritical non_critical --outputdir ./reports -o $current_test.xml -l $current_test.log.html -r $current_test.report.html ./$current_test.robot
done

# Executing Rebot Report Summarization, which combines all single reports into a master report
printf "Running Rebot Report Summarization"
rebot --name "F5 Robot Framework Test Report" -l ./reports/COMBINED-LOG.html -r ./reports/COMBINED-REPORT.html ./reports/*.xml

printf "##############################\n"
printf "## Script execution complete  \n"
printf "##############################\n"
printf "Started: $start_time\n"
printf "Completed: `date`\n"
