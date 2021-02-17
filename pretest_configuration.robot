*** Settings ***
Documentation    This suite configures the BIG-IPs in preparation for testing
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
${MODULE_PROVISIONING}                  %{MODULE_PROVISIONING}
${NTP_SERVER_LIST}                      %{NTP_SERVER_LIST}
${MGMT_NETWORK_GATEWAY}                 %{MGMT_NETWORK_GATEWAY}
${PRIMARY_INTERFACE_DETAILS}            %{PRIMARY_INTERFACE_DETAILS}
${SECONDARY_INTERFACE_DETAILS}          %{SECONDARY_INTERFACE_DETAILS}
${OUTSIDE_VLAN_NAME}                    %{OUTSIDE_VLAN_NAME}
${OUTSIDE_VLAN_TAG}                     %{OUTSIDE_VLAN_TAG}
${OUTSIDE_VLAN_TAGGED}                  %{OUTSIDE_VLAN_TAGGED}
${OUTSIDE_INTERFACE_NAME}               %{OUTSIDE_INTERFACE_NAME}
${INSIDE_VLAN_NAME}                     %{INSIDE_VLAN_NAME}
${INSIDE_VLAN_TAG}                      %{INSIDE_VLAN_TAG}
${INSIDE_VLAN_TAGGED}                   %{INSIDE_VLAN_TAGGED}
${INSIDE_INTERFACE_NAME}                %{INSIDE_INTERFACE_NAME}
${HA_VLAN_NAME}                         %{HA_VLAN_NAME}
${HA_VLAN_TAG}                          %{HA_VLAN_TAG}
${HA_VLAN_TAGGED}                       %{HA_VLAN_TAGGED}
${HA_INTERFACE_NAME}                    %{HA_INTERFACE_NAME}
${PRIMARY_LOCAL_SELF_IP_LIST}           %{PRIMARY_LOCAL_SELF_IP_LIST}
${SECONDARY_LOCAL_SELF_IP_LIST}         %{SECONDARY_LOCAL_SELF_IP_LIST}
${PRIMARY_STATIC_DEFAULT_ROUTE}         %{PRIMARY_STATIC_DEFAULT_ROUTE}
${SECONDARY_STATIC_DEFAULT_ROUTE}       %{SECONDARY_STATIC_DEFAULT_ROUTE}
${DSC_GROUP_NAME}                       %{DSC_GROUP_NAME}

*** Test Cases ***
Perform BIG-IP Quick Check
    [Documentation]  Verifies that key BIG-IP services are in a ready state
    set log level  trace
    Wait until Keyword Succeeds    30x    10 seconds    Verify All BIG-IP Ready States    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}
    Wait until Keyword Succeeds    30x    10 seconds    Check for BIG-IP Services Waiting to Restart    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    Wait until Keyword Succeeds    30x    10 seconds    Verify All BIG-IP Ready States    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}
    Wait until Keyword Succeeds    30x    10 seconds    Check for BIG-IP Services Waiting to Restart    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}

Provision Software Modules on the BIG-IP
    [Documentation]  Sets the provisioning level on software modules in the BIG-IP
    set log level  trace
    ${module_list}    to json    ${MODULE_PROVISIONING}
    FOR    ${current_module}    IN    @{module_list}
        Verify All BIG-IP Ready States    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}
        Check for BIG-IP Services Waiting to Restart    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}
        ${module}    get from dictionary    ${current_module}    module
        ${provisioning_level}    get from dictionary    ${current_module}    provisioningLevel
        Provision Module on the BIG-IP    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    module=${module}    provisioning_level=${provisioning_level}
    END
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    ${module_list}    to json    ${MODULE_PROVISIONING}
    FOR    ${current_module}    IN    @{module_list}
        Verify All BIG-IP Ready States    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}
        Check for BIG-IP Services Waiting to Restart    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}
        ${module}    get from dictionary    ${current_module}    module
        ${provisioning_level}    get from dictionary    ${current_module}    provisioningLevel
        Provision Module on the BIG-IP    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    module=${module}    provisioning_level=${provisioning_level}
    END

