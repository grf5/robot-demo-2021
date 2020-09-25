*** Settings ***
Documentation    This test configures parameters for "net vlan" objects on the BIG-IP
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
${OUTSIDE_VLAN_NAME}                    %{OUTSIDE_VLAN_NAME}
${OUTSIDE_VLAN_TAG}                     %{OUTSIDE_VLAN_TAG}
${OUTSIDE_VLAN_TAGGED}                  %{OUTSIDE_VLAN_TAGGED}
${OUTSIDE_INTERFACE_NAME}                   %{OUTSIDE_INTERFACE_NAME}
${INSIDE_VLAN_NAME}                     %{INSIDE_VLAN_NAME}
${INSIDE_VLAN_TAG}                      %{INSIDE_VLAN_TAG}
${INSIDE_VLAN_TAGGED}                   %{INSIDE_VLAN_TAGGED}
${INSIDE_INTERFACE_NAME}                    %{INSIDE_INTERFACE_NAME}

*** Test Cases ***
Perform BIG-IP Quick Check
    [Documentation]    Verifies that key BIG-IP services are in a ready state
    set log level    trace
    Wait until Keyword Succeeds    50x    5 seconds    Verify All BIG-IP Ready States    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}
    Wait until Keyword Succeeds    50x    5 seconds    Check for BIG-IP Services Waiting to Restart    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    Wait until Keyword Succeeds    50x    5 seconds    Verify All BIG-IP Ready States    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}
    Wait until Keyword Succeeds    50x    5 seconds    Check for BIG-IP Services Waiting to Restart    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}

Reset Statistics on the BIG-IP
    [Documentation]    Resets all interface, virtual, pool, node, etc statistics on the BIG-IP
    set log level    trace
    Reset All Statistics        bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    Reset All Statistics        bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}

Create the Inside VLAN on the BIG-IP
    [Documentation]    Creates the uplink/outside VLAN on the BIG-IP
    set log level    trace
    Create A Vlan on the BIG-IP    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    vlan_name=${INSIDE_VLAN_NAME}    vlan_tag=${${INSIDE_VLAN_TAG}}
    Verify dot1q Tag on BIG-IP VLAN    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    vlan_name=${INSIDE_VLAN_NAME}    vlan_tag=${${INSIDE_VLAN_TAG}}
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    Create A Vlan on the BIG-IP    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    vlan_name=${INSIDE_VLAN_NAME}    vlan_tag=${${INSIDE_VLAN_TAG}}
    Verify dot1q Tag on BIG-IP VLAN    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    vlan_name=${INSIDE_VLAN_NAME}    vlan_tag=${${INSIDE_VLAN_TAG}}

Create the Outside VLAN on the BIG-IP
    [Documentation]    Creates the uplink/outside VLAN on the BIG-IP
    set log level    trace
    Create A Vlan on the BIG-IP    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    vlan_name=${OUTSIDE_VLAN_NAME}    vlan_tag=${${OUTSIDE_VLAN_TAG}}
    Verify dot1q Tag on BIG-IP VLAN    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    vlan_name=${OUTSIDE_VLAN_NAME}    vlan_tag=${${OUTSIDE_VLAN_TAG}}
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    Create A Vlan on the BIG-IP    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    vlan_name=${OUTSIDE_VLAN_NAME}    vlan_tag=${${OUTSIDE_VLAN_TAG}}
    Verify dot1q Tag on BIG-IP VLAN    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    vlan_name=${OUTSIDE_VLAN_NAME}    vlan_tag=${${OUTSIDE_VLAN_TAG}}

Map the Outside VLAN to the Outside Interface
    [Documentation]    Maps the outside/uplink VLAN to the logical trunk
    set log level    trace
    ${interface_list}    Create List    ${OUTSIDE_INTERFACE_NAME}
    Modify VLAN Mapping on BIG-IP VLAN    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    vlan_name=${OUTSIDE_VLAN_NAME}    vlan_interface_list=${interface_list}
    Verify VLAN Mapping on a BIG-IP VLAN    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    vlan_name=${OUTSIDE_VLAN_NAME}    interface_name=${OUTSIDE_INTERFACE_NAME}
    Run Keyword If    '${OUTSIDE_VLAN_TAGGED}' == 'True'    Enable dot1q Tagging on a BIG-IP VLAN Interface    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    vlan_name=${OUTSIDE_VLAN_NAME}    interface_name=${OUTSIDE_INTERFACE_NAME}
    Run Keyword If    '${OUTSIDE_VLAN_TAGGED}' == 'True'    Verify dot1q Tagging Enabled on BIG-IP Vlan Interface    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    vlan_name=${OUTSIDE_VLAN_NAME}    interface_name=${OUTSIDE_INTERFACE_NAME}
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    ${interface_list}    Create List    ${OUTSIDE_INTERFACE_NAME}
    Modify VLAN Mapping on BIG-IP VLAN    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    vlan_name=${OUTSIDE_VLAN_NAME}    vlan_interface_list=${interface_list}
    Verify VLAN Mapping on a BIG-IP VLAN    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    vlan_name=${OUTSIDE_VLAN_NAME}    interface_name=${OUTSIDE_INTERFACE_NAME}
    Run Keyword If    '${OUTSIDE_VLAN_TAGGED}' == 'True'    Enable dot1q Tagging on a BIG-IP VLAN Interface    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    vlan_name=${OUTSIDE_VLAN_NAME}    interface_name=${OUTSIDE_INTERFACE_NAME}
    Run Keyword If    '${OUTSIDE_VLAN_TAGGED}' == 'True'    Verify dot1q Tagging Enabled on BIG-IP Vlan Interface    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    vlan_name=${OUTSIDE_VLAN_NAME}    interface_name=${OUTSIDE_INTERFACE_NAME}

