*** Settings ***
Documentation    This test checks for basic access to the management services (SSH, HTTPS UI, iControl REST API)
Resource    robotframework-f5-tmos.robot

*** Variables ***
${PRIMARY_MGMT_IP}                      %{PRIMARY_MGMT_IP}
${PRIMARY_HTTP_USERNAME}                %{PRIMARY_HTTP_USERNAME}
${PRIMARY_HTTP_PASSWORD}                %{PRIMARY_HTTP_PASSWORD}
${SECONDARY_MGMT_IP}                    %{SECONDARY_MGMT_IP}
${SECONDARY_HTTP_USERNAME}              %{SECONDARY_HTTP_USERNAME}
${SECONDARY_HTTP_PASSWORD}              %{SECONDARY_HTTP_PASSWORD}

*** Test Cases ***
Set the admin user's shell to bash
    [Documentation]    Sets the admin user's default shell from tmsh to bash
    set log level    trace
    Change a User's Default Shell    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    username=admin    shell=bash
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    Change a User's Default Shell    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    username=admin    shell=bash
