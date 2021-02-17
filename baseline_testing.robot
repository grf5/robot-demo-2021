*** Settings ***
Documentation    This test checks for basic access to the management services (SSH, HTTPS UI, iControl REST API)
Resource    robotframework-f5-tmos.robot
Resource    robotframework-f5-zebos.robot

*** Variables ***
${PRIMARY_HOSTNAME}    %{PRIMARY_HOSTNAME}
${PRIMARY_MGMT_IP}    %{PRIMARY_MGMT_IP}
${PRIMARY_SSH_USERNAME}    %{PRIMARY_SSH_USERNAME}
${PRIMARY_SSH_PASSWORD}    %{PRIMARY_SSH_PASSWORD}
${PRIMARY_HTTP_USERNAME}    %{PRIMARY_HTTP_USERNAME}
${PRIMARY_HTTP_PASSWORD}    %{PRIMARY_HTTP_PASSWORD}
${SECONDARY_HOSTNAME}    %{SECONDARY_HOSTNAME}
${SECONDARY_MGMT_IP}    %{SECONDARY_MGMT_IP}
${SECONDARY_SSH_USERNAME}    %{SECONDARY_SSH_USERNAME}
${SECONDARY_SSH_PASSWORD}    %{SECONDARY_SSH_PASSWORD}
${SECONDARY_HTTP_USERNAME}    %{SECONDARY_HTTP_USERNAME}
${SECONDARY_HTTP_PASSWORD}    %{SECONDARY_HTTP_PASSWORD}
${NTP_SERVER_LIST}    %{NTP_SERVER_LIST}
${MGMT_NETWORK_GATEWAY}    %{MGMT_NETWORK_GATEWAY}
${BGP_PRIMARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}    %{BGP_PRIMARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}
${BGP_PRIMARY_SINGLE_CONTEXT_ROUTE_DOMAIN_NAME}    %{BGP_PRIMARY_SINGLE_CONTEXT_ROUTE_DOMAIN_NAME}
${BGP_PRIMARY_SINGLE_CONTEXT_GRACEFUL_RESTART_TIME}    %{BGP_PRIMARY_SINGLE_CONTEXT_GRACEFUL_RESTART_TIME}
${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_REDIST_KERNEL_ROUTE_MAP_NAME}    %{BGP_PRIMARY_SINGLE_CONTEXT_IPv4_REDIST_KERNEL_ROUTE_MAP_NAME}
${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_REDIST_CONNECTED_ROUTE_MAP_NAME}    %{BGP_PRIMARY_SINGLE_CONTEXT_IPv4_REDIST_CONNECTED_ROUTE_MAP_NAME}
${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_REDIST_STATIC_ROUTE_MAP_NAME}    %{BGP_PRIMARY_SINGLE_CONTEXT_IPv4_REDIST_STATIC_ROUTE_MAP_NAME}
${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_NAME}    %{BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_NAME}
${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    %{BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}
${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_REMOTE_AS}    %{BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_REMOTE_AS}
${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_UPDATE_SOURCE}    %{BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_UPDATE_SOURCE}
${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_TIMERS_KEEPALIVE}    %{BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_TIMERS_KEEPALIVE}
${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_TIMERS_HOLD}    %{BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_TIMERS_HOLD}
${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_ROUTE_MAP_IN}    %{BGP_PRIMARY_SINGLE_CONTEXT_IPv4_ROUTE_MAP_IN}
${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_ROUTE_MAP_OUT}    %{BGP_PRIMARY_SINGLE_CONTEXT_IPv4_ROUTE_MAP_OUT}
${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEERS}    %{BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEERS}
${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_STATIC_ROUTES}    %{BGP_PRIMARY_SINGLE_CONTEXT_IPv4_STATIC_ROUTES}
${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PREFIX_LISTS}    %{BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PREFIX_LISTS}
${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_ROUTE_MAPS}    %{BGP_PRIMARY_SINGLE_CONTEXT_IPv4_ROUTE_MAPS}
${BGP_PRIMARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_NAME}    %{BGP_PRIMARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_NAME}
${BGP_PRIMARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_DESCRIPTION}    %{BGP_PRIMARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_DESCRIPTION}
${BGP_PRIMARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_LOCAL_AS}    %{BGP_PRIMARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_LOCAL_AS}
${BGP_PRIMARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_REMOTE_AS}    %{BGP_PRIMARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_REMOTE_AS}
${BGP_PRIMARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_UPDATE_SOURCE}    %{BGP_PRIMARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_UPDATE_SOURCE}
${BGP_PRIMARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_TIMERS_KEEPALIVE}    %{BGP_PRIMARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_TIMERS_KEEPALIVE}
${BGP_PRIMARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_TIMERS_HOLD}    %{BGP_PRIMARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_TIMERS_HOLD}
${BGP_PRIMARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_ROUTE_MAP_IN}    %{BGP_PRIMARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_ROUTE_MAP_IN}
${BGP_PRIMARY_SINGLE_CONTEXT_IPv6_REDIST_KERNEL_ROUTE_MAP_NAME}    %{BGP_PRIMARY_SINGLE_CONTEXT_IPv6_REDIST_KERNEL_ROUTE_MAP_NAME}
${BGP_PRIMARY_SINGLE_CONTEXT_IPv6_REDIST_CONNECTED_ROUTE_MAP_NAME}    %{BGP_PRIMARY_SINGLE_CONTEXT_IPv6_REDIST_CONNECTED_ROUTE_MAP_NAME}
${BGP_PRIMARY_SINGLE_CONTEXT_IPv6_REDIST_STATIC_ROUTE_MAP_NAME}    %{BGP_PRIMARY_SINGLE_CONTEXT_IPv6_REDIST_STATIC_ROUTE_MAP_NAME}
${BGP_PRIMARY_SINGLE_CONTEXT_IPv6_PEERS}    %{BGP_PRIMARY_SINGLE_CONTEXT_IPv6_PEERS}
${BGP_PRIMARY_SINGLE_CONTEXT_IPv6_PREFIX_LISTS}    %{BGP_PRIMARY_SINGLE_CONTEXT_IPv6_PREFIX_LISTS}
${BGP_SECONDARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}    %{BGP_SECONDARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}
${BGP_SECONDARY_SINGLE_CONTEXT_ROUTE_DOMAIN_NAME}    %{BGP_SECONDARY_SINGLE_CONTEXT_ROUTE_DOMAIN_NAME}
${BGP_SECONDARY_SINGLE_CONTEXT_GRACEFUL_RESTART_TIME}    %{BGP_SECONDARY_SINGLE_CONTEXT_GRACEFUL_RESTART_TIME}
${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_REDIST_KERNEL_ROUTE_MAP_NAME}    %{BGP_SECONDARY_SINGLE_CONTEXT_IPv4_REDIST_KERNEL_ROUTE_MAP_NAME}
${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_REDIST_CONNECTED_ROUTE_MAP_NAME}    %{BGP_SECONDARY_SINGLE_CONTEXT_IPv4_REDIST_CONNECTED_ROUTE_MAP_NAME}
${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_REDIST_STATIC_ROUTE_MAP_NAME}    %{BGP_SECONDARY_SINGLE_CONTEXT_IPv4_REDIST_STATIC_ROUTE_MAP_NAME}
${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_NAME}    %{BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_NAME}
${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    %{BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}
${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_REMOTE_AS}    %{BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_REMOTE_AS}
${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_UPDATE_SOURCE}    %{BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_UPDATE_SOURCE}
${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_TIMERS_KEEPALIVE}    %{BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_TIMERS_KEEPALIVE}
${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_TIMERS_HOLD}    %{BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_TIMERS_HOLD}
${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_ROUTE_MAP_IN}    %{BGP_SECONDARY_SINGLE_CONTEXT_IPv4_ROUTE_MAP_IN}
${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_ROUTE_MAP_OUT}    %{BGP_SECONDARY_SINGLE_CONTEXT_IPv4_ROUTE_MAP_OUT}
${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEERS}    %{BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEERS}
${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_STATIC_ROUTES}    %{BGP_SECONDARY_SINGLE_CONTEXT_IPv4_STATIC_ROUTES}
${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PREFIX_LISTS}    %{BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PREFIX_LISTS}
${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_ROUTE_MAPS}    %{BGP_SECONDARY_SINGLE_CONTEXT_IPv4_ROUTE_MAPS}
${BGP_SECONDARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_NAME}    %{BGP_SECONDARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_NAME}
${BGP_SECONDARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_DESCRIPTION}    %{BGP_SECONDARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_DESCRIPTION}
${BGP_SECONDARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_LOCAL_AS}    %{BGP_SECONDARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_LOCAL_AS}
${BGP_SECONDARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_REMOTE_AS}    %{BGP_SECONDARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_REMOTE_AS}
${BGP_SECONDARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_UPDATE_SOURCE}    %{BGP_SECONDARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_UPDATE_SOURCE}
${BGP_SECONDARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_TIMERS_KEEPALIVE}    %{BGP_SECONDARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_TIMERS_KEEPALIVE}
${BGP_SECONDARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_TIMERS_HOLD}    %{BGP_SECONDARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_TIMERS_HOLD}
${BGP_SECONDARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_ROUTE_MAP_IN}    %{BGP_SECONDARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_ROUTE_MAP_IN}
${BGP_SECONDARY_SINGLE_CONTEXT_IPv6_REDIST_KERNEL_ROUTE_MAP_NAME}    %{BGP_SECONDARY_SINGLE_CONTEXT_IPv6_REDIST_KERNEL_ROUTE_MAP_NAME}
${BGP_SECONDARY_SINGLE_CONTEXT_IPv6_REDIST_CONNECTED_ROUTE_MAP_NAME}    %{BGP_SECONDARY_SINGLE_CONTEXT_IPv6_REDIST_CONNECTED_ROUTE_MAP_NAME}
${BGP_SECONDARY_SINGLE_CONTEXT_IPv6_REDIST_STATIC_ROUTE_MAP_NAME}    %{BGP_SECONDARY_SINGLE_CONTEXT_IPv6_REDIST_STATIC_ROUTE_MAP_NAME}
${BGP_SECONDARY_SINGLE_CONTEXT_IPv6_PEERS}    %{BGP_SECONDARY_SINGLE_CONTEXT_IPv6_PEERS}
${BGP_SECONDARY_SINGLE_CONTEXT_IPv6_PREFIX_LISTS}    %{BGP_SECONDARY_SINGLE_CONTEXT_IPv6_PREFIX_LISTS} 
${DNS_NON_DEFAULT_ROUTE_DOMAIN_DATACENTER_NAME}    %{DNS_NON_DEFAULT_ROUTE_DOMAIN_DATACENTER_NAME}
${DNS_NON_DEFAULT_ROUTE_DOMAIN_DATACENTER_LOCATION}    %{DNS_NON_DEFAULT_ROUTE_DOMAIN_DATACENTER_LOCATION}
${DNS_NON_DEFAULT_ROUTE_DOMAIN_VLAN_NAME}    %{DNS_NON_DEFAULT_ROUTE_DOMAIN_VLAN_NAME}
${DNS_NON_DEFAULT_ROUTE_DOMAIN_VLAN_TAG}    %{DNS_NON_DEFAULT_ROUTE_DOMAIN_VLAN_TAG}
${DNS_NON_DEFAULT_ROUTE_DOMAIN_VIP_PREFIX}    %{DNS_NON_DEFAULT_ROUTE_DOMAIN_VIP_PREFIX}
${DNS_NON_DEFAULT_ROUTE_DOMAIN_VIP_IPv4}    %{DNS_NON_DEFAULT_ROUTE_DOMAIN_VIP_IPv4}
${DNS_NON_DEFAULT_ROUTE_DOMAIN_VIP_MASK}    %{DNS_NON_DEFAULT_ROUTE_DOMAIN_VIP_MASK}
${DNS_NON_DEFAULT_ROUTE_DOMAIN_VIP_IPv6}    %{DNS_NON_DEFAULT_ROUTE_DOMAIN_VIP_IPv6}
${DNS_NON_DEFAULT_ROUTE_DOMAIN_VIP_MASK}    %{DNS_NON_DEFAULT_ROUTE_DOMAIN_VIP_MASK}
${DNS_NON_DEFAULT_ROUTE_DOMAIN_SYNC_GROUP_NAME}    %{DNS_NON_DEFAULT_ROUTE_DOMAIN_SYNC_GROUP_NAME}
${DNS_NON_DEFAULT_ROUTE_DOMAIN_BIGIP_SERVER_NAME}    %{DNS_NON_DEFAULT_ROUTE_DOMAIN_BIGIP_SERVER_NAME}
${DNS_NON_DEFAULT_ROUTE_DOMAIN_PRIMARY_SYNC_SELF_IP}    %{DNS_NON_DEFAULT_ROUTE_DOMAIN_PRIMARY_SYNC_SELF_IP}
${DNS_NON_DEFAULT_ROUTE_DOMAIN_SECONDARY_SYNC_SELF_IP}    %{DNS_NON_DEFAULT_ROUTE_DOMAIN_SECONDARY_SYNC_SELF_IP}

*** Test Cases ***
Perform BIG-IP Quick Check
    [Documentation]  Verifies that key BIG-IP services are in a ready state
    set log level  trace
    Wait until Keyword Succeeds    30x    10 seconds    Verify All BIG-IP Ready States    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}
    Wait until Keyword Succeeds    12x    15 seconds    Check for BIG-IP Services Waiting to Restart    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    Wait until Keyword Succeeds    30x    10 seconds    Verify All BIG-IP Ready States    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}
    Wait until Keyword Succeeds    12x    15 seconds    Check for BIG-IP Services Waiting to Restart    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}