Map the Inside VLAN to the Inside Interface
    [Documentation]    Maps the outside/uplink VLAN to the logical trunk
    set log level    trace
    ${interface_list}    Create List    ${INSIDE_INTERFACE_NAME}
    Modify VLAN Mapping on BIG-IP VLAN    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    vlan_name=${INSIDE_VLAN_NAME}    vlan_interface_list=${interface_list}
    Verify VLAN Mapping on a BIG-IP VLAN    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    vlan_name=${INSIDE_VLAN_NAME}    interface_name=${INSIDE_INTERFACE_NAME}
    Run Keyword If    '${INSIDE_VLAN_TAGGED}' == 'True'    Enable dot1q Tagging on a BIG-IP VLAN Interface    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    vlan_name=${INSIDE_VLAN_NAME}    interface_name=${INSIDE_INTERFACE_NAME}
    Run Keyword If    '${INSIDE_VLAN_TAGGED}' == 'True'    Verify dot1q Tagging Enabled on BIG-IP Vlan Interface    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    vlan_name=${INSIDE_VLAN_NAME}    interface_name=${INSIDE_INTERFACE_NAME}
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    ${interface_list}    Create List    ${INSIDE_INTERFACE_NAME}
    Modify VLAN Mapping on BIG-IP VLAN    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    vlan_name=${INSIDE_VLAN_NAME}    vlan_interface_list=${interface_list}
    Verify VLAN Mapping on a BIG-IP VLAN    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    vlan_name=${INSIDE_VLAN_NAME}    interface_name=${INSIDE_INTERFACE_NAME}
    Run Keyword If    '${INSIDE_VLAN_TAGGED}' == 'True'    Enable dot1q Tagging on a BIG-IP VLAN Interface    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    vlan_name=${INSIDE_VLAN_NAME}    interface_name=${INSIDE_INTERFACE_NAME}
    Run Keyword If    '${INSIDE_VLAN_TAGGED}' == 'True'    Verify dot1q Tagging Enabled on BIG-IP Vlan Interface    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    vlan_name=${INSIDE_VLAN_NAME}    interface_name=${INSIDE_INTERFACE_NAME}

Log All BIG-IP VLAN Configurations via TMSH
    [Documentation]    Gather a snapshot of the VLAN configurations post-configuration
    set log level    trace
    ${primary_vlan_configuration}    Retrieve BIG-IP VLAN Configuration via TMSH    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_SSH_USERNAME}    bigip_password=${PRIMARY_SSH_PASSWORD}
    log    ${primary_vlan_configuration}
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    ${secondary_vlan_configuration}    Retrieve BIG-IP VLAN Configuration via TMSH    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_SSH_USERNAME}    bigip_password=${SECONDARY_SSH_PASSWORD}
    log    ${secondary_vlan_configuration}

Log All BIG-IP VLAN Configurations via API
    [Documentation]    Logs all VLAN configurations through iControl REST
    set log level    trace
    ${primary_vlan_config_json}    Retrieve All BIG-IP VLAN Configurations    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}
    log    ${primary_vlan_config_json}
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    ${secondary_vlan_config_json}    Retrieve All BIG-IP VLAN Configurations    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}
    log    ${secondary_vlan_config_json}

Retrieve All BIG-IP Interface Configurations via TMSH
    [Documentation]    Gather a snapshot of the interface configurations post-configuration
    set log level    trace
    ${primary_interface_configurations}    Retrieve BIG-IP Interface Configuration via TMSH    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_SSH_USERNAME}    bigip_password=${PRIMARY_SSH_PASSWORD}
    log    ${primary_interface_configurations}
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    ${secondary_interface_configurations}    Retrieve BIG-IP Interface Configuration via TMSH    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_SSH_USERNAME}    bigip_password=${SECONDARY_SSH_PASSWORD}
    log    ${secondary_interface_configurations}

Gather All BIG-IP Interface Configurations via API
    [Documentation]    Logs all interface configurations through iControl REST
    set log level    trace
    ${primary_interface_configurations}    List all BIG-IP Interfaces    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}
    log    ${primary_interface_configurations}
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    ${secondary_interface_configurations}    List all BIG-IP Interfaces    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}
    log    ${secondary_interface_configurations}