*** Settings ***
Documentation    This test downloads the final configurations from the BIG-IPs
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
${PRIMARY_SCF_FILENAME}    %{PRIMARY_SCF_FILENAME}
${SECONDARY_SCF_FILENAME}    %{SECONDARY_SCF_FILENAME}

*** Test Cases ***
Record the Text Configuration on the BIG-IP
    [Documentation]    Retrieves the BIG-IP text configuration for recording
    set log level    trace
    Save an SCF on the BIG-IP    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    scf_filename=${PRIMARY_SCF_FILENAME}
    Wait until Keyword Succeeds    3x    5 seconds    Open Connection    ${PRIMARY_MGMT_IP}
    Log In    ${PRIMARY_SSH_USERNAME}    ${PRIMARY_SSH_PASSWORD}
    ${scf_config}    Execute Command    cat /var/local/scf/${PRIMARY_SCF_FILENAME}
    log    ${scf_config}
    ${text_config}    Execute Command    tmsh -q -c 'list'
    log    ${text_config}
    Execute Command    cat -R /config/zebos/*.conf
    Close All Connections
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    Save an SCF on the BIG-IP    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    scf_filename=${SECONDARY_SCF_FILENAME}
    Wait until Keyword Succeeds    3x    5 seconds    Open Connection    ${SECONDARY_MGMT_IP}
    Log In    ${SECONDARY_SSH_USERNAME}    ${SECONDARY_SSH_PASSWORD}
    ${scf_config}    Execute Command    cat /var/local/scf/${SECONDARY_SCF_FILENAME}
    log    ${scf_config}
    ${text_config}    Execute Command    tmsh -q -c 'list'
    log    ${text_config}
    Execute Command    cat -R /config/zebos/*.conf
    Close All Connections
