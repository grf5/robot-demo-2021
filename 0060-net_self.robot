*** Settings ***
Documentation    This test configures parameters for "net self" objects on the BIG-IP
Resource    robotframework-f5-tmos.robot

*** Variables ***
${PRIMARY_HOSTNAME}                     %{PRIMARY_HOSTNAME}
${PRIMARY_MGMT_IP}                      %{PRIMARY_MGMT_IP}
${PRIMARY_SSH_USERNAME}                 %{PRIMARY_SSH_USERNAME}
${PRIMARY_SSH_PASSWORD}                 %{PRIMARY_SSH_PASSWORD}
${PRIMARY_HTTP_USERNAME}                %{PRIMARY_HTTP_USERNAME}
${PRIMARY_HTTP_PASSWORD}                %{PRIMARY_HTTP_PASSWORD}
${SECONDARY_HOSTNAME}                   %{SECONDARY_HOSTNAME}
${SECONDARY_MGMT_IP}                    %{SECONDARY_MGMT_IP}
${SECONDARY_SSH_USERNAME}               %{SECONDARY_SSH_USERNAME}
${SECONDARY_SSH_PASSWORD}               %{SECONDARY_SSH_PASSWORD}
${SECONDARY_HTTP_USERNAME}              %{SECONDARY_HTTP_USERNAME}
${SECONDARY_HTTP_PASSWORD}              %{SECONDARY_HTTP_PASSWORD}
${PRIMARY_LOCAL_SELF_IP_LIST}            %{PRIMARY_LOCAL_SELF_IP_LIST}
${PRIMARY_FLOATING_SELF_IP_LIST}            %{PRIMARY_FLOATING_SELF_IP_LIST}
${SECONDARY_LOCAL_SELF_IP_LIST}            %{SECONDARY_LOCAL_SELF_IP_LIST}
${SECONDARY_FLOATING_SELF_IP_LIST}            %{SECONDARY_FLOATING_SELF_IP_LIST}

*** Test Cases ***
Create BIG-IP Non-Floating Self-IP Addresses
    [Documentation]    Creates the non-floating self-IP addresses (similar to device-local IPs in HSRP/VRRP)
    set log level    trace
    ${SELF_IP_LIST}    to json    ${PRIMARY_LOCAL_SELF_IP_LIST}
    :FOR    ${current_self_address}   IN    @{SELF_IP_LIST}
    \   ${self_ip_name}    get from dictionary    ${current_self_address}    name
    \   ${self_ip_address}    get from dictionary    ${current_self_address}    address
    \   ${self_ip_partition}    get from dictionary    ${current_self_address}    partition
    \   ${self_ip_vlan}    get from dictionary    ${current_self_address}    vlan
    \   ${self_ip_allow_service}    get from dictionary    ${current_self_address}    allow-service
    \   Create BIG-IP Non-floating Self IP Address    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${HTTP_USERNAME}    bigip_password=${HTTP_PASSWORD}    name=${self_ip_name}    address=${self_ip_address}    partition=${self_ip_partition}    vlan=${self_ip_vlan}    allow-service=${self_ip_allow_service}
    \   Verify BIG-IP Non-floating Self IP Address    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${HTTP_USERNAME}    bigip_password=${HTTP_PASSWORD}    name=${self_ip_name}    address=${self_ip_address}    partition=${self_ip_partition}
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    ${SELF_IP_LIST}    to json    ${SECONDARY_LOCAL_SELF_IP_LIST}
    :FOR    ${current_self_address}   IN    @{SELF_IP_LIST}
    \   ${self_ip_name}    get from dictionary    ${current_self_address}    name
    \   ${self_ip_address}    get from dictionary    ${current_self_address}    address
    \   ${self_ip_partition}    get from dictionary    ${current_self_address}    partition
    \   ${self_ip_vlan}    get from dictionary    ${current_self_address}    vlan
    \   ${self_ip_allow_service}    get from dictionary    ${current_self_address}    allow-service
    \   Create BIG-IP Non-floating Self IP Address    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${HTTP_USERNAME}    bigip_password=${HTTP_PASSWORD}    name=${self_ip_name}    address=${self_ip_address}    partition=${self_ip_partition}    vlan=${self_ip_vlan}    allow-service=${self_ip_allow_service}
    \   Verify BIG-IP Non-floating Self IP Address    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${HTTP_USERNAME}    bigip_password=${HTTP_PASSWORD}    name=${self_ip_name}    address=${self_ip_address}    partition=${self_ip_partition}