Verify Console Connectivity
    [Documentation]  Verifies that the BIG-IP can be reached by console
    set log level  trace
    log  this would contain environment-specific steps to reach the BIG-IP via console (terminal server)

Set the 'admin' user shell to bash
    [Documentation]  Sets the admin user's default shell from tmsh to bash
    set log level  trace
    Change a User's Default Shell    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    username=admin    shell=bash
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    Change a User's Default Shell    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    username=admin    shell=bash

Verify SSH Connectivity
    [Documentation]  Logs into the BIG-IP via SSH, executes a BASH command and validates the expected response
    set log level  trace
    Wait until Keyword Succeeds    3x    5 seconds    Open Connection    ${PRIMARY_MGMT_IP}
    Log In    ${PRIMARY_SSH_USERNAME}    ${PRIMARY_SSH_PASSWORD}
    Run BASH Echo Test
    Close All Connections
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    Wait until Keyword Succeeds    3x    5 seconds    Open Connection    ${SECONDARY_MGMT_IP}
    Log In    ${SECONDARY_SSH_USERNAME}    ${SECONDARY_SSH_PASSWORD}
    Run BASH Echo Test
    Close All Connections

Test BIG-IP Web UI Connectivity
    [Documentation]  Verifies that the BIG-IP is presenting the Web UI login page
    set log level  trace
    Wait until Keyword Succeeds    6x    5 seconds    Retrieve BIG-IP Login Page   bigip_host=${PRIMARY_MGMT_IP}
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    Wait until Keyword Succeeds    6x    5 seconds    Retrieve BIG-IP Login Page   bigip_host=${SECONDARY_MGMT_IP}

Test IPv4 iControlREST API Connectivity
    [Documentation]  Tests BIG-IP iControl REST API connectivity using basic authentication
    set log level  trace
    Wait until Keyword Succeeds    6x    5 seconds    Retrieve BIG-IP Version    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    Wait until Keyword Succeeds    6x    5 seconds    Retrieve BIG-IP Version    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}

Test IPv4 iControlREST Token Authentication
    [Documentation]  Verifies HTTP header auth token functionality on the BIG-IP iControl REST API
    set log level  trace
    Retrieve BIG-IP Version using Token Authentication    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    Retrieve BIG-IP Version using Token Authentication    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}

Enable BGP on Route Domain 0
    [Documentation]  Enables the BGP daemon (ZebOS) on route domain 0, the default route domain
    set log level  trace
    ${desired_protocol_list}    create list    BGP
    Enable BGP Only on BIG-IP Route Domain    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    route_domain_name=${BGP_PRIMARY_SINGLE_CONTEXT_ROUTE_DOMAIN_NAME}
    ${routing_protocol_list}    List Dynamic Routing Protocols Enabled on a Route Domain    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    route_domain_name=${BGP_PRIMARY_SINGLE_CONTEXT_ROUTE_DOMAIN_NAME}
    lists should be equal    ${desired_protocol_list}    ${routing_protocol_list}
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    Enable BGP Only on BIG-IP Route Domain    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    route_domain_name=${BGP_SECONDARY_SINGLE_CONTEXT_ROUTE_DOMAIN_NAME}
    ${routing_protocol_list}    List Dynamic Routing Protocols Enabled on a Route Domain    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    route_domain_name=${BGP_SECONDARY_SINGLE_CONTEXT_ROUTE_DOMAIN_NAME}
    lists should be equal    ${desired_protocol_list}    ${routing_protocol_list}

