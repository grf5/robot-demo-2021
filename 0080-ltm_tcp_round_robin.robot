*** Settings ***
Documentation    This tests the configuration and operation of LTM TCP load balancing on the BIG-IP
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
${TCP_ROUND_ROBIN_VIP_NAME}             %{TCP_ROUND_ROBIN_VIP_NAME}
${TCP_ROUND_ROBIN_VIP_ADDRESS}          %{TCP_ROUND_ROBIN_VIP_ADDRESS}
${TCP_ROUND_ROBIN_VIP_MASK}             %{TCP_ROUND_ROBIN_VIP_MASK}
${TCP_ROUND_ROBIN_VIP_PORT}             %{TCP_ROUND_ROBIN_VIP_PORT}
${TCP_ROUND_ROBIN_VIP_PROTOCOL}         %{TCP_ROUND_ROBIN_VIP_PROTOCOL}
${TCP_ROUND_ROBIN_VIP_SNAT_TYPE}        %{TCP_ROUND_ROBIN_VIP_SNAT_TYPE}
${TCP_ROUND_ROBIN_POOL_NAME}            %{TCP_ROUND_ROBIN_POOL_NAME}
${TCP_ROUND_ROBIN_POOL_MEMBERS}         %{TCP_ROUND_ROBIN_POOL_MEMBERS}
${TCP_ROUND_ROBIN_POOL_MONITOR}         %{TCP_ROUND_ROBIN_POOL_MONITOR}
${DSC_GROUP_NAME}                       %{DSC_GROUP_NAME}

*** Test Cases ***
Perform BIG-IP Quick Check
    [Documentation]    Verifies that key BIG-IP services are in a ready state
    set log level    trace
    Wait until Keyword Succeeds    12x    15 seconds    Verify All BIG-IP Ready States    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}
    Wait until Keyword Succeeds    12x    15 seconds    Check for BIG-IP Services Waiting to Restart    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    Wait until Keyword Succeeds    12x    15 seconds    Verify All BIG-IP Ready States    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}
    Wait until Keyword Succeeds    12x    15 seconds    Check for BIG-IP Services Waiting to Restart    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}

Create TCP DNS Round-Robin Test Pool
    [Documentation]    Creates the pool object for the back-end pool members
    set log level    trace
    Create an LTM Pool    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    name=${TCP_ROUND_ROBIN_POOL_NAME}    monitor=${TCP_ROUND_ROBIN_POOL_MONITOR}
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    Create an LTM Pool    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    name=${TCP_ROUND_ROBIN_POOL_NAME}    monitor=${TCP_ROUND_ROBIN_POOL_MONITOR}

Verify TCP DNS Round-Robin Test Pool
    [Documentation]    Verifies the existence and configuration of the pool object
    set log level    trace
    Verify an LTM Pool    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    name=${TCP_ROUND_ROBIN_POOL_NAME}    monitor=${TCP_ROUND_ROBIN_POOL_MONITOR}
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    Verify an LTM Pool    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    name=${TCP_ROUND_ROBIN_POOL_NAME}    monitor=${TCP_ROUND_ROBIN_POOL_MONITOR}

Add the TCP DNS Round-Robin Test Nodes to Pool
    [Documentation]    Populates the pool object with the pool members (also referred to as nodes or back-end servers)
    set log level    trace
    ${TCP_ROUND_ROBIN_POOL_MEMBERS}    to json    ${TCP_ROUND_ROBIN_POOL_MEMBERS}
    FOR    ${current_pool_member}    IN    @{TCP_ROUND_ROBIN_POOL_MEMBERS}
       ${pool_member_name}    Get From Dictionary    ${current_pool_member}    address
       ${pool_member_address}    Get From Dictionary    ${current_pool_member}    address
       ${pool_member_port}    Get From Dictionary    ${current_pool_member}    port
       Add an LTM Pool Member to a Pool    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    pool_name=${TCP_ROUND_ROBIN_POOL_NAME}    pool_member_name=${pool_member_name}    port=${pool_member_port}    address=${pool_member_address}
       Verify an LTM Pool Member    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    pool_name=${TCP_ROUND_ROBIN_POOL_NAME}    pool_member_name=${pool_member_name}    port=${pool_member_port}    address=${pool_member_address}
    END
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    FOR    ${current_pool_member}    IN    @{TCP_ROUND_ROBIN_POOL_MEMBERS}
       ${pool_member_name}    Get From Dictionary    ${current_pool_member}    address
       ${pool_member_address}    Get From Dictionary    ${current_pool_member}    address
       ${pool_member_port}    Get From Dictionary    ${current_pool_member}    port
       Add an LTM Pool Member to a Pool    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    pool_name=${TCP_ROUND_ROBIN_POOL_NAME}    pool_member_name=${pool_member_name}    port=${pool_member_port}    address=${pool_member_address}
       Verify an LTM Pool Member    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    pool_name=${TCP_ROUND_ROBIN_POOL_NAME}    pool_member_name=${pool_member_name}    port=${pool_member_port}    address=${pool_member_address}
    END

