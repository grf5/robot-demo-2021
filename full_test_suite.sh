#!/usr/bin/env bash

# Environmental variables
export PYTHONWARNINGS='ignore:Unverified HTTPS request'

# Set the Robot Host IP as a variable
export ROBOT_HOST_IP='10.1.1.7'

# BIG-IP Devices
export PRIMARY_HOSTNAME='bigip-a.lab.local'
export PRIMARY_MGMT_IP='10.1.1.4'
export SECONDARY_HOSTNAME='bigip-b.lab.local'
export SECONDARY_MGMT_IP='10.1.1.5'
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
export PRIMARY_BASE_UCS_FILENAME='/var/local/ucs/provisioned.ucs'
export SECONDARY_BASE_UCS_FILENAME='/var/local/ucs/provisioned.ucs'

# cm device-group
export PRIMARY_HA_IP_ADDRESS='10.1.30.4'
export SECONDARY_HA_IP_ADDRESS='10.1.30.5'
export DSC_GROUP_NAME='robot_framework_failover_group'

# ltm virtual - tcp round robin
export TCP_ROUND_ROBIN_VIP_NAME='tcp_round_robin_vs'
export TCP_ROUND_ROBIN_VIP_ADDRESS='10.1.10.5'
export TCP_ROUND_ROBIN_VIP_MASK='255.255.255.255'
export TCP_ROUND_ROBIN_VIP_PORT='80'
export TCP_ROUND_ROBIN_VIP_PROTOCOL='tcp'
export TCP_ROUND_ROBIN_VIP_SNAT_TYPE='automap'
export TCP_ROUND_ROBIN_POOL_NAME='tcp_round_robin_pool'
export TCP_ROUND_ROBIN_POOL_MEMBERS='[{"address":"10.1.20.21","port":"80"},{"address":"10.1.20.22","port":"80"},{"address":"10.1.20.23","port":"80"},{"address":"10.1.20.24","port":"80"},{"address":"10.1.20.25","port":"80"},{"address":"10.1.20.26","port":"80"},{"address":"10.1.20.27","port":"80"},{"address":"10.1.20.28","port":"80"},{"address":"10.1.20.29","port":"80"},{"address":"10.1.20.30","port":"80"}]'
export TCP_ROUND_ROBIN_POOL_MONITOR='/Common/gateway_icmp'

# ltm virtual - udp round robin
export UDP_ROUND_ROBIN_VIP_NAME='udp_dns_round_robin_vs'
export UDP_ROUND_ROBIN_VIP_PARTITION='Common'
export UDP_ROUND_ROBIN_VIP_ADDRESS='10.1.10.2'
export UDP_ROUND_ROBIN_VIP_MASK='255.255.255.255'
export UDP_ROUND_ROBIN_VIP_PORT='53'
export UDP_ROUND_ROBIN_VIP_PROTOCOL='udp'
export UDP_ROUND_ROBIN_VIP_SNAT_TYPE='automap'
export UDP_ROUND_ROBIN_POOL_NAME='udp_dns_round_robin_pool'
export UDP_ROUND_ROBIN_POOL_MEMBERS='[{"address":"10.1.20.21","port":"53"},{"address":"10.1.20.22","port":"53"},{"address":"10.1.20.23","port":"53"},{"address":"10.1.20.24","port":"53"},{"address":"10.1.20.25","port":"53"},{"address":"10.1.20.26","port":"53"},{"address":"10.1.20.27","port":"53"},{"address":"10.1.20.28","port":"53"},{"address":"10.1.20.29","port":"53"},{"address":"10.1.20.30","port":"53"}]'
export UDP_ROUND_ROBIN_POOL_MONITOR='/Common/gateway_icmp'

# sys ntp
export NTP_SERVER_LIST='["108.61.73.244","69.89.207.199"]'

# sys provision
export MODULE_PROVISIONING='[{"module":"ltm","provisioningLevel":"nominal"},{"module":"gtm","provisioningLevel":"nominal"}]'

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
export SNMPV3_SECURITY_NAME='robot_framework'
export SNMPV3_PORT='161'
export SNMPV3_TIMEOUT='5'
export SNMPV3_RETRIES='12'