Perform BIG-IP Post-Provision Check
    [Documentation]  Verifies that key BIG-IP services are in a ready state
    set log level  trace
    Wait until Keyword Succeeds    12x    15 seconds    Verify All BIG-IP Ready States    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}
    wait until keyword succeeds    12x    15 seconds    Check for BIG-IP Services Waiting to Restart    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    Wait until Keyword Succeeds    12x    15 seconds    Verify All BIG-IP Ready States    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}
    wait until keyword succeeds    12x    15 seconds    Check for BIG-IP Services Waiting to Restart    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}

Verify Module Provisioning
    [Documentation]  Verifies that the software modules are provisioned as expected on the BIG-IP
    set log level  trace
    ${module_list}    to json    ${MODULE_PROVISIONING}
    FOR    ${current_module}    IN    @{module_list}
        Verify All BIG-IP Ready States    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}
        Check for BIG-IP Services Waiting to Restart    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}
        ${module}    get from dictionary    ${current_module}    module
        ${provisioning_level}    get from dictionary    ${current_module}    provisioningLevel
        Verify Module is Provisioned  bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    module=${module}
    END
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    ${module_list}    to json    ${MODULE_PROVISIONING}
    FOR    ${current_module}    IN    @{module_list}
        Verify All BIG-IP Ready States    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}
        Check for BIG-IP Services Waiting to Restart    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}
        ${module}    get from dictionary    ${current_module}    module
        ${provisioning_level}    get from dictionary    ${current_module}    provisioningLevel
        Verify Module is Provisioned    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    module=${module}
    END    

Disable the GUI Setup Wizard
    [Documentation]  Disables the GUI setup wizard that runs when a BIG-IP UI is loaded without a configuration
    set log level  trace
    Disable BIG-IP GUI Setup Wizard    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    Disable BIG-IP GUI Setup Wizard    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}

Perform BIG-IP Quick Check
    [Documentation]  Verifies that key BIG-IP services are in a ready state
    set log level  trace
    Wait until Keyword Succeeds    12x    15 seconds    Verify All BIG-IP Ready States    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}
    Wait until Keyword Succeeds    12x    15 seconds    Check for BIG-IP Services Waiting to Restart    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    Wait until Keyword Succeeds    12x    15 seconds    Verify All BIG-IP Ready States    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}
    Wait until Keyword Succeeds    12x    15 seconds    Check for BIG-IP Services Waiting to Restart    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}

Set BIG-IP Hostnames
    [Documentation]  Configures the device hostname
    set log level  trace
    Configure BIG-IP Hostname    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    hostname=${PRIMARY_HOSTNAME}
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    Configure BIG-IP Hostname    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    hostname=${SECONDARY_HOSTNAME}

Verify BIG-IP Hostnames
    [Documentation]  Verify the configured device hostname
    set log level  trace
    ${configured_primary_hostname}    Retrieve BIG-IP Hostname    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}
    should be equal as strings    ${PRIMARY_HOSTNAME}    ${configured_primary_hostname}
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    ${configured_secondary_hostname}    Retrieve BIG-IP Hostname    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}
    should be equal as strings    ${SECONDARY_HOSTNAME}    ${configured_secondary_hostname}
    
Create Management Route for NTP Servers
    [Documentation]  Routes NTP traffic through the management network
    set log level  trace
    ${defined_ntp_server_list}    to json    ${NTP_SERVER_LIST}
    FOR    ${current_ntp_server}    IN    @{defined_ntp_server_list}
        Create Management Network Route    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    name=${current_ntp_server}    network=${current_ntp_server}    gateway=${MGMT_NETWORK_GATEWAY}
    END
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    FOR    ${current_ntp_server}    IN    @{defined_ntp_server_list}
        Create Management Network Route    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    name=${current_ntp_server}    network=${current_ntp_server}    gateway=${MGMT_NETWORK_GATEWAY}
    END

Configure NTP Servers
    [Documentation]  Configures NTP servers on the BIG-IP
    set log level  trace
    Configure NTP Server List    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    ntp_server_list=${NTP_SERVER_LIST}
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    Configure NTP Server List    bigip_host=${SECONDARY_MGMT_IP}   bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    ntp_server_list=${NTP_SERVER_LIST}