Create TCP DNS Round-Robin Virtual Server
    [Documentation]    Creates a virtual server object that listens for traffic and forwards to the appropriate pool/next-hop
    set log level    trace
    Create an LTM FastL4 Virtual Server    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    name=${TCP_ROUND_ROBIN_VIP_NAME}   destination=${TCP_ROUND_ROBIN_VIP_ADDRESS}:${TCP_ROUND_ROBIN_VIP_PORT}  pool=${TCP_ROUND_ROBIN_POOL_NAME}   ipProtocol=${TCP_ROUND_ROBIN_VIP_PROTOCOL}    mask=${TCP_ROUND_ROBIN_VIP_MASK}    sourceAddressTranslation_type=${TCP_ROUND_ROBIN_VIP_SNAT_TYPE}    sourceAddressTranslation_pool=none    translateAddress=enabled    translatePort=enabled
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    Create an LTM FastL4 Virtual Server    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    name=${TCP_ROUND_ROBIN_VIP_NAME}   destination=${TCP_ROUND_ROBIN_VIP_ADDRESS}:${TCP_ROUND_ROBIN_VIP_PORT}  pool=${TCP_ROUND_ROBIN_POOL_NAME}   ipProtocol=${TCP_ROUND_ROBIN_VIP_PROTOCOL}    mask=${TCP_ROUND_ROBIN_VIP_MASK}    sourceAddressTranslation_type=${TCP_ROUND_ROBIN_VIP_SNAT_TYPE}    sourceAddressTranslation_pool=none    translateAddress=enabled    translatePort=enabled

Verify TCP DNS Round-Robin Virtual Server
    [Documentation]    Verifies the existence and configuration of a virtual server
    set log level    trace
    Verify an LTM FastL4 Virtual Server    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    name=${TCP_ROUND_ROBIN_VIP_NAME}   destination=${TCP_ROUND_ROBIN_VIP_ADDRESS}:${TCP_ROUND_ROBIN_VIP_PORT}  pool=${TCP_ROUND_ROBIN_POOL_NAME}   ipProtocol=${TCP_ROUND_ROBIN_VIP_PROTOCOL}    mask=${TCP_ROUND_ROBIN_VIP_MASK}    sourceAddressTranslation_type=${TCP_ROUND_ROBIN_VIP_SNAT_TYPE}    sourceAddressTranslation_pool=none    translateAddress=enabled    translatePort=enabled
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    Verify an LTM FastL4 Virtual Server    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    name=${TCP_ROUND_ROBIN_VIP_NAME}   destination=${TCP_ROUND_ROBIN_VIP_ADDRESS}:${TCP_ROUND_ROBIN_VIP_PORT}  pool=${TCP_ROUND_ROBIN_POOL_NAME}   ipProtocol=${TCP_ROUND_ROBIN_VIP_PROTOCOL}    mask=${TCP_ROUND_ROBIN_VIP_MASK}    sourceAddressTranslation_type=${TCP_ROUND_ROBIN_VIP_SNAT_TYPE}    sourceAddressTranslation_pool=none    translateAddress=enabled    translatePort=enabled

Set the VIP to advertise itself
    [Documentation]    Configures the virtual address (listening address/destination address) to be announced via BGP
    set log level    trace
    Configure Route Health Injection on a Virtual Address    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    address=${TCP_ROUND_ROBIN_VIP_ADDRESS}    route-advertisement=always 
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'    
    Configure Route Health Injection on a Virtual Address    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    address=${TCP_ROUND_ROBIN_VIP_ADDRESS}    route-advertisement=always

Force a Configuration Sync
    [Documentation]    Forces the BIG-IPs to resynchronize the shared configuration items via config-sync (part of HA)
    set log level    trace
    Manually Sync BIG-IP Configurations    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    cm_device_group_name=${DSC_GROUP_NAME}
    sleep    10s
    Manually Sync BIG-IP Configurations    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    cm_device_group_name=${DSC_GROUP_NAME}

