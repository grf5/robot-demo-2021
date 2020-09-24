*** Settings ***
Documentation    This test checks for proper configuration, validation and operation of NTP on the BIG-IP
Resource    f5-robot-library-unrefined.robot
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
${NTP_SERVER_LIST}                      %{NTP_SERVER_LIST}

*** Test Cases ***
Create Management Route for NTP Servers
    [Documentation]    Routes NTP traffic through the management network
    set log level    trace
    ${defined_ntp_server_list}    to json    ${NTP_SERVER_LIST}
    :FOR    ${current_ntp_server}    IN    @{defined_ntp_server_list}
    \    Create Management Network Route    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${HTTP_PASSWORD}    name=${current_ntp_server}    network=${current_ntp_server}    gateway=${MGMT_NETWORK_GATEWAY}
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    :FOR    ${current_ntp_server}    IN    @{defined_ntp_server_list}
    \    Create Management Network Route    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    name=${current_ntp_server}    network=${current_ntp_server}    gateway=${MGMT_NETWORK_GATEWAY}
      
Configure NTP Servers
    [Documentation]    Configures NTP servers on the BIG-IP
    set log level    trace
    Configure NTP Server List    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    ntp_server_list=${NTP_SERVER_LIST}
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    Configure NTP Server List    bigip_host=${SECONDARY_MGMT_IP}   bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    ntp_server_list=${NTP_SERVER_LIST}

Verify NTP Configuration
    [Documentation]    Validates the configuration of NTP servers on the BIG-IP
    set log level    trace
    ${defined_ntp_server_list}    to json    ${NTP_SERVER_LIST}
    ${primary_configured_ntp_list}    Query NTP Server List    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}
    lists should be equal    ${primary_configured_ntp_list}    ${defined_ntp_server_list}
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    ${secondary_configured_ntp_list}    Query NTP Server List    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}
    lists should be equal    ${primary_configured_ntp_list}    ${defined_ntp_server_list}

Verify NTP Operation
    [Documentation]    Verifies NTP associations on all configured NTP servers
    set log level    trace
    Wait until Keyword Succeeds    6x    10 seconds    Verify NTP Server Associations    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    Wait until Keyword Succeeds    6x    10 seconds    Verify NTP Server Associations    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}