Verify BIG-IP is ready before configuring VLANs
    [Documentation]  Verifies that key BIG-IP services are in a ready state
    set log level  trace
    Wait until Keyword Succeeds    12x    15 seconds    Verify All BIG-IP Ready States    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}
    Wait until Keyword Succeeds    12x    15 seconds    Check for BIG-IP Services Waiting to Restart    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    Wait until Keyword Succeeds    12x    15 seconds    Verify All BIG-IP Ready States    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}
    Wait until Keyword Succeeds    12x    15 seconds    Check for BIG-IP Services Waiting to Restart    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}

Reset Statistics on the BIG-IP
    [Documentation]  Resets all interface, virtual, pool, node, etc statistics on the BIG-IP
    set log level  trace
    Reset All Statistics        bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    Reset All Statistics        bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}

Create the Inside VLAN on the BIG-IP
    [Documentation]  Creates the uplink/outside VLAN on the BIG-IP
    set log level  trace
    Create A Vlan on the BIG-IP    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    vlan_name=${INSIDE_VLAN_NAME}    vlan_tag=${${INSIDE_VLAN_TAG}}
    Verify dot1q Tag on BIG-IP VLAN    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    vlan_name=${INSIDE_VLAN_NAME}    vlan_tag=${${INSIDE_VLAN_TAG}}
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    Create A Vlan on the BIG-IP    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    vlan_name=${INSIDE_VLAN_NAME}    vlan_tag=${${INSIDE_VLAN_TAG}}
    Verify dot1q Tag on BIG-IP VLAN    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    vlan_name=${INSIDE_VLAN_NAME}    vlan_tag=${${INSIDE_VLAN_TAG}}

Create the Outside VLAN on the BIG-IP
    [Documentation]  Creates the uplink/outside VLAN on the BIG-IP
    set log level  trace
    Create A Vlan on the BIG-IP    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    vlan_name=${OUTSIDE_VLAN_NAME}    vlan_tag=${${OUTSIDE_VLAN_TAG}}
    Verify dot1q Tag on BIG-IP VLAN    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    vlan_name=${OUTSIDE_VLAN_NAME}    vlan_tag=${${OUTSIDE_VLAN_TAG}}
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    Create A Vlan on the BIG-IP    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    vlan_name=${OUTSIDE_VLAN_NAME}    vlan_tag=${${OUTSIDE_VLAN_TAG}}
    Verify dot1q Tag on BIG-IP VLAN    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    vlan_name=${OUTSIDE_VLAN_NAME}    vlan_tag=${${OUTSIDE_VLAN_TAG}}

Create the HA VLAN on the BIG-IP
    [Documentation]  Creates the uplink/outside VLAN on the BIG-IP
    set log level  trace
    Create A Vlan on the BIG-IP    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    vlan_name=${HA_VLAN_NAME}    vlan_tag=${${HA_VLAN_TAG}}
    Verify dot1q Tag on BIG-IP VLAN    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    vlan_name=${HA_VLAN_NAME}    vlan_tag=${${HA_VLAN_TAG}}
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    Create A Vlan on the BIG-IP    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    vlan_name=${HA_VLAN_NAME}    vlan_tag=${${HA_VLAN_TAG}}
    Verify dot1q Tag on BIG-IP VLAN    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    vlan_name=${HA_VLAN_NAME}    vlan_tag=${${HA_VLAN_TAG}}

Map the Outside VLAN to the Outside Interface
    [Documentation]  Maps the outside/uplink VLAN to the logical interface
    set log level  trace
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
    [Documentation]  Maps the outside/uplink VLAN to the logical interface
    set log level  trace
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
    [Documentation]  Gather a snapshot of the VLAN configurations post-configuration
    set log level  trace
    ${primary_vlan_configuration}    Retrieve BIG-IP VLAN Configuration via TMSH    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_SSH_USERNAME}    bigip_password=${PRIMARY_SSH_PASSWORD}
    log    ${primary_vlan_configuration}
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    ${secondary_vlan_configuration}    Retrieve BIG-IP VLAN Configuration via TMSH    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_SSH_USERNAME}    bigip_password=${SECONDARY_SSH_PASSWORD}
    log    ${secondary_vlan_configuration}

Log All BIG-IP VLAN Configurations via API
    [Documentation]  Logs all VLAN configurations through iControl REST
    set log level  trace
    ${primary_vlan_config_json}    Retrieve All BIG-IP VLAN Configurations    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}
    log    ${primary_vlan_config_json}
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    ${secondary_vlan_config_json}    Retrieve All BIG-IP VLAN Configurations    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}
    log    ${secondary_vlan_config_json}