# net interface
export PRIMARY_INTERFACE_DETAILS='[{"name":"1.1","description":"Configured by Robot Framework","lldpAdmin":"txrx"},{"name":"1.2","description":"Configured by Robot Framework","lldpAdmin":"txrx"},{"name":"1.3","description":"Configured by Robot Framework","lldpAdmin":"txrx"}]'
export SECONDARY_INTERFACE_DETAILS='[{"name":"1.1","description":"Configured by Robot Framework","lldpAdmin":"txrx"},{"name":"1.2","description":"Configured by Robot Framework","lldpAdmin":"txrx"},{"name":"1.3","description":"Configured by Robot Framework","lldpAdmin":"txrx"}]'

# net self
export PRIMARY_LOCAL_SELF_IP_LIST='[{"name":"public-ipv4-self-local","address":"10.1.10.4/24","partition":"Common","vlan":"public","allow-service":"all"},{"name":"private-ipv4-self-local","address":"10.1.20.4/24","partition":"Common","vlan":"private","allow-service":"all"},{"name":"ha-ipv4-self-local","address":"10.1.30.4/24","partition":"Common","vlan":"ha","allow-service":"all"}]'
#export PRIMARY_FLOATING_SELF_IP_LIST='[{"name":"public-ipv4-self-floating","address":"10.1.10.200/24","partition":"Common","vlan":"public","allow-service":"all"},{"name":"private-ipv4-self-floating","address":"10.1.20.200/24","partition":"Common","vlan":"private","allow-service":"all"}]'
export SECONDARY_LOCAL_SELF_IP_LIST='[{"name":"public-ipv4-self-local","address":"10.1.10.5/24","partition":"Common","vlan":"public","allow-service":"all"},{"name":"private-ipv4-self-local","address":"10.1.20.5/24","partition":"Common","vlan":"private","allow-service":"all"},{"name":"ha-ipv4-self-local","address":"10.1.30.5/24","partition":"Common","vlan":"ha","allow-service":"all"}]'
#export SECONDARY_FLOATING_SELF_IP_LIST='[{"name":"public-ipv4-self-floating","address":"10.1.10.200/24","partition":"Common","vlan":"public","allow-service":"all"},{"name":"private-ipv4-self-floating","address":"10.1.20.200/24","partition":"Common","vlan":"private","allow-service":"all"}]'

# net route
export PRIMARY_STATIC_DEFAULT_ROUTE='{"gw":"10.1.10.1","description":"Configured by ROBOT FRAMEWORK","partition":"Common"}'
export SECONDARY_STATIC_DEFAULT_ROUTE='{"gw":"10.1.10.1","description":"Configured by ROBOT FRAMEWORK","partition":"Common"}'

# net vlan
export OUTSIDE_VLAN_NAME='public'
export OUTSIDE_VLAN_TAG='4093'
export OUTSIDE_VLAN_TAGGED='False'
export OUTSIDE_INTERFACE_NAME='1.1'
export INSIDE_VLAN_NAME='private'
export INSIDE_VLAN_TAG='4092'
export INSIDE_VLAN_TAGGED='False'
export INSIDE_INTERFACE_NAME='1.2'
export HA_VLAN_NAME='ha'
export HA_VLAN_TAG='4091'
export HA_VLAN_TAGGED='False'
export HA_INTERFACE_NAME='1.3'

