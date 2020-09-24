*** Settings ***
Documentation    This test checks for basic access to the management services (SSH, HTTPS UI, iControl REST API)
Resource    f5-robot-library-unrefined.robot
Resource    robotframework-f5-tmos.robot

*** Variables ***
${PRIMARY_HOSTNAME}                     %{PRIMARY_HOSTNAME}
${PRIMARY_MGMT_IP}                      %{PRIMARY_MGMT_IP}
${PRIMARY_HTTP_USERNAME}                %{PRIMARY_HTTP_USERNAME}
${PRIMARY_HTTP_PASSWORD}                %{PRIMARY_HTTP_PASSWORD}
${SECONDARY_HOSTNAME}                   %{SECONDARY_HOSTNAME}
${SECONDARY_MGMT_IP}                    %{SECONDARY_MGMT_IP}
${SECONDARY_HTTP_USERNAME}              %{SECONDARY_HTTP_USERNAME}
${SECONDARY_HTTP_PASSWORD}              %{SECONDARY_HTTP_PASSWORD}
${NTP_SERVER_LIST}                      %{NTP_SERVER_LIST}
${MGMT_NETWORK_GATEWAY}                 %{MGMT_NETWORK_GATEWAY}

*** Test Cases ***
Perform BIG-IP Quick Check
    [Documentation]    Verifies that key BIG-IP services are in a ready state
    set log level    trace
    Verify All BIG-IP Ready States    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}
    Check for BIG-IP Services Waiting to Restart    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    Verify All BIG-IP Ready States    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}
    Check for BIG-IP Services Waiting to Restart    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}

Set BIG-IP Hostnames
    [Documentation]    Configures the device hostname
    set log level    trace
    Configure BIG-IP Hostname    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    hostname=${PRIMARY_HOSTNAME}
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    Configure BIG-IP Hostname    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    hostname=${SECONDARY_HOSTNAME}

Verify BIG-IP Hostnames
    [Documentation]    Verify the configured device hostname
    set log level    trace
    ${configured_primary_hostname}    Retrieve BIG-IP Hostname    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}
    should be equal as strings    ${PRIMARY_HOSTNAME}    ${configured_primary_hostname}
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    ${configured_secondary_hostname}    Retrieve BIG-IP Hostname    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}
    should be equal as strings    ${SECONDARY_HOSTNAME}    ${configured_secondary_hostname}
    