Retrieve All BIG-IP Interface Configurations via TMSH
    [Documentation]  Gather a snapshot of the interface configurations post-configuration
    set log level  trace
    ${primary_interface_configurations}    Retrieve BIG-IP Interface Configuration via TMSH    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_SSH_USERNAME}    bigip_password=${PRIMARY_SSH_PASSWORD}
    log    ${primary_interface_configurations}
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    ${secondary_interface_configurations}    Retrieve BIG-IP Interface Configuration via TMSH    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_SSH_USERNAME}    bigip_password=${SECONDARY_SSH_PASSWORD}
    log    ${secondary_interface_configurations}

Gather All BIG-IP Interface Configurations via API
    [Documentation]  Logs all interface configurations through iControl REST
    set log level  trace
    ${primary_interface_configurations}    List all BIG-IP Interfaces    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}
    log    ${primary_interface_configurations}
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    ${secondary_interface_configurations}    List all BIG-IP Interfaces    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}
    log    ${secondary_interface_configurations}

Reset Statistics on the BIG-IP
    [Documentation]  Resets all interface, virtual, pool, node, etc statistics on the BIG-IP
    set log level  trace
    Reset All Statistics        bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    Reset All Statistics        bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}

Get List of BIG-IP Interfaces
    [Documentation]  Simply logs a list of all detected BIG-IP interfaces (https://support.f5.com/csp/article/K14107)
    set log level  trace
    List all BIG-IP Interfaces    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    List all BIG-IP Interfaces    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}

Gather Interface Media Capabilities
    [Documentation]  Shows which each physical port capabilities (https://support.f5.com/csp/article/K14107)
    set log level  trace
    ${media-capabilities}    set variable    Retrieve BIG-IP Interface Media Capabilities    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}
    log    ${media-capabilities}
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    ${media-capabilities}    set variable    Retrieve BIG-IP Interface Media Capabilities    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}
    log    ${media-capabilities}

Configure F5 BIG-IP Data Plane Interfaces
    [Documentation]  Configures the BIG-IP interfaces (not including the management interface)
    set log level  trace
    ${INTERFACE_LIST}    to json    ${PRIMARY_INTERFACE_DETAILS}
    FOR    ${current_interface}    IN    @{INTERFACE_LIST}
       ${current_interface_name}    get from dictionary    ${current_interface}    name
       ${current_interface_description}    get from dictionary    ${current_interface}    description
       ${current_interface_lldpadmin}    get from dictionary    ${current_interface}    lldpAdmin
       Configure BIG-IP Interface Description    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    interface_name=${current_interface_name}    interface_description=${current_interface_description}
       run keyword if    '${current_interface_lldpadmin}'=='txrx'    Set BIG-IP Interface LLDP to Transmit and Receive   bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}   interface_name=${current_interface_name}
       run keyword if    '${current_interface_lldpadmin}'=='txonly'    Set BIG-IP Interface LLDP to Transmit Only    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}   interface_name=${current_interface_name}
       run keyword if    '${current_interface_lldpadmin}'=='rxonly'    Set BIG-IP Interface LLDP to Receive Only    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}   interface_name=${current_interface_name}
       run keyword if    '${current_interface_lldpadmin}'=='disable'   Disable BIG-IP LLDP on Interface    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}   interface_name=${current_interface_name}
    END
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    ${INTERFACE_LIST}    to json    ${SECONDARY_INTERFACE_DETAILS}
    FOR    ${current_interface}    IN    @{INTERFACE_LIST}
       ${current_interface_name}    get from dictionary    ${current_interface}    name
       ${current_interface_description}    get from dictionary    ${current_interface}    description
       ${current_interface_lldpadmin}    get from dictionary    ${current_interface}    lldpAdmin
       Configure BIG-IP Interface Description    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    interface_name=${current_interface_name}    interface_description=${current_interface_description}
       run keyword if    '${current_interface_lldpadmin}'=='txrx'    Set BIG-IP Interface LLDP to Transmit and Receive   bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}   interface_name=${current_interface_name}
       run keyword if    '${current_interface_lldpadmin}'=='txonly'    Set BIG-IP Interface LLDP to Transmit Only    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}   interface_name=${current_interface_name}
       run keyword if    '${current_interface_lldpadmin}'=='rxonly'    Set BIG-IP Interface LLDP to Receive Only    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}   interface_name=${current_interface_name}
       run keyword if    '${current_interface_lldpadmin}'=='disable'   Disable BIG-IP LLDP on Interface    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}   interface_name=${current_interface_name}
    END

