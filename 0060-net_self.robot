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
Perform BIG-IP Quick Check
    [Documentation]    Verifies that key BIG-IP services are in a ready state
    set log level    trace
    Wait until Keyword Succeeds    12x    15 seconds    Verify All BIG-IP Ready States    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}
    Wait until Keyword Succeeds    12x    15 seconds    Check for BIG-IP Services Waiting to Restart    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    Wait until Keyword Succeeds    12x    15 seconds    Verify All BIG-IP Ready States    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}
    Wait until Keyword Succeeds    12x    15 seconds    Check for BIG-IP Services Waiting to Restart    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}

Create BIG-IP Non-Floating Self-IP Addresses
    [Documentation]    Creates the non-floating self-IP addresses (similar to device-local IPs in HSRP/VRRP)
    set log level    trace
    ${SELF_IP_LIST}    to json    ${PRIMARY_LOCAL_SELF_IP_LIST}
    FOR    ${current_self_address}   IN    @{SELF_IP_LIST}
       ${self_ip_name}    get from dictionary    ${current_self_address}    name
       ${self_ip_address}    get from dictionary    ${current_self_address}    address
       ${self_ip_partition}    get from dictionary    ${current_self_address}    partition
       ${self_ip_vlan}    get from dictionary    ${current_self_address}    vlan
       ${self_ip_allow_service}    get from dictionary    ${current_self_address}    allow-service
       Create BIG-IP Non-floating Self IP Address    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    name=${self_ip_name}    address=${self_ip_address}    partition=${self_ip_partition}    vlan=${self_ip_vlan}    allow-service=${self_ip_allow_service}
       Verify BIG-IP Non-floating Self IP Address    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    name=${self_ip_name}    address=${self_ip_address}    partition=${self_ip_partition}
    END
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    ${SELF_IP_LIST}    to json    ${SECONDARY_LOCAL_SELF_IP_LIST}
    FOR    ${current_self_address}   IN    @{SELF_IP_LIST}
       ${self_ip_name}    get from dictionary    ${current_self_address}    name
       ${self_ip_address}    get from dictionary    ${current_self_address}    address
       ${self_ip_partition}    get from dictionary    ${current_self_address}    partition
       ${self_ip_vlan}    get from dictionary    ${current_self_address}    vlan
       ${self_ip_allow_service}    get from dictionary    ${current_self_address}    allow-service
       Create BIG-IP Non-floating Self IP Address    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    name=${self_ip_name}    address=${self_ip_address}    partition=${self_ip_partition}    vlan=${self_ip_vlan}    allow-service=${self_ip_allow_service}
       Verify BIG-IP Non-floating Self IP Address    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    name=${self_ip_name}    address=${self_ip_address}    partition=${self_ip_partition}
    END

Create BIG-IP Floating Self-IP Addresses
    [Documentation]    Creates the floating IP addresses on the BIG-IP, which are IPs that follow the active device in a cluster
    set log level    trace
    ${SELF_IP_LIST}    to json    ${PRIMARY_FLOATING_SELF_IP_LIST}
    FOR    ${current_self_address}   IN    @{SELF_IP_LIST}
       ${self_ip_name}    get from dictionary    ${current_self_address}    name
       ${self_ip_address}    get from dictionary    ${current_self_address}    address
       ${self_ip_partition}    get from dictionary    ${current_self_address}    partition
       ${self_ip_vlan}    get from dictionary    ${current_self_address}    vlan
       ${self_ip_allow_service}    get from dictionary    ${current_self_address}    allow-service
       Create BIG-IP Floating Self IP Address    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    name=${self_ip_name}    address=${self_ip_address}    partition=${self_ip_partition}    vlan=${self_ip_vlan}    allow-service=${self_ip_allow_service}
       Verify BIG-IP Floating Self IP Address    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    name=${self_ip_name}    address=${self_ip_address}    partition=${self_ip_partition}
    END
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    ${SELF_IP_LIST}    to json    ${SECONDARY_FLOATING_SELF_IP_LIST}
    FOR    ${current_self_address}   IN    @{SELF_IP_LIST}
       ${self_ip_name}    get from dictionary    ${current_self_address}    name
       ${self_ip_address}    get from dictionary    ${current_self_address}    address
       ${self_ip_partition}    get from dictionary    ${current_self_address}    partition
       ${self_ip_vlan}    get from dictionary    ${current_self_address}    vlan
       ${self_ip_allow_service}    get from dictionary    ${current_self_address}    allow-service
       Create BIG-IP Floating Self IP Address    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    name=${self_ip_name}    address=${self_ip_address}    partition=${self_ip_partition}    vlan=${self_ip_vlan}    allow-service=${self_ip_allow_service}
       Verify BIG-IP Floating Self IP Address    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    name=${self_ip_name}    address=${self_ip_address}    partition=${self_ip_partition}
    END

