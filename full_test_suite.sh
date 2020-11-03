#!/usr/bin/env bash

# Environmental variables
export PYTHONWARNINGS='ignore:Unverified HTTPS request'

# Set the Robot Host IP as a variable
export ROBOT_HOST_IP=`hostname -I`
export ROBOT_HOST_IP="$(echo -e "${ROBOT_HOST_IP}" | tr -d '[:space:]')"

# BIG-IP Devices
export PRIMARY_HOSTNAME='host-10-144-20-32.openstacklocal'
export PRIMARY_MGMT_IP='10.144.20.32'
export SECONDARY_HOSTNAME='host-10-144-20-25.openstacklocal'
export SECONDARY_MGMT_IP='10.144.20.25'
export MGMT_NETWORK_GATEWAY='10.144.31.254'

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

# cm device-group
export PRIMARY_HA_IP_ADDRESS='10.10.40.11'
export SECONDARY_HA_IP_ADDRESS='10.10.40.31'
export DSC_GROUP_NAME='robot_framework_failover_group'

# ltm virtual - tcp round robin
export TCP_ROUND_ROBIN_VIP_NAME='tcp_round_robin_vs'
export TCP_ROUND_ROBIN_VIP_ADDRESS='198.19.160.5'
export TCP_ROUND_ROBIN_VIP_MASK='255.255.255.255'
export TCP_ROUND_ROBIN_VIP_PORT='80'
export TCP_ROUND_ROBIN_VIP_PROTOCOL='tcp'
export TCP_ROUND_ROBIN_VIP_SNAT_TYPE='automap'
export TCP_ROUND_ROBIN_POOL_NAME='tcp_round_robin_pool'
export TCP_ROUND_ROBIN_POOL_MEMBERS='[{"address":"198.19.208.21","port":"80"},{"address":"198.19.208.22","port":"80"},{"address":"198.19.208.23","port":"80"},{"address":"198.19.208.24","port":"80"},{"address":"198.19.208.25","port":"80"},{"address":"198.19.208.26","port":"80"},{"address":"198.19.208.27","port":"80"},{"address":"198.19.208.28","port":"80"},{"address":"198.19.208.29","port":"80"},{"address":"198.19.208.30","port":"80"}]'
export TCP_ROUND_ROBIN_POOL_MONITOR='/Common/gateway_icmp'

# ltm virtual - udp round robin
export UDP_ROUND_ROBIN_VIP_NAME='udp_dns_round_robin_vs'
export UDP_ROUND_ROBIN_VIP_PARTITION='Common'
export UDP_ROUND_ROBIN_VIP_ADDRESS='198.19.160.2'
export UDP_ROUND_ROBIN_VIP_MASK='255.255.255.255'
export UDP_ROUND_ROBIN_VIP_PORT='53'
export UDP_ROUND_ROBIN_VIP_PROTOCOL='udp'
export UDP_ROUND_ROBIN_VIP_SNAT_TYPE='automap'
export UDP_ROUND_ROBIN_POOL_NAME='udp_dns_round_robin_pool'
export UDP_ROUND_ROBIN_POOL_MEMBERS='[{"address":"198.19.208.21","port":"53"},{"address":"198.19.208.22","port":"53"},{"address":"198.19.208.23","port":"53"},{"address":"198.19.208.24","port":"53"},{"address":"198.19.208.25","port":"53"},{"address":"198.19.208.26","port":"53"},{"address":"198.19.208.27","port":"53"},{"address":"198.19.208.28","port":"53"},{"address":"198.19.208.29","port":"53"},{"address":"198.19.208.30","port":"53"}]'
export UDP_ROUND_ROBIN_POOL_MONITOR='/Common/gateway_icmp'

# sys ntp
export NTP_SERVER_LIST='["0.pool.ntp.org","1.pool.ntp.org"]'

# sys provision
export MODULE_PROVISIONING='[{"module":"ltm","provisioningLevel":"nominal"},{"module":"afm","provisioningLevel":"nominal"}]'

# sys snmp
export SNMPv2_TRAP_HOST='{"v2Traps":[{"name":"ROBOT_FRAMEWORK_HOST","host":"$ROBOT_HOST_IP","community":"robot"}]}'
export SNMPV2_TRAP_FACILITY='0'
export SNMPV2_TRAP_LEVEL='emerg'
export SNMPV2_TRAP_MESSAGE='ROBOT FRAMEWORK TEST MESSAGE SNMPv2'
export SNMPV2_POLL_COMMUNITY='robot'
export SNMPV2_PORT='161'
export SNMPV2_TIMEOUT='5'
export SNMPV2_RETRIES='12'
export SNMPV3_TRAP_HOST='$ROBOT_HOST_IP'
export SNMPV3_TRAP_PORT='2162'
export SNMPV3_TRAP_FACILITY='0'
export SNMPV3_TRAP_LEVEL='emerg'
export SNMPV3_TRAP_MESSAGE='ROBOT FRAMEWORK TEST MESSAGE SNMPv3'
export SNMPV3_USER='robot_framework'
export SNMPV3_COMMUNITY='robot'
export SNMPV3_AUTH_PASS='robot_framework'
export SNMPV3_AUTH_PROTO='sha'
export SNMPV3_PRIV_PASS='robot_framework'
export SNMPV3_PRIV_PROTO='aes'
export SNMPV3_PRIV_PROTO_SNMPLIB='AES128'
export SNMPV3_SECURITY_LEVEL='auth-privacy'
export SNMPV3_SECURITY_NAME='robot-framework'
export SNMPV3_PORT='161'
export SNMPV3_TIMEOUT='5'
export SNMPV3_RETRIES='12'