# bgp peering
export BGP_PRIMARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID='0'
export BGP_PRIMARY_SINGLE_CONTEXT_ROUTE_DOMAIN_NAME='0'
export BGP_PRIMARY_SINGLE_CONTEXT_GRACEFUL_RESTART_TIME='120'
export BGP_PRIMARY_SINGLE_CONTEXT_IPv4_REDIST_KERNEL_ROUTE_MAP_NAME='IPv4RHIRM'
export BGP_PRIMARY_SINGLE_CONTEXT_IPv4_REDIST_CONNECTED_ROUTE_MAP_NAME='IPv4ConnectedRM'
export BGP_PRIMARY_SINGLE_CONTEXT_IPv4_REDIST_STATIC_ROUTE_MAP_NAME='IPv4StaticRM'
export BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_NAME='IPv4NorthPeerGroup'
export BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS='65479'
export BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_REMOTE_AS='65179'
export BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_UPDATE_SOURCE='uplink'
export BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_TIMERS_KEEPALIVE='1'
export BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_TIMERS_HOLD='12'
export BGP_PRIMARY_SINGLE_CONTEXT_IPv4_ROUTE_MAP_IN='IPv4InboundRM'
export BGP_PRIMARY_SINGLE_CONTEXT_IPv4_ROUTE_MAP_OUT='IPv4OutboundRM'
export BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEERS='[{"neighbor":"10.1.10.1","peer-group":"IPv4NorthPeerGroup","description":"Nexus","expected_advertised_routes":["10.1.20.0/21"],"device_management_ip":"10.240.73.201","device_username":"netqa","device_password":"RobotR0cks","local_peering_ip":"10.1.10.5","peer_vrf":"SPOCSLBTestbedEnv4_179","peer_vdc":"dcr01sqsccc"},{"neighbor":"10.1.10.2","peer-group":"IPv4NorthPeerGroup","description":"Nexus","expected_advertised_routes":["10.1.20.0/21"],"device_management_ip":"10.240.73.202","device_username":"netqa","device_password":"RobotR0cks","local_peering_ip":"10.1.10.5","peer_vrf":"SPOCSLBTestbedEnv4_179","peer_vdc":"dcr02sqsccc"}]'
export BGP_PRIMARY_SINGLE_CONTEXT_IPv4_STATIC_ROUTES='[{"network":"10.1.0.0/16","gateway":"Null"}]'
export BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PREFIX_LISTS='[{"name":"IPv4ConnectedRoutesPL","entries":[{"sequence":"10","action":"permit","subnetString":"10.1.20.0/21"}]},{"name":"IPv4DefaultPL","entries":[{"sequence":"10","action":"permit","subnetString":"0.0.0.0/0"}]},{"name":"IPv4StaticsPL","entries":[{"sequence":"10","action":"permit","subnetString":"10.1.0.0/16"}]},{"name":"IPv4VirtualsPL","entries":[{"sequence":"10","action":"permit","subnetString":"10.1.10.0/19 le 32"}]}]'
export BGP_PRIMARY_SINGLE_CONTEXT_IPv4_ROUTE_MAPS='[{"name":"IPv4InboundRM","entries":[{"action":"permit","sequence":"10","match":"ip address prefix-list IPv4DefaultPL"},{"action":"deny","sequence":"9999","match":"all"}]},{"name":"IPv4OutboundRM","entries":[{"action":"permit","sequence":"10","match":"ip address prefix-list IPv4ConnectedRoutesPL"},{"action":"permit","sequence":"20","match":"ip address prefix-list IPv4VirtualsPL"},{"action":"permit","sequence":"30","match":"ip address prefix-list IPv4StaticsPL"},{"action":"deny","sequence":"9999","match":"all"}]},{"name":"IPv4RHIRM","entries":[{"action":"permit","sequence":"10","match":"ip address prefix-list IPv4VirtualsPL"},{"action":"deny","sequence":"9999","match":"all"}]},{"name":"IPv4ConnectedRM","entries":[{"action":"permit","sequence":"10","match":"ip address prefix-list IPv4ConnectedRoutesPL"},{"action":"deny","sequence":"9999","match":"all"}]},{"name":"IPv4StaticRM","entries":[{"action":"permit","sequence":"10","match":"ip address prefix-list IPv4StaticRoutesPL"},{"action":"deny","sequence":"9999","match":"all"}]},{"name":"IPv6InboundRM","entries":[{"action":"permit","sequence":"10","match":"ip address prefix-list IPv6DefaultPL"},{"action":"deny","sequence":"9999","match":"all"}]},{"name":"IPv6RHIRM","entries":[{"action":"permit","sequence":"10","match":"ipv6 address prefix-list IPv6VirtualsPL"},{"action":"deny","sequence":"9999","match":"all"}]},{"name":"IPv6ConnectedRM","entries":[{"action":"permit","sequence":"10","match":"ipv6 address prefix-list IPv6ConnectedRoutesPL"},{"action":"deny","sequence":"9999","match":"all"}]},{"name":"IPv6StaticRM","entries":[{"action":"permit","sequence":"10","match":"ip address prefix-list IPv6StaticRoutesPL"},{"action":"deny","sequence":"9999","match":"all"}]}]'
export BGP_PRIMARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_NAME='IPv6NorthPeerGroup'
export BGP_PRIMARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_DESCRIPTION='N5696Q-A'
export BGP_PRIMARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_LOCAL_AS='65479'
export BGP_PRIMARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_REMOTE_AS='65179'
export BGP_PRIMARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_UPDATE_SOURCE='uplink'
export BGP_PRIMARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_TIMERS_KEEPALIVE='1'
export BGP_PRIMARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_TIMERS_HOLD='12'
export BGP_PRIMARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_ROUTE_MAP_IN='IPv6InboundRM'
export BGP_PRIMARY_SINGLE_CONTEXT_IPv6_REDIST_KERNEL_ROUTE_MAP_NAME='IPv6RHIRM'
export BGP_PRIMARY_SINGLE_CONTEXT_IPv6_REDIST_CONNECTED_ROUTE_MAP_NAME='IPv6ConnectedRM'
export BGP_PRIMARY_SINGLE_CONTEXT_IPv6_REDIST_STATIC_ROUTE_MAP_NAME='IPv6StaticRM'
export BGP_PRIMARY_SINGLE_CONTEXT_IPv6_PEERS='[{"neighbor":"2001:200:0:4401::1","peer-group":"IPv6NorthPeerGroup","description":"Nexus","expected_advertised_routes":["2001:200:0:4401::/64"],"device_management_ip":"10.240.73.201","device_username":"netqa","device_password":"RobotR0cks","local_peering_ip":"2001:200:0:4401::5","peer_vrf":"SPOCSLBTestbedEnv4_179","peer_vdc":"dcr01sqsccc"},{"neighbor":"2001:200:0:4401::2","peer-group":"IPv6NorthPeerGroup","description":"Nexus","expected_advertised_routes":["2001:200:0:4401::/64"],"device_management_ip":"10.240.73.202","device_username":"netqa","device_password":"RobotR0cks","local_peering_ip":"2001:200:0:4401::5","peer_vrf":"SPOCSLBTestbedEnv4_179","peer_vdc":"dcr02sqsccc"}]'
export BGP_PRIMARY_SINGLE_CONTEXT_IPv6_PREFIX_LISTS='[{"name":"IPv6ConnectedRoutesPL","entries":[{"sequence":"10","action":"permit","subnetString":"2001:200:0:4401::/64 le 128"}]},{"name":"IPv6DefaultPL","entries":[{"sequence":"10","action":"permit","subnetString":"::/0"}]},{"name":"IPv6StaticsPL","entries":[{"sequence":"10","action":"permit","subnetString":"2001:200:0:4404::/64"}]},{"name":"IPv6VirtualsPL","entries":[{"sequence":"10","action":"permit","subnetString":"2001:200:0:4201::/64 le 128"}]}]'
# Secondary:
export BGP_SECONDARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID='0'
export BGP_SECONDARY_SINGLE_CONTEXT_ROUTE_DOMAIN_NAME='0'
export BGP_SECONDARY_SINGLE_CONTEXT_GRACEFUL_RESTART_TIME='120'
export BGP_SECONDARY_SINGLE_CONTEXT_IPv4_REDIST_KERNEL_ROUTE_MAP_NAME='IPv4RHIRM'
export BGP_SECONDARY_SINGLE_CONTEXT_IPv4_REDIST_CONNECTED_ROUTE_MAP_NAME='IPv4ConnectedRM'
export BGP_SECONDARY_SINGLE_CONTEXT_IPv4_REDIST_STATIC_ROUTE_MAP_NAME='IPv4StaticRM'
export BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_NAME='IPv4NorthPeerGroup'
export BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS='65479'
export BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_REMOTE_AS='65179'
export BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_UPDATE_SOURCE='uplink'
export BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_TIMERS_KEEPALIVE='1'
export BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_TIMERS_HOLD='12'
export BGP_SECONDARY_SINGLE_CONTEXT_IPv4_ROUTE_MAP_IN='IPv4InboundRM'
export BGP_SECONDARY_SINGLE_CONTEXT_IPv4_ROUTE_MAP_OUT='IPv4OutboundRM'
export BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEERS='[{"neighbor":"10.1.10.1","peer-group":"IPv4NorthPeerGroup","description":"Nexus","expected_advertised_routes":["10.1.20.0/21"],"device_management_ip":"10.240.73.201","device_username":"netqa","device_password":"RobotR0cks","local_peering_ip":"10.1.10.6","peer_vrf":"SPOCSLBTestbedEnv4_179","peer_vdc":"dcr01sqsccc"},{"neighbor":"10.1.10.2","peer-group":"IPv4NorthPeerGroup","description":"Nexus","expected_advertised_routes":["10.1.20.0/21"],"device_management_ip":"10.240.73.202","device_username":"netqa","device_password":"RobotR0cks","local_peering_ip":"10.1.10.6","peer_vrf":"SPOCSLBTestbedEnv4_179","peer_vdc":"dcr02sqsccc"}]'
export BGP_SECONDARY_SINGLE_CONTEXT_IPv4_STATIC_ROUTES='[{"network":"10.1.0.0/16","gateway":"Null"}]'
export BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PREFIX_LISTS='[{"name":"IPv4ConnectedRoutesPL","entries":[{"sequence":"10","action":"permit","subnetString":"10.1.20.0/21"}]},{"name":"IPv4DefaultPL","entries":[{"sequence":"10","action":"permit","subnetString":"0.0.0.0/0"}]},{"name":"IPv4StaticsPL","entries":[{"sequence":"10","action":"permit","subnetString":"10.1.0.0/16"}]},{"name":"IPv4VirtualsPL","entries":[{"sequence":"10","action":"permit","subnetString":"10.1.10.0/19 le 32"}]}]'
export BGP_SECONDARY_SINGLE_CONTEXT_IPv4_ROUTE_MAPS='[{"name":"IPv4InboundRM","entries":[{"action":"permit","sequence":"10","match":"ip address prefix-list IPv4DefaultPL"},{"action":"deny","sequence":"9999","match":"all"}]},{"name":"IPv4OutboundRM","entries":[{"action":"permit","sequence":"10","match":"ip address prefix-list IPv4ConnectedRoutesPL"},{"action":"permit","sequence":"20","match":"ip address prefix-list IPv4VirtualsPL"},{"action":"permit","sequence":"30","match":"ip address prefix-list IPv4StaticsPL"},{"action":"deny","sequence":"9999","match":"all"}]},{"name":"IPv4RHIRM","entries":[{"action":"permit","sequence":"10","match":"ip address prefix-list IPv4VirtualsPL"},{"action":"deny","sequence":"9999","match":"all"}]},{"name":"IPv4ConnectedRM","entries":[{"action":"permit","sequence":"10","match":"ip address prefix-list IPv4ConnectedRoutesPL"},{"action":"deny","sequence":"9999","match":"all"}]},{"name":"IPv4StaticRM","entries":[{"action":"permit","sequence":"10","match":"ip address prefix-list IPv4StaticRoutesPL"},{"action":"deny","sequence":"9999","match":"all"}]},{"name":"IPv6InboundRM","entries":[{"action":"permit","sequence":"10","match":"ip address prefix-list IPv6DefaultPL"},{"action":"deny","sequence":"9999","match":"all"}]},{"name":"IPv6RHIRM","entries":[{"action":"permit","sequence":"10","match":"ipv6 address prefix-list IPv6VirtualsPL"},{"action":"deny","sequence":"9999","match":"all"}]},{"name":"IPv6ConnectedRM","entries":[{"action":"permit","sequence":"10","match":"ipv6 address prefix-list IPv6ConnectedRoutesPL"},{"action":"deny","sequence":"9999","match":"all"}]},{"name":"IPv6StaticRM","entries":[{"action":"permit","sequence":"10","match":"ip address prefix-list IPv6StaticRoutesPL"},{"action":"deny","sequence":"9999","match":"all"}]}]'
export BGP_SECONDARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_NAME='IPv6NorthPeerGroup'
export BGP_SECONDARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_DESCRIPTION='N5696Q-B'
export BGP_SECONDARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_LOCAL_AS='65479'
export BGP_SECONDARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_REMOTE_AS='65179'
export BGP_SECONDARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_UPDATE_SOURCE='uplink'
export BGP_SECONDARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_TIMERS_KEEPALIVE='1'
export BGP_SECONDARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_TIMERS_HOLD='12'
export BGP_SECONDARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_ROUTE_MAP_IN='IPv6InboundRM'
export BGP_SECONDARY_SINGLE_CONTEXT_IPv6_REDIST_KERNEL_ROUTE_MAP_NAME='IPv6RHIRM'
export BGP_SECONDARY_SINGLE_CONTEXT_IPv6_REDIST_CONNECTED_ROUTE_MAP_NAME='IPv6ConnectedRM'
export BGP_SECONDARY_SINGLE_CONTEXT_IPv6_REDIST_STATIC_ROUTE_MAP_NAME='IPv6StaticRM'
export BGP_SECONDARY_SINGLE_CONTEXT_IPv6_PEERS='[{"neighbor":"2001:200:0:4401::1","peer-group":"IPv6NorthPeerGroup","description":"Nexus","expected_advertised_routes":["2001:200:0:4401::/64"],"device_management_ip":"10.240.73.201","device_username":"netqa","device_password":"RobotR0cks","local_peering_ip":"2001:200:0:4401::6","peer_vrf":"SPOCSLBTestbedEnv4_179","peer_vdc":"dcr01sqsccc"},{"neighbor":"2001:200:0:4401::2","peer-group":"IPv6NorthPeerGroup","description":"Nexus","expected_advertised_routes":["2001:200:0:4401::/64"],"device_management_ip":"10.240.73.202","device_username":"netqa","device_password":"RobotR0cks","local_peering_ip":"2001:200:0:4401::6","peer_vrf":"SPOCSLBTestbedEnv4_179","peer_vdc":"dcr02sqsccc"}]'
export BGP_SECONDARY_SINGLE_CONTEXT_IPv6_PREFIX_LISTS='[{"name":"IPv6ConnectedRoutesPL","entries":[{"sequence":"10","action":"permit","subnetString":"2001:200:0:4401::/64 le 128"}]},{"name":"IPv6DefaultPL","entries":[{"sequence":"10","action":"permit","subnetString":"::/0"}]},{"name":"IPv6StaticsPL","entries":[{"sequence":"10","action":"permit","subnetString":"2001:200:0:4404::/64"}]},{"name":"IPv6VirtualsPL","entries":[{"sequence":"10","action":"permit","subnetString":"2001:200:0:4201::/64 le 128"}]}]'