Create BIG-IP Floating Self-IP Addresses
    [Documentation]    Creates the floating IP addresses on the BIG-IP, which are IPs that follow the active device in a cluster
    set log level    trace
    ${SELF_IP_LIST}    to json    ${PRIMARY_FLOATING_SELF_IP_LIST}
    :FOR    ${current_self_address}   IN    @{SELF_IP_LIST}
    \   ${self_ip_name}    get from dictionary    ${current_self_address}    name
    \   ${self_ip_address}    get from dictionary    ${current_self_address}    address
    \   ${self_ip_partition}    get from dictionary    ${current_self_address}    partition
    \   ${self_ip_vlan}    get from dictionary    ${current_self_address}    vlan
    \   ${self_ip_allow_service}    get from dictionary    ${current_self_address}    allow-service
    \   Create BIG-IP Floating Self IP Address    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${HTTP_USERNAME}    bigip_password=${HTTP_PASSWORD}    name=${self_ip_name}    address=${self_ip_address}    partition=${self_ip_partition}    vlan=${self_ip_vlan}    allow-service=${self_ip_allow_service}
    \   Verify BIG-IP Floating Self IP Address    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${HTTP_USERNAME}    bigip_password=${HTTP_PASSWORD}    name=${self_ip_name}    address=${self_ip_address}    partition=${self_ip_partition}
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    ${SELF_IP_LIST}    to json    ${SECONDARY_FLOATING_SELF_IP_LIST}
    :FOR    ${current_self_address}   IN    @{SELF_IP_LIST}
    \   ${self_ip_name}    get from dictionary    ${current_self_address}    name
    \   ${self_ip_address}    get from dictionary    ${current_self_address}    address
    \   ${self_ip_partition}    get from dictionary    ${current_self_address}    partition
    \   ${self_ip_vlan}    get from dictionary    ${current_self_address}    vlan
    \   ${self_ip_allow_service}    get from dictionary    ${current_self_address}    allow-service
    \   Create BIG-IP Floating Self IP Address    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${HTTP_USERNAME}    bigip_password=${HTTP_PASSWORD}    name=${self_ip_name}    address=${self_ip_address}    partition=${self_ip_partition}    vlan=${self_ip_vlan}    allow-service=${self_ip_allow_service}
    \   Verify BIG-IP Floating Self IP Address    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${HTTP_USERNAME}    bigip_password=${HTTP_PASSWORD}    name=${self_ip_name}    address=${self_ip_address}    partition=${self_ip_partition}

Create Static IPv4 Routes on the BIG-IP
    [Documentation]    Creates static routes on the BIG-IP
    set log level    trace
    ${STATIC_ROUTES_LIST}    To Json    ${PRIMARY_STATIC_ROUTE_LIST}
    :FOR    ${current_static_route}    IN    @{STATIC_ROUTES_LIST}
    \    ${route_name}    get from dictionary    ${current_static_route}    name
    \    ${route_network}    get from dictionary    ${current_static_route}    network
    \    ${route_gateway}    get from dictionary    ${current_static_route}    gw
    \    ${route_partition}    get from dictionary    ${current_static_route}    partition
    \    ${route_description}    get from dictionary    ${current_static_route}    description
    \    Create Static Route Configuration on the BIG-IP    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${HTTP_USERNAME}    bigip_password=${HTTP_PASSWORD}    name=${route_name}    partition=${route_partition}   cidr_network=${route_network}    gateway=${route_gateway}  description=${route_description}
    \    Verify Static Route Configuration on the BIG-IP    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${HTTP_USERNAME}    bigip_password=${HTTP_PASSWORD}    name=${route_name}    partition=${route_partition}   cidr_network=${route_network}    gateway=${route_gateway}  description=${route_description}
    \    Verify Static Route Presence in BIG-IP Route Table  bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${HTTP_USERNAME}    bigip_password=${HTTP_PASSWORD}    name=${route_name}    partition=${route_partition}   cidr_network=${route_network}    gateway=${route_gateway}
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    ${STATIC_ROUTES_LIST}    To Json    ${SECONDARY_STATIC_ROUTE_LIST}
    :FOR    ${current_static_route}    IN    @{STATIC_ROUTES_LIST}
    \    ${route_name}    get from dictionary    ${current_static_route}    name
    \    ${route_network}    get from dictionary    ${current_static_route}    network
    \    ${route_gateway}    get from dictionary    ${current_static_route}    gw
    \    ${route_partition}    get from dictionary    ${current_static_route}    partition
    \    ${route_description}    get from dictionary    ${current_static_route}    description
    \    Create Static Route Configuration on the BIG-IP    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${HTTP_USERNAME}    bigip_password=${HTTP_PASSWORD}    name=${route_name}    partition=${route_partition}   cidr_network=${route_network}    gateway=${route_gateway}  description=${route_description}
    \    Verify Static Route Configuration on the BIG-IP    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${HTTP_USERNAME}    bigip_password=${HTTP_PASSWORD}    name=${route_name}    partition=${route_partition}   cidr_network=${route_network}    gateway=${route_gateway}  description=${route_description}
    \    Verify Static Route Presence in BIG-IP Route Table  bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${HTTP_USERNAME}    bigip_password=${HTTP_PASSWORD}    name=${route_name}    partition=${route_partition}   cidr_network=${route_network}    gateway=${route_gateway}