# net interface
export PRIMARY_INTERFACE_DETAILS='[{"name":"1.1","description":"Configured by Robot Framework","lldpAdmin":"txrx"},{"name":"1.2","description":"Configured by Robot Framework","lldpAdmin":"txrx"},{"name":"1.3","description":"Configured by Robot Framework","lldpAdmin":"txrx"}]'
export SECONDARY_INTERFACE_DETAILS='[{"name":"1.1","description":"Configured by Robot Framework","lldpAdmin":"txrx"},{"name":"1.2","description":"Configured by Robot Framework","lldpAdmin":"txrx"},{"name":"1.3","description":"Configured by Robot Framework","lldpAdmin":"txrx"}]'

# net self
export PRIMARY_LOCAL_SELF_IP_LIST='[{"name":"public-ipv4-self-local","address":"10.20.0.248/24","partition":"Common","vlan":"public","allow-service":"all"},{"name":"private-ipv4-self-local","address":"10.10.30.247/24","partition":"Common","vlan":"private","allow-service":"all"}]'
#export PRIMARY_FLOATING_SELF_IP_LIST='[{"name":"public-ipv4-self-floating","address":"10.1.10.200/24","partition":"Common","vlan":"public","allow-service":"all"},{"name":"private-ipv4-self-floating","address":"10.1.20.200/24","partition":"Common","vlan":"private","allow-service":"all"}]'
export SECONDARY_LOCAL_SELF_IP_LIST='[{"name":"public-ipv4-self-local","address":"10.20.0.246/24","partition":"Common","vlan":"public","allow-service":"all"},{"name":"private-ipv4-self-local","address":"10.10.30.248/24","partition":"Common","vlan":"private","allow-service":"all"}]'
#export SECONDARY_FLOATING_SELF_IP_LIST='[{"name":"public-ipv4-self-floating","address":"10.1.10.200/24","partition":"Common","vlan":"public","allow-service":"all"},{"name":"private-ipv4-self-floating","address":"10.1.20.200/24","partition":"Common","vlan":"private","allow-service":"all"}]'

# net route
export PRIMARY_STATIC_DEFAULT_ROUTE='{"gw":"10.20.0.1","description":"Configured by ROBOT FRAMEWORK","partition":"Common"}'
export SECONDARY_STATIC_DEFAULT_ROUTE='{"gw":"10.20.0.1","description":"Configured by ROBOT FRAMEWORK","partition":"Common"}'

# net vlan
export OUTSIDE_VLAN_NAME='private'
export OUTSIDE_VLAN_TAG='4093'
export OUTSIDE_VLAN_TAGGED='False'
export OUTSIDE_INTERFACE_NAME='1.1'
export INSIDE_VLAN_NAME='public'
export INSIDE_VLAN_TAG='4092'
export INSIDE_VLAN_TAGGED='False'
export INSIDE_INTERFACE_NAME='1.2'
export HA_VLAN_NAME='ha_mirroring'
export HA_VLAN_TAG='4091'
export HA_VLAN_TAGGED='False'
export HA_INTERFACE_NAME='1.3'

# Delete existing reports
rm -f ./reports/*.html
rm -f ./reports/*.xml

printf "####################################\n"
printf "## Executing Robot Framework Tests  \n"
printf "####################################\n"
start_time=`date`

# Execute tests in order via this array
tests=('0010-basic_connectivity' '0011-disable_gui_wizard' '0019-sys_provision' '0020-sys_global_settings' '0025-sys_snmp' '0030-ntp' '0040-net_interface' '0050-net_vlan' '0060-net_self' '0065-net_route' '0070-cm_clustering' '0080-ltm_tcp_round_robin' '0090-ltm_udp_round_robin')

# Cycle through list of tests and create a per-test report in /reports
for current_test in "${tests[@]}"
do 
    robot --noncritical non_critical --outputdir ./reports -o $current_test.xml -l $current_test.log.html -r $current_test.report.html ./$current_test.robot
done

printf "#########################################################\n"
printf "## Robot Framework Tests Complete; starting final tasks  \n"
printf "#########################################################\n"

# Final SCF download parameters
export FILE_TIMESTAMP=`date +%Y%m%d-%H%M%S`
export PRIMARY_SCF_FILENAME=robot_framework_posttest_config_save-$PRIMARY_MGMT_IP-$FILE_TIMESTAMP.scf
export SECONDARY_SCF_FILENAME=robot_framework_posttest_config_save-$SECONDARY_MGMT_IP-$FILE_TIMESTAMP.scf
current_test=ff0a-configuration_downloads; robot --noncritical non_critical --outputdir ./reports -o $current_test.xml -l $current_test.log.html -r $current_test.report.html ./$current_test.robot

# Executing Rebot Report Summarization, which combines all single reports into a master report
printf "Running Rebot Report Summarization"
rebot --name "F5 Robot Framework Test Report" -l ./reports/COMBINED-LOG.html -r ./reports/COMBINED-REPORT.html ./reports/*.xml

printf "##############################\n"
printf "## Script execution complete  \n"
printf "##############################\n"
printf "Started: $start_time\n"
printf "Completed: `date`\n"