Create BIG-IP Non-Floating Self-IP Addresses
    [Documentation]  Creates the non-floating self-IP addresses (similar to device-local IPs in HSRP/VRRP)
    set log level  trace
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

# Create BIG-IP Floating Self-IP Addresses
#     [Documentation]  Creates the floating IP addresses on the BIG-IP, which are IPs that follow the active device in a cluster
#     set log level  trace
#     ${SELF_IP_LIST}    to json    ${PRIMARY_FLOATING_SELF_IP_LIST}
#     FOR    ${current_self_address}   IN    @{SELF_IP_LIST}
#        ${self_ip_name}    get from dictionary    ${current_self_address}    name
#        ${self_ip_address}    get from dictionary    ${current_self_address}    address
#        ${self_ip_partition}    get from dictionary    ${current_self_address}    partition
#        ${self_ip_vlan}    get from dictionary    ${current_self_address}    vlan
#        ${self_ip_allow_service}    get from dictionary    ${current_self_address}    allow-service
#        Create BIG-IP Floating Self IP Address    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    name=${self_ip_name}    address=${self_ip_address}    partition=${self_ip_partition}    vlan=${self_ip_vlan}    allow-service=${self_ip_allow_service}
#        Verify BIG-IP Floating Self IP Address    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    name=${self_ip_name}    address=${self_ip_address}    partition=${self_ip_partition}
#     END
#     Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
#     ${SELF_IP_LIST}    to json    ${SECONDARY_FLOATING_SELF_IP_LIST}
#     FOR    ${current_self_address}   IN    @{SELF_IP_LIST}
#        ${self_ip_name}    get from dictionary    ${current_self_address}    name
#        ${self_ip_address}    get from dictionary    ${current_self_address}    address
#        ${self_ip_partition}    get from dictionary    ${current_self_address}    partition
#        ${self_ip_vlan}    get from dictionary    ${current_self_address}    vlan
#        ${self_ip_allow_service}    get from dictionary    ${current_self_address}    allow-service
#        Create BIG-IP Floating Self IP Address    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    name=${self_ip_name}    address=${self_ip_address}    partition=${self_ip_partition}    vlan=${self_ip_vlan}    allow-service=${self_ip_allow_service}
#        Verify BIG-IP Floating Self IP Address    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    name=${self_ip_name}    address=${self_ip_address}    partition=${self_ip_partition}
#     END

Create Default Static Routes on the BIG-IP
    [Documentation]  Creates default static routes on the BIG-IP
    set log level  trace
    ${PRIMARY_STATIC_DEFAULT_ROUTE}    to json    ${PRIMARY_STATIC_DEFAULT_ROUTE}
    ${route_partition}    get from dictionary    ${PRIMARY_STATIC_DEFAULT_ROUTE}    partition
    ${route_gateway}    get from dictionary    ${PRIMARY_STATIC_DEFAULT_ROUTE}    gw
    ${route_description}    get from dictionary    ${PRIMARY_STATIC_DEFAULT_ROUTE}    description
    Create Static Default Route Configuration on the BIG-IP    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    partition=${route_partition}    gateway=${route_gateway}    description=${route_description}
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    ${SECONDARY_STATIC_DEFAULT_ROUTE}    to json    ${SECONDARY_STATIC_DEFAULT_ROUTE}
    ${route_partition}    get from dictionary    ${SECONDARY_STATIC_DEFAULT_ROUTE}    partition
    ${route_gateway}    get from dictionary    ${SECONDARY_STATIC_DEFAULT_ROUTE}    gw
    ${route_description}    get from dictionary    ${SECONDARY_STATIC_DEFAULT_ROUTE}    description
    Create Static Default Route Configuration on the BIG-IP    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    partition=${route_partition}    gateway=${route_gateway}    description=${route_description}