Create Static IPv6 Routes on the BIG-IP
    [Documentation]    Creates static routes on the BIG-IP
    set log level    trace
    ${STATIC_ROUTESv6_LIST}    To Json    ${PRIMARY_STATIC_ROUTEv6_LIST}
    :FOR    ${current_static_route}    IN    @{STATIC_ROUTESv6_LIST}
    \    ${route_name}    get from dictionary    ${current_static_route}    name
    \    ${route_network}    get from dictionary    ${current_static_route}    network
    \    ${route_gateway}    get from dictionary    ${current_static_route}    gw
    \    ${route_partition}    get from dictionary    ${current_static_route}    partition
    \    ${route_description}    get from dictionary    ${current_static_route}    description
    \    Create Static Route Configuration on the BIG-IP    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${HTTP_USERNAME}    bigip_password=${HTTP_PASSWORD}    name=${route_name}    partition=${route_partition}   cidr_network=${route_network}    gateway=${route_gateway}  description=${route_description}
    \    Verify Static Route Configuration on the BIG-IP    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${HTTP_USERNAME}    bigip_password=${HTTP_PASSWORD}    name=${route_name}    partition=${route_partition}   cidr_network=${route_network}    gateway=${route_gateway}  description=${route_description}
    \    Verify Static Route Presence in BIG-IP Route Table  bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${HTTP_USERNAME}    bigip_password=${HTTP_PASSWORD}    name=${route_name}    partition=${route_partition}   cidr_network=${route_network}    gateway=${route_gateway}
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    ${STATIC_ROUTESv6_LIST}    To Json    ${SECONDARY_STATIC_ROUTEv6_LIST}
    :FOR    ${current_static_route}    IN    @{STATIC_ROUTESv6_LIST}
    \    ${route_name}    get from dictionary    ${current_static_route}    name
    \    ${route_network}    get from dictionary    ${current_static_route}    network
    \    ${route_gateway}    get from dictionary    ${current_static_route}    gw
    \    ${route_partition}    get from dictionary    ${current_static_route}    partition
    \    ${route_description}    get from dictionary    ${current_static_route}    description
    \    Create Static Route Configuration on the BIG-IP    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${HTTP_USERNAME}    bigip_password=${HTTP_PASSWORD}    name=${route_name}    partition=${route_partition}   cidr_network=${route_network}    gateway=${route_gateway}  description=${route_description}
    \    Verify Static Route Configuration on the BIG-IP    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${HTTP_USERNAME}    bigip_password=${HTTP_PASSWORD}    name=${route_name}    partition=${route_partition}   cidr_network=${route_network}    gateway=${route_gateway}  description=${route_description}
    \    Verify Static Route Presence in BIG-IP Route Table  bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${HTTP_USERNAME}    bigip_password=${HTTP_PASSWORD}    name=${route_name}    partition=${route_partition}   cidr_network=${route_network}    gateway=${route_gateway}