Enable ZebOS Logging
    [Documentation]  Configures logging for the BGP daemon on the BIG-IP
    set log level  trace
    Enable ZebOS Logging    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    route_domain_id=${BGP_PRIMARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}
    Verify ZebOS Logging Destination    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    route_domain_id=${BGP_PRIMARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    Enable ZebOS Logging    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    route_domain_id=${BGP_SECONDARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}
    Verify ZebOS Logging Destination    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    route_domain_id=${BGP_SECONDARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}

Disable BGP Default IPv4 Unicast
    [Documentation]  Issues the 'no bgp default ipv4-unicast' command on the BIG-IP
    set log level  trace
    Disable BGP Default IPv4 Unicast    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    local_as_number=${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    route_domain_id=${BGP_PRIMARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}
    Verify Disabled BGP Default IPv4 Unicast    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    local_as_number=${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    route_domain_id=${BGP_PRIMARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    Disable BGP Default IPv4 Unicast    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    local_as_number=${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    route_domain_id=${BGP_SECONDARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}
    Verify Disabled BGP Default IPv4 Unicast    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    local_as_number=${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    route_domain_id=${BGP_SECONDARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}

Enable BGP Neighbor Change Logging
    [Documentation]  Issues the 'bgp log-neighbor-changes' command on the BIG-IP
    set log level  trace
    Enable BGP Neighbor Change Logging    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    local_as_number=${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    route_domain_id=${BGP_PRIMARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}    
    Verify BGP Neighbor Change Logging    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    local_as_number=${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    route_domain_id=${BGP_PRIMARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    Enable BGP Neighbor Change Logging    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    local_as_number=${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    route_domain_id=${BGP_SECONDARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}
    Verify BGP Neighbor Change Logging    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    local_as_number=${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    route_domain_id=${BGP_SECONDARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}

Configure the BGP Graceful Restart Timer
    [Documentation]  Issues the 'bgp graceful-restart restart-time' command on the BIG-IP
    set log level  trace
    Configure the BGP Graceful Restart Timer        bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    local_as_number=${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    route_domain_id=${BGP_PRIMARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}    graceful_restart_timer=${BGP_PRIMARY_SINGLE_CONTEXT_GRACEFUL_RESTART_TIME}
    Verify the BGP Graceful Restart Timer        bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    local_as_number=${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    route_domain_id=${BGP_PRIMARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}    graceful_restart_timer=${BGP_PRIMARY_SINGLE_CONTEXT_GRACEFUL_RESTART_TIME}
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    Configure the BGP Graceful Restart Timer        bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    local_as_number=${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    route_domain_id=${BGP_SECONDARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}    graceful_restart_timer=${BGP_SECONDARY_SINGLE_CONTEXT_GRACEFUL_RESTART_TIME}
    Verify the BGP Graceful Restart Timer        bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    local_as_number=${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    route_domain_id=${BGP_SECONDARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}    graceful_restart_timer=${BGP_SECONDARY_SINGLE_CONTEXT_GRACEFUL_RESTART_TIME}

Redistribute IPv4 Kernel Routes with Route-Map
    [Documentation]  Issues the 'redistribute kernel route-map' command on the BIG-IP
    set log level  trace
    Configure IPv4 Kernel Route BGP Redistribution    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    local_as_number=${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    route_map=${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_REDIST_KERNEL_ROUTE_MAP_NAME}    route_domain_id=${BGP_PRIMARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}
    Verify IPv4 Kernel Route BGP Redistribution    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    local_as_number=${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    route_map=${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_REDIST_KERNEL_ROUTE_MAP_NAME}    route_domain_id=${BGP_PRIMARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    Configure IPv4 Kernel Route BGP Redistribution    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    local_as_number=${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    route_map=${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_REDIST_KERNEL_ROUTE_MAP_NAME}    route_domain_id=${BGP_SECONDARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}
    Verify IPv4 Kernel Route BGP Redistribution    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    local_as_number=${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    route_map=${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_REDIST_KERNEL_ROUTE_MAP_NAME}    route_domain_id=${BGP_SECONDARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}

Redistribute IPv4 Connected Routes with Route-Map
    [Documentation]  Issues the 'redistribute connected route-map' command on the BIG-IP
    set log level  trace
    Configure IPv4 Connected Route BGP Redistribution    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    local_as_number=${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    route_map=${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_REDIST_CONNECTED_ROUTE_MAP_NAME}    route_domain_id=${BGP_PRIMARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}
    Verify IPv4 Connected Route BGP Redistribution    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    local_as_number=${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    route_map=${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_REDIST_CONNECTED_ROUTE_MAP_NAME}    route_domain_id=${BGP_PRIMARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    Configure IPv4 Connected Route BGP Redistribution    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    local_as_number=${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    route_map=${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_REDIST_CONNECTED_ROUTE_MAP_NAME}    route_domain_id=${BGP_SECONDARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}
    Verify IPv4 Connected Route BGP Redistribution    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    local_as_number=${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    route_map=${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_REDIST_CONNECTED_ROUTE_MAP_NAME}    route_domain_id=${BGP_SECONDARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}

Redistribute IPv4 Static Routes with Route-Map
    [Documentation]  Issues the 'redistribute static route-map' command on the BIG-IP
    set log level  trace
    Configure IPv4 Static Route BGP Redistribution    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    local_as_number=${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    route_map=${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_REDIST_STATIC_ROUTE_MAP_NAME}    route_domain_id=${BGP_PRIMARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}
    Verify IPv4 Static Route BGP Redistribution    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    local_as_number=${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    route_map=${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_REDIST_STATIC_ROUTE_MAP_NAME}    route_domain_id=${BGP_PRIMARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    Configure IPv4 Static Route BGP Redistribution    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    local_as_number=${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    route_map=${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_REDIST_STATIC_ROUTE_MAP_NAME}    route_domain_id=${BGP_SECONDARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}
    Verify IPv4 Static Route BGP Redistribution    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    local_as_number=${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    route_map=${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_REDIST_STATIC_ROUTE_MAP_NAME}    route_domain_id=${BGP_SECONDARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}

Create the IPv4 Neighbor Peer-Group
    [Documentation]  Creates an IPv4 Neighbor Peer-Group on the BIG-IP
    set log level  trace
    Create BGP IPv4 Neighbor Peer-Group    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    local_as_number=${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    peer_group_name=${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_NAME}    route_domain_id=${BGP_PRIMARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}
    Verify BGP IPv4 Neighbor Peer-Group    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    local_as_number=${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    peer_group_name=${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_NAME}    route_domain_id=${BGP_PRIMARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    Create BGP IPv4 Neighbor Peer-Group    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    local_as_number=${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    peer_group_name=${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_NAME}    route_domain_id=${BGP_SECONDARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}
    Verify BGP IPv4 Neighbor Peer-Group    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    local_as_number=${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    peer_group_name=${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_NAME}    route_domain_id=${BGP_SECONDARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}

Activate BGP IPv4 Neighbor
    [Documentation]  Activates the IPv4 neighbor on the BIG-IP
    set log level  trace
    Activate BGP IPv4 Neighbor    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    local_as_number=${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    neighbor=${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_NAME}    route_domain_id=${BGP_PRIMARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}
    Verify BGP IPv4 Neighbor Activation    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    local_as_number=${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    neighbor=${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_NAME}    route_domain_id=${BGP_PRIMARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'    
    Activate BGP IPv4 Neighbor    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    local_as_number=${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    neighbor=${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_NAME}    route_domain_id=${BGP_SECONDARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}
    Verify BGP IPv4 Neighbor Activation    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    local_as_number=${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    neighbor=${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_NAME}    route_domain_id=${BGP_SECONDARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}

Configure BGP IPv4 Neighbor Peer-Group Remote AS 
    [Documentation]  Configures the BGP peer-group's remote AS on the BIG-IP
    set log level  trace
    Configure BGP IPv4 Neighbor Remote AS    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    local_as_number=${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    neighbor=${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_NAME}    remote_as_number=${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_REMOTE_AS}    route_domain_id=${BGP_PRIMARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}
    Verify BGP IPv4 Neighbor Remote AS    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    local_as_number=${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    neighbor=${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_NAME}    remote_as_number=${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_REMOTE_AS}    route_domain_id=${BGP_PRIMARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    Configure BGP IPv4 Neighbor Remote AS    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    local_as_number=${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    neighbor=${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_NAME}    remote_as_number=${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_REMOTE_AS}    route_domain_id=${BGP_SECONDARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}
    Verify BGP IPv4 Neighbor Remote AS    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    local_as_number=${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    neighbor=${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_NAME}    remote_as_number=${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_REMOTE_AS}    route_domain_id=${BGP_SECONDARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}

Configure BGP IPv4 Neighbor Update Source
    [Documentation]  Configures the BGP update-source on the BIG-IP
    set log level  trace
    Configure BGP Neighbor Update Source    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    local_as_number=${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    neighbor=${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_NAME}    update_source=${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_UPDATE_SOURCE}    route_domain_id=${BGP_PRIMARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}
    Verify BGP Neighbor Update Source    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    local_as_number=${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    neighbor=${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_NAME}    update_source=${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_UPDATE_SOURCE}    route_domain_id=${BGP_PRIMARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    Configure BGP Neighbor Update Source    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    local_as_number=${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    neighbor=${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_NAME}    update_source=${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_UPDATE_SOURCE}    route_domain_id=${BGP_SECONDARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}
    Verify BGP Neighbor Update Source    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    local_as_number=${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    neighbor=${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_NAME}    update_source=${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_UPDATE_SOURCE}    route_domain_id=${BGP_SECONDARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}

Configure BGP IPv4 Neighbor Timers
    [Documentation]  Configures the BGP neighbor timers on the BIG-IP
    set log level  trace
    Configure BGP Neighbor Timers    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    local_as_number=${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    neighbor=${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_NAME}    keepalive_timer=${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_TIMERS_KEEPALIVE}    hold_timer=${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_TIMERS_HOLD}    route_domain_id=${BGP_PRIMARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}
    Verify BGP Neighbor Timers    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    local_as_number=${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    neighbor=${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_NAME}    keepalive_timer=${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_TIMERS_KEEPALIVE}    hold_timer=${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_TIMERS_HOLD}    route_domain_id=${BGP_PRIMARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'    
    Configure BGP Neighbor Timers    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    local_as_number=${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    neighbor=${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_NAME}    keepalive_timer=${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_TIMERS_KEEPALIVE}    hold_timer=${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_TIMERS_HOLD}    route_domain_id=${BGP_SECONDARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}
    Verify BGP Neighbor Timers    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    local_as_number=${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    neighbor=${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_NAME}    keepalive_timer=${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_TIMERS_KEEPALIVE}    hold_timer=${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_TIMERS_HOLD}    route_domain_id=${BGP_SECONDARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}

Enable BGP IPv4 Neighbor Soft Reconfiguration Inbound
    [Documentation]  Configures soft-reconfiguration inbound on the BIG-IP
    set log level  trace
    Enable BGP IPv4 Neighbor Soft Reconfiguration Inbound    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    local_as_number=${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    neighbor=${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_NAME}    route_domain_id=${BGP_PRIMARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}
    Verify Enable BGP IPv4 Neighbor Soft Reconfiguration Inbound    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    local_as_number=${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    neighbor=${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_NAME}    route_domain_id=${BGP_PRIMARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    Enable BGP IPv4 Neighbor Soft Reconfiguration Inbound    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    local_as_number=${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    neighbor=${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_NAME}    route_domain_id=${BGP_SECONDARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}
    Verify Enable BGP IPv4 Neighbor Soft Reconfiguration Inbound    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    local_as_number=${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    neighbor=${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_NAME}    route_domain_id=${BGP_SECONDARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}

Configure BGP IPv4 Neighbor Inbound Route-Map
    [Documentation]  Configures an inbound route-map on a BGP IPv4 neighbor on the BIG-IP
    set log level  trace
    Configure BGP IPv4 Neighbor Inbound Route-Map    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    local_as_number=${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    neighbor=${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_NAME}    route_map_name=${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_ROUTE_MAP_IN}    route_domain_id=${BGP_PRIMARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}    
    Verify BGP IPv4 Neighbor Inbound Route-Map    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    local_as_number=${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    neighbor=${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_NAME}    route_map_name=${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_ROUTE_MAP_IN}    route_domain_id=${BGP_PRIMARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}    
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    Configure BGP IPv4 Neighbor Inbound Route-Map    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    local_as_number=${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    neighbor=${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_NAME}    route_map_name=${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_ROUTE_MAP_IN}    route_domain_id=${BGP_SECONDARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}
    Verify BGP IPv4 Neighbor Inbound Route-Map    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    local_as_number=${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    neighbor=${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_NAME}    route_map_name=${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_ROUTE_MAP_IN}    route_domain_id=${BGP_SECONDARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}

Configure BGP IPv4 Neighbor Outbound Route-Map
    [Documentation]  Configures an outbound route-map on a BGP IPv4 neighbor on the BIG-IP
    set log level  trace
    Configure BGP IPv4 Neighbor Outbound Route-Map    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    local_as_number=${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    neighbor=${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_NAME}    route_map_name=${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_ROUTE_MAP_OUT}    route_domain_id=${BGP_PRIMARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID} 
    Verify BGP IPv4 Neighbor Outbound Route-Map    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    local_as_number=${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    neighbor=${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_NAME}    route_map_name=${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_ROUTE_MAP_OUT}    route_domain_id=${BGP_PRIMARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID} 
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    Configure BGP IPv4 Neighbor Outbound Route-Map    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    local_as_number=${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    neighbor=${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_NAME}    route_map_name=${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_ROUTE_MAP_OUT}    route_domain_id=${BGP_SECONDARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}
    Verify BGP IPv4 Neighbor Outbound Route-Map    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    local_as_number=${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    neighbor=${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_NAME}    route_map_name=${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_ROUTE_MAP_OUT}    route_domain_id=${BGP_SECONDARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}

Create the IPv6 Neighbor Peer-Group
    [Documentation]  Creates the IPv6 Neighbor Peer-Group on the BIG-IP
    set log level  trace
    Create BGP IPv6 Neighbor Peer-Group    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    local_as_number=${BGP_PRIMARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_LOCAL_AS}    peer_group_name=${BGP_PRIMARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_NAME}    route_domain_id=${BGP_PRIMARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}
    Verify BGP IPv6 Neighbor Peer-Group    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    local_as_number=${BGP_PRIMARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_LOCAL_AS}    peer_group_name=${BGP_PRIMARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_NAME}    route_domain_id=${BGP_PRIMARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    Create BGP IPv6 Neighbor Peer-Group    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    local_as_number=${BGP_SECONDARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_LOCAL_AS}    peer_group_name=${BGP_SECONDARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_NAME}    route_domain_id=${BGP_SECONDARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}
    Verify BGP IPv6 Neighbor Peer-Group    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    local_as_number=${BGP_SECONDARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_LOCAL_AS}    peer_group_name=${BGP_SECONDARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_NAME}    route_domain_id=${BGP_SECONDARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}

Configure BGP IPv6 Neighbor Peer-Group Remote AS 
    [Documentation]  Configures the IPv6 Neighbor Peer-Group Remote AS Number on the BIG-IP
    set log level  trace
    Create BGP IPv6 Neighbor Peer-Group Remote AS    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    local_as_number=${BGP_PRIMARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_LOCAL_AS}    peer_group_name=${BGP_PRIMARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_NAME}    remote_as_number=${BGP_PRIMARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_REMOTE_AS}    route_domain_id=${BGP_PRIMARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}
    Verify BGP IPv6 Neighbor Peer-Group Remote AS    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    local_as_number=${BGP_PRIMARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_LOCAL_AS}    peer_group_name=${BGP_PRIMARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_NAME}    remote_as_number=${BGP_PRIMARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_REMOTE_AS}    route_domain_id=${BGP_PRIMARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    Create BGP IPv6 Neighbor Peer-Group Remote AS    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    local_as_number=${BGP_SECONDARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_LOCAL_AS}    peer_group_name=${BGP_SECONDARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_NAME}    remote_as_number=${BGP_SECONDARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_REMOTE_AS}    route_domain_id=${BGP_SECONDARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}
    Verify BGP IPv6 Neighbor Peer-Group Remote AS    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    local_as_number=${BGP_SECONDARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_LOCAL_AS}    peer_group_name=${BGP_SECONDARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_NAME}    remote_as_number=${BGP_SECONDARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_REMOTE_AS}    route_domain_id=${BGP_SECONDARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}

Configure BGP IPv6 Neighbor Update Source
    [Documentation]  Defines an update source on the BIG-IP
    set log level  trace
    Configure BGP Neighbor Update Source    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    local_as_number=${BGP_PRIMARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_LOCAL_AS}    neighbor=${BGP_PRIMARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_NAME}    update_source=${BGP_PRIMARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_UPDATE_SOURCE}    route_domain_id=${BGP_PRIMARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}
    Verify BGP Neighbor Update Source    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    local_as_number=${BGP_PRIMARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_LOCAL_AS}    neighbor=${BGP_PRIMARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_NAME}    update_source=${BGP_PRIMARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_UPDATE_SOURCE}    route_domain_id=${BGP_PRIMARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    Configure BGP Neighbor Update Source    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    local_as_number=${BGP_SECONDARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_LOCAL_AS}    neighbor=${BGP_SECONDARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_NAME}    update_source=${BGP_SECONDARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_UPDATE_SOURCE}    route_domain_id=${BGP_SECONDARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}
    Verify BGP Neighbor Update Source    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    local_as_number=${BGP_SECONDARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_LOCAL_AS}    neighbor=${BGP_SECONDARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_NAME}    update_source=${BGP_SECONDARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_UPDATE_SOURCE}    route_domain_id=${BGP_SECONDARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}

Configure BGP IPv6 Neighbor Timers
    [Documentation]  Configures the BGP timers on an IPv6 neighbor on the BIG-IP
    set log level  trace
    Configure BGP Neighbor Timers    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    local_as_number=${BGP_PRIMARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_LOCAL_AS}    neighbor=${BGP_PRIMARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_NAME}    keepalive_timer=${BGP_PRIMARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_TIMERS_KEEPALIVE}    hold_timer=${BGP_PRIMARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_TIMERS_HOLD}    route_domain_id=${BGP_PRIMARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}
    Verify BGP Neighbor Timers    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    local_as_number=${BGP_PRIMARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_LOCAL_AS}    neighbor=${BGP_PRIMARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_NAME}    keepalive_timer=${BGP_PRIMARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_TIMERS_KEEPALIVE}    hold_timer=${BGP_PRIMARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_TIMERS_HOLD}    route_domain_id=${BGP_PRIMARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'    
    Configure BGP Neighbor Timers    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    local_as_number=${BGP_SECONDARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_LOCAL_AS}    neighbor=${BGP_SECONDARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_NAME}    keepalive_timer=${BGP_SECONDARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_TIMERS_KEEPALIVE}    hold_timer=${BGP_SECONDARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_TIMERS_HOLD}    route_domain_id=${BGP_SECONDARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}
    Verify BGP Neighbor Timers    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    local_as_number=${BGP_SECONDARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_LOCAL_AS}    neighbor=${BGP_SECONDARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_NAME}    keepalive_timer=${BGP_SECONDARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_TIMERS_KEEPALIVE}    hold_timer=${BGP_SECONDARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_TIMERS_HOLD}    route_domain_id=${BGP_SECONDARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}

Create the IPv4 Peers
    [Documentation]  Creates the IPv4 BGP Peers
    set log level  trace
    ${ipv4_peer_list}    convert string to json    ${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEERS})    json
    :FOR    ${current_neighbor}    IN    @{ipv4_peer_list}
    \    ${neighbor_host}    get from dictionary    ${current_neighbor}    neighbor
    \    ${neighbor_peer_group}    get from dictionary    ${current_neighbor}    peer-group
    \    ${neighbor_description}    get from dictionary    ${current_neighbor}    description
    \    Create BGP IPv4 Neighbor using Peer-Group    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    local_as_number=${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    route_domain_id=${BGP_PRIMARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}    bgp_peer_ip=${neighbor_host}    peer_group_name=${neighbor_peer_group}    route_domain_id=${BGP_PRIMARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}
    \    Verify BGP IPv4 Neighbor using Peer-Group    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    local_as_number=${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    route_domain_id=${BGP_PRIMARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}    bgp_peer_ip=${neighbor_host}    peer_group_name=${neighbor_peer_group}    route_domain_id=${BGP_PRIMARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}
    \    Activate BGP IPv4 Neighbor    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    local_as_number=${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    route_domain_id=${BGP_PRIMARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}    neighbor=${neighbor_host}
    \    Verify BGP IPv4 Neighbor Activation   bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    local_as_number=${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    route_domain_id=${BGP_PRIMARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}    neighbor=${neighbor_host}
    \    Configure BGP Neighbor Description    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    local_as_number=${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    route_domain_id=${BGP_PRIMARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}    neighbor=${neighbor_host}    description=${neighbor_description}    
    \    Verify BGP Neighbor Description    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    local_as_number=${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    route_domain_id=${BGP_PRIMARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}    neighbor=${neighbor_host}    description=${neighbor_description}    
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    ${ipv4_peer_list}    convert string to json    ${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEERS})    json
    :FOR    ${current_neighbor}    IN    @{ipv4_peer_list}
    \    ${neighbor_host}    get from dictionary    ${current_neighbor}    neighbor
    \    ${neighbor_peer_group}    get from dictionary    ${current_neighbor}    peer-group
    \    ${neighbor_description}    get from dictionary    ${current_neighbor}    description
    \    Create BGP IPv4 Neighbor using Peer-Group    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    local_as_number=${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    route_domain_id=${BGP_SECONDARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}    bgp_peer_ip=${neighbor_host}    peer_group_name=${neighbor_peer_group}    route_domain_id=${BGP_SECONDARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}
    \    Verify BGP IPv4 Neighbor using Peer-Group    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    local_as_number=${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    route_domain_id=${BGP_SECONDARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}    bgp_peer_ip=${neighbor_host}    peer_group_name=${neighbor_peer_group}    route_domain_id=${BGP_SECONDARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}
    \    Activate BGP IPv4 Neighbor    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    local_as_number=${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    route_domain_id=${BGP_SECONDARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}    neighbor=${neighbor_host}
    \    Verify BGP IPv4 Neighbor Activation    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    local_as_number=${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    route_domain_id=${BGP_SECONDARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}    neighbor=${neighbor_host}
    \    Configure BGP Neighbor Description    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    local_as_number=${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    route_domain_id=${BGP_SECONDARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}    neighbor=${neighbor_host}    description=${neighbor_description}    
    \    Verify BGP Neighbor Description    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    local_as_number=${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    route_domain_id=${BGP_SECONDARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}    neighbor=${neighbor_host}    description=${neighbor_description}    
    
Redistribute IPv6 Kernel Routes with Route-Map
    [Documentation]  Issues the 'redistribute kernel route-map' command in the ipv6 address-family 
    set log level  trace
    Configure IPv6 Kernel Route BGP Redistribution        bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    local_as_number=${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    route_domain_id=${BGP_PRIMARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}    route_map=${BGP_PRIMARY_SINGLE_CONTEXT_IPv6_REDIST_KERNEL_ROUTE_MAP_NAME}    
    Verify IPv6 Kernel Route BGP Redistribution        bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    local_as_number=${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    route_domain_id=${BGP_PRIMARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}    route_map=${BGP_PRIMARY_SINGLE_CONTEXT_IPv6_REDIST_KERNEL_ROUTE_MAP_NAME}    
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    Configure IPv6 Kernel Route BGP Redistribution        bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    local_as_number=${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    route_domain_id=${BGP_SECONDARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}    route_map=${BGP_SECONDARY_SINGLE_CONTEXT_IPv6_REDIST_KERNEL_ROUTE_MAP_NAME}    
    Verify IPv6 Kernel Route BGP Redistribution        bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    local_as_number=${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    route_domain_id=${BGP_SECONDARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}    route_map=${BGP_SECONDARY_SINGLE_CONTEXT_IPv6_REDIST_KERNEL_ROUTE_MAP_NAME}    

Redistribute IPv6 Connected Routes with Route-Map
    [Documentation]  Issues the 'redistribute connected route-map' command in the ipv6 address-family
    set log level  trace
    Configure IPv6 Connected Route BGP Redistribution        bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    local_as_number=${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    route_domain_id=${BGP_PRIMARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}    route_map=${BGP_PRIMARY_SINGLE_CONTEXT_IPv6_REDIST_CONNECTED_ROUTE_MAP_NAME}    
    Verify IPv6 Connected Route BGP Redistribution        bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    local_as_number=${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    route_domain_id=${BGP_PRIMARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}    route_map=${BGP_PRIMARY_SINGLE_CONTEXT_IPv6_REDIST_CONNECTED_ROUTE_MAP_NAME}    
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    Configure IPv6 Connected Route BGP Redistribution        bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    local_as_number=${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    route_domain_id=${BGP_SECONDARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}    route_map=${BGP_SECONDARY_SINGLE_CONTEXT_IPv6_REDIST_CONNECTED_ROUTE_MAP_NAME}    
    Verify IPv6 Connected Route BGP Redistribution        bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    local_as_number=${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    route_domain_id=${BGP_SECONDARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}    route_map=${BGP_SECONDARY_SINGLE_CONTEXT_IPv6_REDIST_CONNECTED_ROUTE_MAP_NAME}    

Redistribute IPv6 Static Routes with Route-Map
    [Documentation]  Issues the 'redistribute static route-map' command in the ipv6 address-family
    set log level  trace
    Configure IPv6 Static Route BGP Redistribution        bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    local_as_number=${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    route_domain_id=${BGP_PRIMARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}    route_map=${BGP_PRIMARY_SINGLE_CONTEXT_IPv6_REDIST_STATIC_ROUTE_MAP_NAME}    
    Verify IPv6 Static Route BGP Redistribution        bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    local_as_number=${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    route_domain_id=${BGP_PRIMARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}    route_map=${BGP_PRIMARY_SINGLE_CONTEXT_IPv6_REDIST_STATIC_ROUTE_MAP_NAME}    
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    Configure IPv6 Static Route BGP Redistribution        bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    local_as_number=${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    route_domain_id=${BGP_SECONDARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}    route_map=${BGP_SECONDARY_SINGLE_CONTEXT_IPv6_REDIST_STATIC_ROUTE_MAP_NAME}    
    Verify IPv6 Static Route BGP Redistribution        bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    local_as_number=${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    route_domain_id=${BGP_SECONDARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}    route_map=${BGP_SECONDARY_SINGLE_CONTEXT_IPv6_REDIST_STATIC_ROUTE_MAP_NAME}    

Activate the IPv6 Neighbor Peer-Group
    [Documentation]  Issues the 'neighbor activate command' command for the IPv6 Peer-group in the ipv6 address-family
    set log level  trace
    Activate BGP IPv6 Neighbor    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    local_as_number=${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    neighbor=${BGP_PRIMARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_NAME}    route_domain_id=${BGP_PRIMARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}    
    Verify BGP IPv6 Neighbor Activation    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    local_as_number=${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    neighbor=${BGP_PRIMARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_NAME}    route_domain_id=${BGP_PRIMARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}    
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    Activate BGP IPv6 Neighbor    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    local_as_number=${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    neighbor=${BGP_PRIMARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_NAME}    route_domain_id=${BGP_SECONDARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}    
    Verify BGP IPv6 Neighbor Activation    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    local_as_number=${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    neighbor=${BGP_PRIMARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_NAME}    route_domain_id=${BGP_SECONDARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}    

Enable IPv6 Neighbor Peer-Group Soft Reconfiguration Inbound
    [Documentation]  Issues the 'peer-group xxxxxx soft-reconfiguration inbound' command in the ipv6 address-family
    set log level  trace
    Enable BGP IPv6 Neighbor Soft Reconfiguration Inbound    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    local_as_number=${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    route_domain_id=${BGP_PRIMARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}    neighbor=${BGP_PRIMARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_NAME} 
    Verify Enable BGP IPv6 Neighbor Soft Reconfiguration Inbound    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    local_as_number=${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    route_domain_id=${BGP_PRIMARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}    neighbor=${BGP_PRIMARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_NAME} 
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    Enable BGP IPv6 Neighbor Soft Reconfiguration Inbound    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    local_as_number=${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    route_domain_id=${BGP_SECONDARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}    neighbor=${BGP_SECONDARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_NAME} 
    Verify Enable BGP IPv6 Neighbor Soft Reconfiguration Inbound    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    local_as_number=${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    route_domain_id=${BGP_SECONDARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}    neighbor=${BGP_SECONDARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_NAME} 

Disable the IPv6 Neighbor Peer-Group Graceful Restart
    [Documentation]  Issues the 'no peer-group xxxxxxx capability graceful-restart' command in the ipv6 address-family
    set log level  trace
    Disable the Graceful Restart BGP IPv6 Neighbor Capability    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    local_as_number=${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    neighbor=${BGP_PRIMARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_NAME}    route_domain_id=${BGP_PRIMARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}
    Verify Disable the Graceful Restart BGP IPv6 Neighbor Capability    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    local_as_number=${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    neighbor=${BGP_PRIMARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_NAME}    route_domain_id=${BGP_PRIMARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    Disable the Graceful Restart BGP IPv6 Neighbor Capability    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    local_as_number=${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    neighbor=${BGP_SECONDARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_NAME}    route_domain_id=${BGP_SECONDARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}
    Verify Disable the Graceful Restart BGP IPv6 Neighbor Capability    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    local_as_number=${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    neighbor=${BGP_SECONDARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_NAME}    route_domain_id=${BGP_SECONDARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}

Apply the Inbound IPv6 Route-Map to the Neighbor Peer-Group
    [Documentation]  Issues the 'neighbor x::x route-map yyyyyy in' command in the ipv6 address-family
    set log level  trace
    Configure IPv6 BGP Neighbor Route-Map    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    local_as_number=${BGP_PRIMARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_LOCAL_AS}    neighbor=${BGP_PRIMARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_NAME}    route_map_name=${BGP_PRIMARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_ROUTE_MAP_IN}    route_map_direction=in    route_domain_id=${BGP_PRIMARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}
    Verify IPv6 BGP Neighbor Route-Map    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    local_as_number=${BGP_PRIMARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_LOCAL_AS}    neighbor=${BGP_PRIMARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_NAME}    route_map_name=${BGP_PRIMARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_ROUTE_MAP_IN}    route_map_direction=in    route_domain_id=${BGP_PRIMARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    Configure IPv6 BGP Neighbor Route-Map    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    local_as_number=${BGP_SECONDARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_LOCAL_AS}    neighbor=${BGP_SECONDARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_NAME}    route_map_name=${BGP_SECONDARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_ROUTE_MAP_IN}    route_map_direction=in    route_domain_id=${BGP_SECONDARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}
    Verify IPv6 BGP Neighbor Route-Map    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    local_as_number=${BGP_SECONDARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_LOCAL_AS}    neighbor=${BGP_SECONDARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_NAME}    route_map_name=${BGP_SECONDARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_ROUTE_MAP_IN}    route_map_direction=in    route_domain_id=${BGP_SECONDARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}

Create the IPv6 Peers
    [Documentation]  Creates the IPv6 BGP Peers and activates the neighbor on the BIG-IP
    set log level  trace
    ${ipv6_peer_list}    convert string to json    ${BGP_PRIMARY_SINGLE_CONTEXT_IPv6_PEERS})    json
    :FOR    ${current_neighbor}    IN    @{ipv6_peer_list}
    \    ${neighbor_host}    get from dictionary    ${current_neighbor}    neighbor
    \    ${neighbor_peer_group}    get from dictionary    ${current_neighbor}    peer-group
    \    ${neighbor_description}    get from dictionary    ${current_neighbor}    description
    \    Create BGP IPv6 Neighbor using Peer-Group    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    local_as_number=${BGP_PRIMARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_LOCAL_AS}    bgp_peer_ip=${neighbor_host}    peer_group_name=${neighbor_peer_group}    route_domain_id=${BGP_PRIMARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}
    \    Verify BGP IPv6 Neighbor using Peer-Group    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    local_as_number=${BGP_PRIMARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_LOCAL_AS}    bgp_peer_ip=${neighbor_host}    peer_group_name=${neighbor_peer_group}    route_domain_id=${BGP_PRIMARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}
    \    Activate BGP IPv6 Neighbor    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    local_as_number=${BGP_PRIMARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_LOCAL_AS}    neighbor=${neighbor_host}    route_domain_id=${BGP_PRIMARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}
    \    Verify BGP IPv6 Neighbor Activation    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    local_as_number=${BGP_PRIMARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_LOCAL_AS}    neighbor=${neighbor_host}    route_domain_id=${BGP_PRIMARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}
    \    Configure BGP Neighbor Description    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    local_as_number=${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    neighbor=${neighbor_host}    description=${neighbor_description}    route_domain_id=${BGP_PRIMARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}    
    \    Verify BGP Neighbor Description    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    local_as_number=${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    neighbor=${neighbor_host}    description=${neighbor_description}    route_domain_id=${BGP_PRIMARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}    
    \    Disable the Graceful Restart BGP IPv6 Neighbor Capability    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    local_as_number=${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    neighbor=${neighbor_host}    route_domain_id=${BGP_PRIMARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}
    \    Verify Disable the Graceful Restart BGP IPv6 Neighbor Capability    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    local_as_number=${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    neighbor=${neighbor_host}    route_domain_id=${BGP_PRIMARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    ${ipv6_peer_list}    convert string to json    ${BGP_SECONDARY_SINGLE_CONTEXT_IPv6_PEERS})    json
    :FOR    ${current_neighbor}    IN    @{ipv6_peer_list}
    \    ${neighbor_host}    get from dictionary    ${current_neighbor}    neighbor
    \    ${neighbor_peer_group}    get from dictionary    ${current_neighbor}    peer-group
    \    ${neighbor_description}    get from dictionary    ${current_neighbor}    description
    \    Create BGP IPv6 Neighbor using Peer-Group    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    local_as_number=${BGP_SECONDARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_LOCAL_AS}    bgp_peer_ip=${neighbor_host}    peer_group_name=${neighbor_peer_group}    route_domain_id=${BGP_SECONDARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}
    \    Verify BGP IPv6 Neighbor using Peer-Group    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    local_as_number=${BGP_SECONDARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_LOCAL_AS}    bgp_peer_ip=${neighbor_host}    peer_group_name=${neighbor_peer_group}    route_domain_id=${BGP_SECONDARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}
    \    Activate BGP IPv6 Neighbor    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    local_as_number=${BGP_SECONDARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_LOCAL_AS}    route_domain_id=${BGP_SECONDARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}    neighbor=${neighbor_host}
    \    Verify BGP IPv6 Neighbor Activation    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    local_as_number=${BGP_SECONDARY_SINGLE_CONTEXT_IPv6_PEER_GROUP_LOCAL_AS}    route_domain_id=${BGP_SECONDARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}    neighbor=${neighbor_host}
    \    Configure BGP Neighbor Description    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    local_as_number=${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    route_domain_id=${BGP_SECONDARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}    neighbor=${neighbor_host}    description=${neighbor_description}    
    \    Verify BGP Neighbor Description    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    local_as_number=${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    route_domain_id=${BGP_SECONDARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}    neighbor=${neighbor_host}    description=${neighbor_description}    
    \    Disable the Graceful Restart BGP IPv6 Neighbor Capability    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    local_as_number=${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    neighbor=${neighbor_host}    route_domain_id=${BGP_SECONDARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}
    \    Verify Disable the Graceful Restart BGP IPv6 Neighbor Capability    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    local_as_number=${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    neighbor=${neighbor_host}    route_domain_id=${BGP_SECONDARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}

Create ZebOS Global Static Routes
    # ip route 44.51.0.0/24 Null
    [Documentation]  Creates a static route in the ZebOS routing daemon using the 'ip route' command on the BIG-IP
    set log level  trace
    ${zebos_static_routes_list}    convert string to json    ${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_STATIC_ROUTES})
    :FOR    ${current_route}    IN    @{zebos_static_routes_list}
    \    ${network}    get from dictionary    ${current_route}    network
    \    ${gateway}    get from dictionary    ${current_route}    gateway
    \    Create ZebOS Static Route on the BIG-IP    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    network=${network}    gateway=${gateway}    route_domain_id=${BGP_PRIMARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}
    \    Verify ZebOS Static Route on the BIG-IP    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    network=${network}    gateway=${gateway}    route_domain_id=${BGP_PRIMARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    ${zebos_static_routes_list}    convert string to json    ${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_STATIC_ROUTES})
    :FOR    ${current_route}    IN    @{zebos_static_routes_list}
    \    ${network}    get from dictionary    ${current_route}    network
    \    ${gateway}    get from dictionary    ${current_route}    gateway
    \    Create ZebOS Static Route on the BIG-IP    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    network=${network}    gateway=${gateway}    route_domain_id=${BGP_SECONDARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}
    \    Verify ZebOS Static Route on the BIG-IP    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    network=${network}    gateway=${gateway}    route_domain_id=${BGP_SECONDARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}
     
Create the IPv4 Prefix Lists
    [Documentation]  Creates a BGP IPv4 prefix-list using the 'ip prefix-list' command on the BIG-IP
    set log level  trace
    ${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PREFIX_LISTS}    convert string to json    ${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PREFIX_LISTS})
    :FOR    ${current_prefix_list}    IN    @{BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PREFIX_LISTS}
    \    ${name}    get from dictionary    ${current_prefix_list}    name
    \    ${entries}    get from dictionary    ${current_prefix_list}    entries
    \    Create IPv4 Prefix List    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    prefix_list_name=${name}    entries_list=${entries}    route_domain_id=${BGP_PRIMARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}
    \    Verify IPv4 Prefix List    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    prefix_list_name=${name}    entries_list=${entries}    route_domain_id=${BGP_PRIMARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    ${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PREFIX_LISTS}    convert string to json    ${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PREFIX_LISTS})
    :FOR    ${current_prefix_list}    IN    @{BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PREFIX_LISTS}
    \    ${name}    get from dictionary    ${current_prefix_list}    name
    \    ${entries}    get from dictionary    ${current_prefix_list}    entries
    \    Create IPv4 Prefix List    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    prefix_list_name=${name}    entries_list=${entries}    route_domain_id=${BGP_SECONDARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}
    \    Verify IPv4 Prefix List    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    prefix_list_name=${name}    entries_list=${entries}    route_domain_id=${BGP_SECONDARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}

Create the IPv6 Prefix Lists
    [Documentation]  Creates a BGP IPv6 prefix-list using the 'ipv6 prefix-list' command on the BIG-IP
    set log level  trace
    ${BGP_PRIMARY_SINGLE_CONTEXT_IPv6_PREFIX_LISTS}    to json    ${BGP_PRIMARY_SINGLE_CONTEXT_IPv6_PREFIX_LISTS}
    :FOR    ${current_prefix_list}    IN    @{BGP_PRIMARY_SINGLE_CONTEXT_IPv6_PREFIX_LISTS}
    \    ${name}    get from dictionary    ${current_prefix_list}    name
    \    ${entries}    get from dictionary    ${current_prefix_list}    entries
    \    Create IPv6 Prefix List    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    prefix_list_name=${name}    entries_list=${entries}    route_domain_id=${BGP_PRIMARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}
    \    Verify IPv6 Prefix List    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    prefix_list_name=${name}    entries_list=${entries}    route_domain_id=${BGP_PRIMARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    ${BGP_SECONDARY_SINGLE_CONTEXT_IPv6_PREFIX_LISTS}    to json    ${BGP_SECONDARY_SINGLE_CONTEXT_IPv6_PREFIX_LISTS}
    :FOR    ${current_prefix_list}    IN    @{BGP_SECONDARY_SINGLE_CONTEXT_IPv6_PREFIX_LISTS}
    \    ${name}    get from dictionary    ${current_prefix_list}    name
    \    ${entries}    get from dictionary    ${current_prefix_list}    entries
    \    Create IPv6 Prefix List    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    prefix_list_name=${name}    entries_list=${entries}    route_domain_id=${BGP_SECONDARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}
    \    Verify IPv6 Prefix List    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    prefix_list_name=${name}    entries_list=${entries}    route_domain_id=${BGP_SECONDARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}

Create the Route Maps
    [Documentation]  Creates a BGP route map using the 'route-map' command on the BIG-IP
    set log level  trace
    ${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_ROUTE_MAPS}    to json    ${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_ROUTE_MAPS}
    :FOR    ${current_route_map}    IN    @{BGP_PRIMARY_SINGLE_CONTEXT_IPv4_ROUTE_MAPS}
    \    ${route_map_name}    get from dictionary    ${current_route_map}    name
    \    ${route_map_entries_dict}    get from dictionary    ${current_route_map}    entries
    \    Create ZebOS Route-Map    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    route_map_name=${route_map_name}    route_map_entries_dictionary=${route_map_entries_dict}    route_domain_id=${BGP_PRIMARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}
    \    Verify ZebOS Route-Map    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    route_map_name=${route_map_name}    route_map_entries_dictionary=${route_map_entries_dict}    route_domain_id=${BGP_PRIMARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    ${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_ROUTE_MAPS}    to json    ${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_ROUTE_MAPS}
    :FOR    ${current_route_map}    IN    @{BGP_SECONDARY_SINGLE_CONTEXT_IPv4_ROUTE_MAPS}
    \    ${route_map_name}    get from dictionary    ${current_route_map}    name
    \    ${route_map_entries_dict}    get from dictionary    ${current_route_map}    entries
    \    Create ZebOS Route-Map   bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    route_map_name=${route_map_name}    route_map_entries_dictionary=${route_map_entries_dict}    route_domain_id=${BGP_SECONDARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}
    \    Verify ZebOS Route-Map   bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    route_map_name=${route_map_name}    route_map_entries_dictionary=${route_map_entries_dict}    route_domain_id=${BGP_SECONDARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}

Sleep to allow BGP to establish and stabilize
    [Documentation]  Sleep for 60 seconds to allow BGP to converge after configuration changes
    set log level  trace
    sleep    60s    reason=Giving BGP peers time to exchange info

Verify BGP Established Peer Connections
    [Documentation]  Verifies that the IPv6 neighbors are in an 'established' state using the 'show bgp ipv6 neighbors x::x" command
    set log level  trace
    ${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEERS}    to json    ${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEERS}
    :FOR    ${current_bgp_peer}    IN    @{BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEERS}
    \    ${current_peer_address}    get from dictionary    ${current_bgp_peer}    neighbor
    \    ${primary_ipv4_peer_state}    Retrieve BGP State for Peer    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    route_domain_id=${BGP_PRIMARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}   peer_address=${current_peer_address}
    \    should be equal as strings    ${primary_ipv4_peer_state}    Established
    ${BGP_PRIMARY_SINGLE_CONTEXT_IPv6_PEERS}    to json    ${BGP_PRIMARY_SINGLE_CONTEXT_IPv6_PEERS}
    :FOR    ${current_bgp_peer}    IN    @{BGP_PRIMARY_SINGLE_CONTEXT_IPv6_PEERS}
    \    ${current_peer_address}    get from dictionary    ${current_bgp_peer}    neighbor
    \    ${primary_ipv6_peer_state}    Retrieve BGP State for Peer    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    route_domain_id=${BGP_PRIMARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}   peer_address=${current_peer_address}
    \    should be equal as strings    ${primary_ipv6_peer_state}    Established
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    ${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEERS}    to json    ${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEERS}
    :FOR    ${current_bgp_peer}    IN    @{BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEERS}
    \    ${current_peer_address}    get from dictionary    ${current_bgp_peer}    neighbor
    \    ${primary_ipv4_peer_state}    Retrieve BGP State for Peer    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    route_domain_id=${BGP_SECONDARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}   peer_address=${current_peer_address}
    \    should be equal as strings    ${primary_ipv4_peer_state}    Established
    ${BGP_SECONDARY_SINGLE_CONTEXT_IPv6_PEERS}    to json    ${BGP_SECONDARY_SINGLE_CONTEXT_IPv6_PEERS}
    :FOR    ${current_bgp_peer}    IN    @{BGP_SECONDARY_SINGLE_CONTEXT_IPv6_PEERS}
    \    ${current_peer_address}    get from dictionary    ${current_bgp_peer}    neighbor
    \    ${primary_ipv6_peer_state}    Retrieve BGP State for Peer    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    route_domain_id=${BGP_SECONDARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}   peer_address=${current_peer_address}
    \    should be equal as strings    ${primary_ipv6_peer_state}    Established

Verify BGP Advertised IPv4 Routes
    [Documentation]  Verifies that the BIG-IP is advertising the expected IPv4 routes
    set log level  trace
    ${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEERS}    to json    ${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEERS}
    :FOR    ${current_bgp_peer}    IN    @{BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEERS}
    \    ${current_peer_address}    get from dictionary    ${current_bgp_peer}    neighbor
    \    ${expected_ipv4_advertised_routes}    get from dictionary    ${current_bgp_peer}    expected_advertised_routes    
    \    ${primary_ipv4_advertised_routes}    Retrieve BGP Peer Advertised IPv4 Routes in CIDR Format    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    route_domain_id=${BGP_PRIMARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}   peer_address=${current_peer_address}
    \    list should contain sub list    ${primary_ipv4_advertised_routes}    ${expected_ipv4_advertised_routes}
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    ${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEERS}    to json    ${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEERS}
    :FOR    ${current_bgp_peer}    IN    @{BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEERS}
    \    ${current_peer_address}    get from dictionary    ${current_bgp_peer}    neighbor
    \    ${primary_ipv4_advertised_routes}    Retrieve BGP Peer Advertised IPv4 Routes in CIDR Format    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    route_domain_id=${BGP_PRIMARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}   peer_address=${current_peer_address}    
    \    ${expected_ipv4_advertised_routes}    get from dictionary    ${current_bgp_peer}    expected_advertised_routes    
    \    list should contain sub list    ${primary_ipv4_advertised_routes}    ${expected_ipv4_advertised_routes}

Verify BGP Advertised IPv6 Routes
    [Documentation]  Verifies that the BIG-IP is advertising the expected IPv6 routes
    set log level  trace
    ${BGP_PRIMARY_SINGLE_CONTEXT_IPv6_PEERS}    to json    ${BGP_PRIMARY_SINGLE_CONTEXT_IPv6_PEERS}
    :FOR    ${current_bgp_peer}    IN    @{BGP_PRIMARY_SINGLE_CONTEXT_IPv6_PEERS}
    \    ${current_peer_address}    get from dictionary    ${current_bgp_peer}    neighbor
    \    ${expected_ipv6_advertised_routes}    get from dictionary    ${current_bgp_peer}    expected_advertised_routes    
    \    ${primary_ipv6_advertised_routes}    Retrieve BGP Peer Advertised IPv6 Routes    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    route_domain_id=${BGP_PRIMARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}   peer_address=${current_peer_address}
    \    list should contain sub list    ${primary_ipv6_advertised_routes}    ${expected_ipv6_advertised_routes}
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    ${BGP_SECONDARY_SINGLE_CONTEXT_IPv6_PEERS}    to json    ${BGP_SECONDARY_SINGLE_CONTEXT_IPv6_PEERS}
    :FOR    ${current_bgp_peer}    IN    @{BGP_SECONDARY_SINGLE_CONTEXT_IPv6_PEERS}
    \    ${current_peer_address}    get from dictionary    ${current_bgp_peer}    neighbor
    \    ${primary_ipv6_advertised_routes}    Retrieve BGP Peer Advertised IPv6 Routes    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    route_domain_id=${BGP_PRIMARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}   peer_address=${current_peer_address}    
    \    ${expected_ipv6_advertised_routes}    get from dictionary    ${current_bgp_peer}    expected_advertised_routes    
    \    list should contain sub list    ${primary_ipv6_advertised_routes}    ${expected_ipv6_advertised_routes}

Verify BGP Upstream Received IPv4 Routes
    [Documentation]  Verifies that the upstream device (Nexus) is receiving the BGP routes
    set log level  trace
    ${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEERS}    to json    ${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEERS}
    :FOR    ${current_bgp_peer}    IN    @{BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEERS}
    \    ${peer_expected_advertised_routes}    get from dictionary    ${current_bgp_peer}    expected_advertised_routes
    \    ${peer_management_ip}    get from dictionary    ${current_bgp_peer}    device_management_ip
    \    ${peer_device_username}    get from dictionary    ${current_bgp_peer}    device_username
    \    ${peer_device_password}    get from dictionary    ${current_bgp_peer}    device_password
    \    ${peer_remote_peer_ip}    get from dictionary    ${current_bgp_peer}    local_peering_ip
    \    ${peer_vrf}    get from dictionary    ${current_bgp_peer}    peer_vrf
    \    ${peer_vdc}    get from dictionary    ${current_bgp_peer}    peer_vdc
    \    ${ipv4_received_routes}    Get IPv4 Received Routes from Nexus Router    host=${peer_management_ip}    username=${peer_device_username}    password=${peer_device_password}    remote_bgp_peer_ip=${peer_remote_peer_ip}    remote_vrf=${peer_vrf}    peer_vdc=${peer_vdc}
    \    ${expected_ipv4_advertised_routes}    get from dictionary    ${current_bgp_peer}    expected_advertised_routes    
    \    list should contain sub list    ${ipv4_received_routes}    ${expected_ipv4_advertised_routes}
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    ${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEERS}    to json    ${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEERS}
    :FOR    ${current_bgp_peer}    IN    @{BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEERS}
    \    ${peer_expected_advertised_routes}    get from dictionary    ${current_bgp_peer}    expected_advertised_routes
    \    ${peer_management_ip}    get from dictionary    ${current_bgp_peer}    device_management_ip
    \    ${peer_device_username}    get from dictionary    ${current_bgp_peer}    device_username
    \    ${peer_device_password}    get from dictionary    ${current_bgp_peer}    device_password
    \    ${peer_remote_peer_ip}    get from dictionary    ${current_bgp_peer}    local_peering_ip
    \    ${peer_vrf}    get from dictionary    ${current_bgp_peer}    peer_vrf
    \    ${peer_vdc}    get from dictionary    ${current_bgp_peer}    peer_vdc
    \    ${ipv4_received_routes}    Get IPv4 Received Routes from Nexus Router    host=${peer_management_ip}    username=${peer_device_username}    password=${peer_device_password}    remote_bgp_peer_ip=${peer_remote_peer_ip}    remote_vrf=${peer_vrf}    peer_vdc=${peer_vdc}    
    \    ${expected_ipv4_advertised_routes}    get from dictionary    ${current_bgp_peer}    expected_advertised_routes    
    \    list should contain sub list    ${ipv4_received_routes}    ${expected_ipv4_advertised_routes}

Verify BGP Upstream Received IPv6 Routes
    [Documentation]  Verifies that the upstream device (Nexus) is receiving the expected BGP routes
    set log level  trace
    ${BGP_PRIMARY_SINGLE_CONTEXT_IPv6_PEERS}    to json    ${BGP_PRIMARY_SINGLE_CONTEXT_IPv6_PEERS}
    :FOR    ${current_bgp_peer}    IN    @{BGP_PRIMARY_SINGLE_CONTEXT_IPv6_PEERS}
    \    ${peer_expected_advertised_routes}    get from dictionary    ${current_bgp_peer}    expected_advertised_routes
    \    ${peer_management_ip}    get from dictionary    ${current_bgp_peer}    device_management_ip
    \    ${peer_device_username}    get from dictionary    ${current_bgp_peer}    device_username
    \    ${peer_device_password}    get from dictionary    ${current_bgp_peer}    device_password
    \    ${peer_remote_peer_ip}    get from dictionary    ${current_bgp_peer}    local_peering_ip
    \    ${peer_vrf}    get from dictionary    ${current_bgp_peer}    peer_vrf
    \    ${peer_vdc}    get from dictionary    ${current_bgp_peer}    peer_vdc
    \    ${ipv6_received_routes}    Get IPv6 Received Routes from Nexus Router    host=${peer_management_ip}    username=${peer_device_username}    password=${peer_device_password}    remote_bgp_peer_ip=${peer_remote_peer_ip}    remote_vrf=${peer_vrf}    peer_vdc=${peer_vdc}    
    \    ${expected_ipv6_advertised_routes}    get from dictionary    ${current_bgp_peer}    expected_advertised_routes    
    \    list should contain sub list    ${ipv6_received_routes}    ${expected_ipv6_advertised_routes}
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    ${BGP_SECONDARY_SINGLE_CONTEXT_IPv6_PEERS}    to json    ${BGP_SECONDARY_SINGLE_CONTEXT_IPv6_PEERS}
    :FOR    ${current_bgp_peer}    IN    @{BGP_SECONDARY_SINGLE_CONTEXT_IPv6_PEERS}
    \    ${peer_expected_advertised_routes}    get from dictionary    ${current_bgp_peer}    expected_advertised_routes
    \    ${peer_management_ip}    get from dictionary    ${current_bgp_peer}    device_management_ip
    \    ${peer_device_username}    get from dictionary    ${current_bgp_peer}    device_username
    \    ${peer_device_password}    get from dictionary    ${current_bgp_peer}    device_password
    \    ${peer_remote_peer_ip}    get from dictionary    ${current_bgp_peer}    local_peering_ip
    \    ${peer_vrf}    get from dictionary    ${current_bgp_peer}    peer_vrf
    \    ${peer_vdc}    get from dictionary    ${current_bgp_peer}    peer_vdc
    \    ${ipv6_received_routes}    Get IPv6 Received Routes from Nexus Router    host=${peer_management_ip}    username=${peer_device_username}    password=${peer_device_password}    remote_bgp_peer_ip=${peer_remote_peer_ip}    remote_vrf=${peer_vrf}    peer_vdc=${peer_vdc}    
    \    ${expected_ipv6_advertised_routes}    get from dictionary    ${current_bgp_peer}    expected_advertised_routes    
    \    list should contain sub list    ${ipv6_received_routes}    ${expected_ipv6_advertised_routes}

Log BGP Information
    [Documentation]  Logs the current status of the route domain's BGP sessions
    set log level  trace
    ${bgp_status_primary}    Show Route Domain BGP Status   bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    route_domain_id=${BGP_PRIMARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}
    log    ${bgp_status_primary}
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    ${bgp_status_secondary}    Show Route Domain BGP Status   bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    route_domain_id=${BGP_SECONDARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}
    log    ${bgp_status_secondary}
    
Show Route Domain BGP Configuration
    [Documentation]  Records the full ZebOS routing daemon configuration
    set log level  trace
    ${bgp_configuration}    Show Route Domain ZebOS Configuration    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    route_domain_id=${BGP_PRIMARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}
    ${bgp_configuration_text}    get from dictionary    ${bgp_configuration.json}    commandResult
    log    ${bgp_configuration_text}
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    ${bgp_configuration}    Show Route Domain ZebOS Configuration    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    route_domain_id=${BGP_SECONDARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}
    ${bgp_configuration_text}    get from dictionary    ${bgp_configuration.json}    commandResult
    log    ${bgp_configuration_text}

Show AS Configuration Sections
    [Documentation]  Records the BGP configurations for the current AS
    set log level  trace
    ${bgp_full_as_config}    Retrieve BGP AS Configuration    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    local_as_number=${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    route_domain_id=${BGP_PRIMARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}
    log    \n**** BGP Full AS Config:\n${bgp_full_as_config}
    ${bgp_global_as_config}    Retrieve BGP AS Global Configuration    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    local_as_number=${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    route_domain_id=${BGP_PRIMARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}
    log    \n**** BGP Global AS Config:\n ${bgp_global_as_config}
    ${bgp_ipv6_as_config}    Retrieve BGP AS IPv6 Address-Family Configuration    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    local_as_number=${BGP_PRIMARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    route_domain_id=${BGP_PRIMARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}
    log    \n**** BGP AS IPv6 Config:\n ${bgp_ipv6_as_config}
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    ${bgp_full_as_config}    Retrieve BGP AS Configuration    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    local_as_number=${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    route_domain_id=${BGP_SECONDARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}
    log    \n**** BGP Full AS Config:\n ${bgp_full_as_config}
    ${bgp_global_as_config}    Retrieve BGP AS Global Configuration    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    local_as_number=${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    route_domain_id=${BGP_SECONDARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}
    log    \n**** BGP Global AS Config:\n ${bgp_global_as_config}
    ${bgp_ipv6_as_config}    Retrieve BGP AS IPv6 Address-Family Configuration    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    local_as_number=${BGP_SECONDARY_SINGLE_CONTEXT_IPv4_PEER_GROUP_LOCAL_AS}    route_domain_id=${BGP_SECONDARY_SINGLE_CONTEXT_ROUTE_DOMAIN_ID}
    log    \n**** BGP AS IPv6 Config:\n ${bgp_ipv6_as_config}
    
Verify NTP Configuration
    [Documentation]  Validates the configuration of NTP servers on the BIG-IP
    set log level  trace
    ${defined_ntp_server_list}    to json    ${NTP_SERVER_LIST}
    ${primary_configured_ntp_list}    Query NTP Server List    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}
    lists should be equal    ${primary_configured_ntp_list}    ${defined_ntp_server_list}
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    ${secondary_configured_ntp_list}    Query NTP Server List    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}
    lists should be equal    ${primary_configured_ntp_list}    ${defined_ntp_server_list}

Verify NTP Operation
    [Documentation]  Verifies NTP associations on all configured NTP servers
    set log level  trace
    Wait until Keyword Succeeds    12x    10 seconds    Verify NTP Server Associations    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    Wait until Keyword Succeeds    12x    10 seconds    Verify NTP Server Associations    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}

Perform BIG-IP Quick Check before GTM Configuration
    [Documentation]    Verifies the ready status of services on the BIG-IP
    set log level    trace
    Wait until Keyword Succeeds    30x    10 seconds    Verify All BIG-IP Ready States    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${HTTP_USERNAME}    bigip_password=${HTTP_PASSWORD}
    Wait until Keyword Succeeds    50x    5 seconds    Check for BIG-IP Services Waiting to Restart    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${HTTP_USERNAME}    bigip_password=${HTTP_PASSWORD}
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    Wait until Keyword Succeeds    30x    10 seconds    Verify All BIG-IP Ready States    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${HTTP_USERNAME}    bigip_password=${HTTP_PASSWORD}
    Wait until Keyword Succeeds    50x    5 seconds    Check for BIG-IP Services Waiting to Restart    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${HTTP_USERNAME}    bigip_password=${HTTP_PASSWORD}

Verify GTM Service is Provisioned
    [Documentation]    Verifies that the Global Traffic Manager (GTM) software is provisioned on the BIG-IPs
    set log level    trace
    Wait until Keyword Succeeds    6x    10 seconds    Verify GTM is Provisioned    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${HTTP_USERNAME}    bigip_password=${HTTP_PASSWORD}
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    Wait until Keyword Succeeds    6x    10 seconds    Verify GTM is Provisioned    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${HTTP_USERNAME}    bigip_password=${HTTP_PASSWORD}

GSLB - SSL and iQuery
  [Documentation]  Change SSL certificates, validate iquery sessions is established

GSLB - Pool Creation
  [Documentation]  created pool, in different partitions

GSLB - Wide IP Creation
  [Documentation]  created wide IP, in different partitions

GSLB - Datacenter Creation
  [Documentation]  create Datacenters in common partition and validate sync across sync group

GSLB - Server and Virtual Server Creation
  [Documentation]  create server, virtual servers in common partition and validate sync across sync group

GSLB - Local and Anycast Listeners Creation
  [Documentation]  create and validate anycast and local listeners

GSLB - Create Zones and test authoritative DNS functionality
  [Documentation]  Add new Zones to ZoneRunner and verify DNS response to added Zones