Wait for the Configuration Sync to finish
    [Documentation]    Verifies that the cluster management sync "LED Color" is green, meaning sync is successful
    set log level    trace
    wait until keyword succeeds    1 min    5 sec    Verify CM Sync LED Color is Green    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}       
    wait until keyword succeeds    1 min    5 sec    Verify CM Sync LED Color is Green    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}       

Verify the Sync Status before proceeding
    [Documentation]    Verifies that the configuration is synced between the BIG-IPs as part of the clustering/HA
    set log level    trace
    Verify Trust Sync Status 13.1.1.4        bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}
    Verify Trust Sync Status 13.1.1.4        bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}

Verify Devices are "In Sync"
    [Documentation]    Verifies that the configuration is synced between the BIG-IPs as part of the clustering/HA
    set log level    trace
    ${primary_sync_status}    Retrieve CM Sync Status    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    
    should be equal as strings    '${primary_sync_status}'    'In Sync'    
    ${secondary_sync_status}    Retrieve CM Sync Status    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    
    should be equal as strings    '${secondary_sync_status}'    'In Sync'    

Set the Primary BIG-IP to Active on the default traffic-group
    [Documentation]    Sets the primary BIG-IP to the active unit in an HA pair
    set log level    trace
    Send a BIG-IP to Standby    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}

Verify that the Primary BIG-IP is Active on the default traffic-group 
    [Documentation]    Verify that the primary unit was set to active in the HA pair
    set log level    trace
    ${primary_failover_state}    Retrieve the HA Status of a Traffic-Group Member    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    cm_device_name=${PRIMARY_HOSTNAME}
    should be equal as strings    ${primary_failover_state}    active
    ${secondary_failover_state}    Retrieve the HA Status of a Traffic-Group Member    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    cm_device_name=${SECONDARY_HOSTNAME}
    should be equal as strings    ${secondary_failover_state}    standby

Reset Statistics on the BIG-IP
    [Documentation]    Resets all interface, virtual, pool, node, etc statistics on the BIG-IP
    set log level    trace
    Reset All Statistics        bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    Reset All Statistics        bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}

Run Traffic Test
    [Documentation]    Run a traffic generator test here
    log    "No traffic generator configured"

Retrieve Statistics for all BIG-IP Virtual Servers
    [Documentation]    Retrieves the current statistics for all configured virtual servers
    set log level    trace
    Retrieve All LTM Virtual Servers Statistics    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    Retrieve All LTM Virtual Servers Statistics    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    

Show Statistics for TCP DNS Round-Robin Virtual Server
    [Documentation]    Records the statistics for the virtual server intended for the test
    set log level    trace
    Retrieve LTM Virtual Server Statistics    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    name=${TCP_ROUND_ROBIN_VIP_NAME}
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    Retrieve LTM Virtual Server Statistics    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    name=${TCP_ROUND_ROBIN_VIP_NAME}

Show Statistics for TCP DNS Round-Robin Pool
    [Documentation]    Records the statistics for the server pool created for the test
    set log level    trace
    Retrieve LTM Pool Statistics    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    name=${TCP_ROUND_ROBIN_POOL_NAME}
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    Retrieve LTM Pool Statistics    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    name=${TCP_ROUND_ROBIN_POOL_NAME}

Show Statistics for TCP DNS Round-Robin Pool Members
    [Documentation]    Records the statistics for the server pool members created for the test
    set log level    trace
    Retrieve LTM Pool Member Statistics    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    pool_name=${TCP_ROUND_ROBIN_POOL_NAME}
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    Retrieve LTM Pool Member Statistics    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    pool_name=${TCP_ROUND_ROBIN_POOL_NAME}

Check BIG-IP for Interface Drops
    [Tags]    non_critical
    [Documentation]    Checks for interface drops (See https://support.f5.com/csp/article/K10191)
    set log level    trace
    Verify Interface Drop Counters on the BIG-IP    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    interface_drops_threshold=0.01
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    Verify Interface Drop Counters on the BIG-IP    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    interface_drops_threshold=0.01

Check BIG-IP for Interface Errors
    [Tags]    non_critical
    [Documentation]    Checks each interface on the BIG-IP for interface errors and errors if any are found
    set log level    trace
    Verify Interface Error Counters on the BIG-IP    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    Verify Interface Error Counters on the BIG-IP    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}