Create Default Static Routes on the BIG-IP
    [Documentation]    Creates default static routes on the BIG-IP
    set log level    trace
    ${PRIMARY_STATIC_DEFAULT_ROUTE}    to json    ${PRIMARY_STATIC_DEFAULT_ROUTE}
    ${route_partition}    get from dictionary    ${PRIMARY_STATIC_DEFAULT_ROUTE}    partition
    ${route_gateway}    get from dictionary    ${PRIMARY_STATIC_DEFAULT_ROUTE}    gw
    ${route_description}    get from dictionary    ${PRIMARY_STATIC_DEFAULT_ROUTE}    description
    Create Static Default Route Configuration on the BIG-IP    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${HTTP_USERNAME}    bigip_password=${HTTP_PASSWORD}    partition=${route_partition}    gateway=${route_gateway}    description=${route_description}
    ${PRIMARY_STATIC_DEFAULTv6_ROUTE}    to json    ${PRIMARY_STATIC_DEFAULTv6_ROUTE}
    ${route_partition}    get from dictionary    ${PRIMARY_STATIC_DEFAULTv6_ROUTE}    partition
    ${route_gateway}    get from dictionary    ${PRIMARY_STATIC_DEFAULTv6_ROUTE}    gw
    ${route_description}    get from dictionary    ${PRIMARY_STATIC_DEFAULTv6_ROUTE}    description
    Create Static IPv6 Default Route Configuration on the BIG-IP    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${HTTP_USERNAME}    bigip_password=${HTTP_PASSWORD}    partition=${route_partition}    gateway=${route_gateway}    description=${route_description}
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    ${SECONDARY_STATIC_DEFAULT_ROUTE}    to json    ${SECONDARY_STATIC_DEFAULT_ROUTE}
    ${route_partition}    get from dictionary    ${SECONDARY_STATIC_DEFAULT_ROUTE}    partition
    ${route_gateway}    get from dictionary    ${SECONDARY_STATIC_DEFAULT_ROUTE}    gw
    ${route_description}    get from dictionary    ${SECONDARY_STATIC_DEFAULT_ROUTE}    description
    Create Static Default Route Configuration on the BIG-IP    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${HTTP_USERNAME}    bigip_password=${HTTP_PASSWORD}    partition=${route_partition}    gateway=${route_gateway}    description=${route_description}
    ${SECONDARY_STATIC_DEFAULTv6_ROUTE}    to json    ${SECONDARY_STATIC_DEFAULTv6_ROUTE}
    ${route_partition}    get from dictionary    ${SECONDARY_STATIC_DEFAULTv6_ROUTE}    partition
    ${route_gateway}    get from dictionary    ${SECONDARY_STATIC_DEFAULTv6_ROUTE}    gw
    ${route_description}    get from dictionary    ${SECONDARY_STATIC_DEFAULTv6_ROUTE}    description
    Create Static IPv6 Default Route Configuration on the BIG-IP    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${HTTP_USERNAME}    bigip_password=${HTTP_PASSWORD}    partition=${route_partition}    gateway=${route_gateway}    description=${route_description}

Display Static Route Configuration on the BIG-IP
    [Documentation]    Retrieves the static routes configured on the device; does not retrieve the routing table/effective routes
    set log level    trace
    Display BIG-IP Static Route Configuration   bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${HTTP_USERNAME}    bigip_password=${HTTP_PASSWORD}
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    Display BIG-IP Static Route Configuration   bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${HTTP_USERNAME}    bigip_password=${HTTP_PASSWORD}

Ping the Gateway for Each Static IPv4 Route
    [Documentation]    Pings the next-hop for each static route to ensure its reachable
    set log level    trace
    ${STATIC_ROUTES_LIST}    To Json    ${PRIMARY_STATIC_ROUTE_LIST}
    :FOR    ${current_static_route}    IN    @{STATIC_ROUTES_LIST}
    \    ${route_name}    get from dictionary    ${current_static_route}    name
    \    ${route_gateway}    get from dictionary    ${current_static_route}    gw
    \    wait until keyword succeeds    6x    10 seconds    Ping Host from BIG-IP    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${HTTP_USERNAME}    bigip_password=${HTTP_PASSWORD}    host=${route_gateway}
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    ${STATIC_ROUTES_LIST}    To Json    ${SECONDARY_STATIC_ROUTE_LIST}
    :FOR    ${current_static_route}    IN    @{STATIC_ROUTES_LIST}
    \    ${route_name}    get from dictionary    ${current_static_route}    name
    \    ${route_gateway}    get from dictionary    ${current_static_route}    gw
    \    wait until keyword succeeds    6x    10 seconds    Ping Host from BIG-IP    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${HTTP_USERNAME}    bigip_password=${HTTP_PASSWORD}    host=${route_gateway}

Ping the Gateway for Each Static IPv6 Route
    [Documentation]    Pings the next-hop for each static route to ensure its reachable
    set log level    trace
    ${STATIC_ROUTESv6_LIST}    To Json    ${PRIMARY_STATIC_ROUTEv6_LIST}
    :FOR    ${current_static_route}    IN    @{STATIC_ROUTESv6_LIST}
    \    ${route_name}    get from dictionary    ${current_static_route}    name
    \    ${route_gateway}    get from dictionary    ${current_static_route}    gw
    \    wait until keyword succeeds    6x    10 seconds    Ping IPv6 Host from BIG-IP    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${HTTP_USERNAME}    bigip_password=${HTTP_PASSWORD}    host=${route_gateway}
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    ${STATIC_ROUTESv6_LIST}    To Json    ${SECONDARY_STATIC_ROUTEv6_LIST}
    :FOR    ${current_static_route}    IN    @{STATIC_ROUTESv6_LIST}
    \    ${route_name}    get from dictionary    ${current_static_route}    name
    \    ${route_gateway}    get from dictionary    ${current_static_route}    gw
    \    wait until keyword succeeds    6x    10 seconds    Ping IPv6 Host from BIG-IP    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${HTTP_USERNAME}    bigip_password=${HTTP_PASSWORD}    host=${route_gateway}
