*** Settings ***
Documentation    This test resets the test environment back to default configurations
Resource    robotframework-f5-tmos.robot

*** Variables ***
${PRIMARY_MGMT_IP}                      %{PRIMARY_MGMT_IP}
${PRIMARY_HTTP_USERNAME}                %{PRIMARY_HTTP_USERNAME}
${PRIMARY_HTTP_PASSWORD}                %{PRIMARY_HTTP_PASSWORD}
${SECONDARY_MGMT_IP}                    %{SECONDARY_MGMT_IP}
${SECONDARY_HTTP_USERNAME}              %{SECONDARY_HTTP_USERNAME}
${SECONDARY_HTTP_PASSWORD}              %{SECONDARY_HTTP_PASSWORD}
${PRIMARY_BASE_UCS_FILENAME}            %{PRIMARY_BASE_UCS_FILENAME}
${SECONDARY_BASE_UCS_FILENAME}          %{SECONDARY_BASE_UCS_FILENAME}

*** Test Cases ***
Perform BIG-IP Quick Check
    [Documentation]    Verifies that key BIG-IP services are in a ready state
    set log level    trace
    Wait until Keyword Succeeds    12x    15 seconds    Verify All BIG-IP Ready States    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}
    Wait until Keyword Succeeds    12x    15 seconds    Check for BIG-IP Services Waiting to Restart    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    Wait until Keyword Succeeds    12x    15 seconds    Verify All BIG-IP Ready States    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}
    Wait until Keyword Succeeds    12x    15 seconds    Check for BIG-IP Services Waiting to Restart    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}

Load the BIG-IP Configuration with Base Provisioning
    [Documentation]    Loads the UCS that has a default configuration but with AFM and GTM provisioned to nominal level (saves time when restarting during development)
    set log level    trace
    Load a UCS on the BIG-IP    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    ucs_filename=${PRIMARY_BASE_UCS_FILENAME}
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    Load a UCS on the BIG-IP    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    ucs_filename=${SECONDARY_BASE_UCS_FILENAME}

Perform Post-UCS Load BIG-IP Quick Check
    [Documentation]    Verifies that key BIG-IP services are in a ready state
    set log level    trace
    Wait until Keyword Succeeds    12x    15 seconds    Verify All BIG-IP Ready States    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}
    Wait until Keyword Succeeds    12x    15 seconds    Check for BIG-IP Services Waiting to Restart    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    Wait until Keyword Succeeds    12x    15 seconds    Verify All BIG-IP Ready States    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}
    Wait until Keyword Succeeds    12x    15 seconds    Check for BIG-IP Services Waiting to Restart    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}

