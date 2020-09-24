*** Settings ***
Documentation    This test checks for basic access to the management services (SSH, HTTPS UI, iControl REST API)
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
${ROBOT_HOST_IP}                        %{ROBOT_HOST_IP}

*** Test Cases ***
Perform BIG-IP Quick Check
    [Documentation]    Verifies that key BIG-IP services are in a ready state
    set log level    trace
    Wait until Keyword Succeeds    50x    5 seconds    Verify All BIG-IP Ready States    host=${PRIMARY_MGMT_IP}    username=${HTTP_USERNAME}    password=${HTTP_PASSWORD}
    Wait until Keyword Succeeds    50x    5 seconds    Check for BIG-IP Services Waiting to Restart    host=${PRIMARY_MGMT_IP}    username=${HTTP_USERNAME}    password=${HTTP_PASSWORD}
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    Wait until Keyword Succeeds    50x    5 seconds    Verify All BIG-IP Ready States    host=${SECONDARY_MGMT_IP}    username=${HTTP_USERNAME}    password=${HTTP_PASSWORD}
    Wait until Keyword Succeeds    50x    5 seconds    Check for BIG-IP Services Waiting to Restart    host=${SECONDARY_MGMT_IP}    username=${HTTP_USERNAME}    password=${HTTP_PASSWORD}