# Non-default route domain GSLB
export DNS_NON_DEFAULT_ROUTE_DOMAIN_DATACENTER_NAME='ROBOT-FRAMEWORK-DNS-NON-DEFAULT-ROUTE-DOMAIN-DATACENTER'
export DNS_NON_DEFAULT_ROUTE_DOMAIN_DATACENTER_LOCATION='Lab'
export DNS_NON_DEFAULT_ROUTE_DOMAIN_VLAN_NAME='ROBOT-FRAMEWORK-DNS-NON-DEFAULT-ROUTE-DOMAIN-VLAN'
export DNS_NON_DEFAULT_ROUTE_DOMAIN_VLAN_TAG='2500'
export DNS_NON_DEFAULT_ROUTE_DOMAIN_VIP_IPv4='10.1.10.10'
export DNS_NON_DEFAULT_ROUTE_DOMAIN_VIP_MASK='255.255.255.255'
export DNS_NON_DEFAULT_ROUTE_DOMAIN_VIP_IPv6='2001:f5:f5:2500:10:1:10:10'
export DNS_NON_DEFAULT_ROUTE_DOMAIN_VIP_MASK='ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff'
export DNS_NON_DEFAULT_ROUTE_DOMAIN_SYNC_GROUP_NAME='ROBOT-FRAMEWORK-DNS-SYNC-GROUP'
export DNS_NON_DEFAULT_ROUTE_DOMAIN_BIGIP_SERVER_NAME='ROBOT-FRAMEWORK-LTM-DNS-SERVER'
export DNS_NON_DEFAULT_ROUTE_DOMAIN_VIP_PREFIX='ROBOT-FRAMEWORK-NON-DEFAULT-ROUTE-DOMAIN-DNS-'
# Primary:
# these variables cannot be set to the management port IP address! GTM must sync in-band!
export DNS_NON_DEFAULT_ROUTE_DOMAIN_PRIMARY_SYNC_SELF_IP='10.1.10.4'
# Secondary:
# these variables cannot be set to the management port IP address! GTM must sync in-band!
export DNS_NON_DEFAULT_ROUTE_DOMAIN_SECONDARY_SYNC_SELF_IP='10.1.10.5'

# Delete existing reports
rm -f ./reports/*.html
rm -f ./reports/*.xml

printf "####################################\n"
printf "## Executing Robot Framework Tests  \n"
printf "####################################\n"
start_time=`date`

# Execute tests in order via this array
tests=('reset_environment' 'pretest_configuration' 'baseline_testing' 'monitoring' 'network' 'administration')

# Cycle through list of tests and create a per-test report in /reports
for current_test in "${tests[@]}"
do 
    robot --noncritical non_critical --consolewidth 156 --outputdir ./reports -o $current_test.xml -l $current_test.log.html -r $current_test.report.html ./$current_test.robot
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
