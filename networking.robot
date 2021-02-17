
*** Settings ***
Documentation    This suite tests aspects of the networking configuration
Resource    robotframework-f5-tmos.robot
Resource    robotframework-f5-zebos.robot

*** Variables ***
${PRIMARY_HOSTNAME}                     %{PRIMARY_HOSTNAME}
${PRIMARY_MGMT_IP}                      %{PRIMARY_MGMT_IP}
${PRIMARY_HTTP_USERNAME}                %{PRIMARY_HTTP_USERNAME}
${PRIMARY_HTTP_PASSWORD}                %{PRIMARY_HTTP_PASSWORD}
${SECONDARY_HOSTNAME}                   %{SECONDARY_HOSTNAME}
${SECONDARY_MGMT_IP}                    %{SECONDARY_MGMT_IP}
${SECONDARY_HTTP_USERNAME}              %{SECONDARY_HTTP_USERNAME}
${SECONDARY_HTTP_PASSWORD}              %{SECONDARY_HTTP_PASSWORD}
${DSC_GROUP_NAME}                       %{DSC_GROUP_NAME}

*** Test Cases ***

Test Static Routing
  [Documentation]  Remove default Gateway from device configuration. Choose the IP address or subnet that is not reachable from device. Create Static route towards chosen IP. Test that the connection can be established. Remove the route and check that the destination is unreachable. 
  set log level  trace
  Display BIG-IP Static Route Configuration   bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}
  ${default_route}    To Json    ${PRIMARY_STATIC_DEFAULT_ROUTE}
  ${default_gateway}    get from dictionary    ${default_route}    gw
  wait until keyword succeeds    4x    15 seconds    Ping Host from BIG-IP    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    host=${default_gateway}
  Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
  Display BIG-IP Static Route Configuration   bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}
  ${default_route}    To Json    ${SECONDARY_STATIC_DEFAULT_ROUTE}
  ${default_gateway}    get from dictionary    ${default_route}    gw
  wait until keyword succeeds    4x    15 seconds    Ping Host from BIG-IP    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    host=${default_gateway}

Test BGP support IPv4 and IPv6
  [Documentation]  BGP and IP anycast IPv4 - Configure the appliance with BGP used for anycast address advertisement, as well as the corresponding configuration on the attached or upstream router. Configuration and peering - Validate successful routing neighbor/peer negotiation between the appliance and upstream router.
  set log level  trace

Route Health injection BGP
  [Documentation]  Configure device to dynamically advertise and remove VIPs from routing using BGP. Demonstrate the ability to change BGP timer settings.
  set log level  trace

Verify that the TMOS versions match between nodes
    [Documentation]  Clustering requires that the TMOS versions are the same during intial configuration
    set log level  trace
    ${primary_tmos_version}    Retrieve TMOS Version    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}
    Set Global Variable    ${primary_tmos_version}
    ${primary_tmos_build}    Retrieve TMOS Build    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}
    Set Global Variable    ${primary_tmos_build}
    ${secondary_tmos_version}    Retrieve TMOS Version    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}
    Set Global Variable    ${secondary_tmos_version}
    ${secondary_tmos_build}    Retrieve TMOS Build    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}
    Set Global Variable    ${secondary_tmos_build}
    Should be Equal as Strings    ${primary_tmos_version}    ${secondary_tmos_version}
    Should be Equal as Strings    ${primary_tmos_build}    ${secondary_tmos_build}

Move the CM Device to the Actual Hostname
    [Documentation]  Renames the local device to match the hostname in the clustering configuration
    set log level  trace
    ${primary_configured_cm_name}    Retrieve BIG-IP CM Name    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}
    Move CM Device to New Hostname    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    current_name=${primary_configured_cm_name}    target=${PRIMARY_HOSTNAME}
    ${secondary_configured_cm_name}    Retrieve BIG-IP CM Name    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}
    Move CM Device to New Hostname    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    current_name=${secondary_configured_cm_name}    target=${SECONDARY_HOSTNAME}

Set the CM Device Unicast Address
    [Documentation]  Configures the unicast IP address that the CM peers use for HA communications
    set log level  trace
    Configure CM Device Unicast Address    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    device_name=${PRIMARY_HOSTNAME}    unicast_address=${PRIMARY_HA_IP_ADDRESS}
    Configure CM Device Unicast Address    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    device_name=${SECONDARY_HOSTNAME}    unicast_address=${SECONDARY_HA_IP_ADDRESS}

Set the CM Device Mirror IP
    [Documentation]  Configures the unicast IP address that the CM peers use for connection/session mirroring
    set log level  trace
    Configure CM Device Mirror IP    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    device_name=${PRIMARY_HOSTNAME}    mirror_ip=${PRIMARY_HA_IP_ADDRESS}
    Configure CM Device Mirror IP    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    device_name=${SECONDARY_HOSTNAME}    mirror_ip=${SECONDARY_HA_IP_ADDRESS}

Set the CM Device Configsync IP
    [Documentation]  Configures the unicast IP address that the CM peers use to sync configuration changes
    set log level  trace
    Configure CM Device Configsync IP        bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    device_name=${PRIMARY_HOSTNAME}    configsync_ip=${PRIMARY_HA_IP_ADDRESS}
    Configure CM Device Configsync IP        bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    device_name=${SECONDARY_HOSTNAME}    configsync_ip=${SECONDARY_HA_IP_ADDRESS}

Verify that the CM device has been configured from default
    [Documentation]  Verifies that the CM device name has changed so we can ensure that CM configuration changes are taking effect
    set log level  trace
    ${primary_configured_cm_name}    Retrieve BIG-IP CM Name    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}
    ${secondary_configured_cm_name}    Retrieve BIG-IP CM Name    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}
    Should Not be Equal as Strings    ${primary_configured_cm_name}    bigip1
    Should Not be Equal as Strings    ${secondary_configured_cm_name}    bigip1

Verify NTP is configured
    [Documentation]  Verifies that NTP servers are configured on the BIG-IPs
    set log level  trace
    Query NTP Server List    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}
    Query NTP Server List    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}

Verify host clocks are in sync
    [Documentation]  Verifies that NTP server associations are in place and the clocks are set to the same time
    set log level  trace
    Wait until Keyword Succeeds    6x    10 seconds    Verify NTP Server Associations    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}
    Wait until Keyword Succeeds    6x    10 seconds    Verify NTP Server Associations    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}

Ensure Devices are Standalone
    [Documentation]  Ensuring that devices are not currently configured for HA/clustering with other peers
    set log level  trace
    ${primary_sync_mode}    Retrieve CM Sync Mode    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    
    should be equal as strings    '${primary_sync_mode}'    'standalone'
    ${secondary_sync_mode}    Retrieve CM Sync Mode    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    
    should be equal as strings    '${secondary_sync_mode}'    'standalone'

Ensure Devices are "Green"
    [Documentation]  Verifies that the cluster management sync "LED Color" is green, meaning sync is successful
    set log level  trace
    ${primary_sync_color}    Retrieve CM Sync LED Color    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    
    should be equal as strings    '${primary_sync_color}'    'green'    
    ${secondary_sync_color}    Retrieve CM Sync LED Color    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    
    should be equal as strings    '${secondary_sync_color}'    'green'    

Add the secondary to the primary as a peer
    [Documentation]  Adds the secondary device to the primary as a peer and establishes trust; the exchange will be mutual so no need to do the same in reverse order
    set log level  trace
    ${secondary_configured_cm_name}    Retrieve BIG-IP CM Name    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}
    Add Device to CM Trust    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    peer_bigip_host=${SECONDARY_MGMT_IP}    peer_bigip_cm_name=${secondary_configured_cm_name}    peer_bigip_username=${SECONDARY_HTTP_USERNAME}    peer_bigip_password=${SECONDARY_HTTP_PASSWORD}

Verify that the devices are now in sync-only mode
    [Documentation]  Verifies that the devices are in sync-only mode and not yet configured for traffic failover
    set log level  trace
    ${primary_sync_mode}    Retrieve CM Sync Mode    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    
    should be equal as strings    '${primary_sync_mode}'    'trust-only'
    ${secondary_sync_mode}    Retrieve CM Sync Mode    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    
    should be equal as strings    '${secondary_sync_mode}'    'trust-only'

Wait for the devices to finish building the trust
    [Documentation]  Verifies that the cluster management sync "LED Color" is green, meaning sync is successful
    set log level  trace
    wait until keyword succeeds    2 min    5 sec    Verify CM Sync LED Color is Green    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}       
    wait until keyword succeeds    2 min    5 sec    Verify CM Sync LED Color is Green    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}       

Verify Devices are "Green" after creating trust
    [Documentation]  Verifies that the cluster management sync "LED Color" is green, meaning sync is successful
    set log level  trace
    ${primary_sync_color}    Retrieve CM Sync LED Color    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    
    should be equal as strings    '${primary_sync_color}'    'green'    
    ${secondary_sync_color}    Retrieve CM Sync LED Color    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    
    should be equal as strings    '${secondary_sync_color}'    'green'    

Verify Devices are "In Sync" after creating trust
    [Documentation]  Verifies that the configuration is synced between the BIG-IPs as part of the clustering/HA
    set log level  trace
    ${primary_sync_status}    Retrieve CM Sync Status    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    
    should be equal as strings    '${primary_sync_status}'    'In Sync'    
    ${secondary_sync_status}    Retrieve CM Sync Status    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    
    should be equal as strings    '${secondary_sync_status}'    'In Sync'    

Verify status of members
    [Documentation]  Verifies the status of the device trust; this simply means that the peers have exchanged certificates successfully
    set log level  trace
    Run Keyword If    '${primary_tmos_version}' == '12.0'    Wait until Keyword Succeeds    6x    5 seconds    Verify Trust Sync Status 12.0    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}
    Run Keyword If    '${primary_tmos_version}' == '12.0'    Wait until Keyword Succeeds    6x    5 seconds    Verify Trust Sync Status 12.0    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}
    Run Keyword If    '${primary_tmos_version}' == '12.1'    Wait until Keyword Succeeds    6x    5 seconds    Verify Trust Sync Status 12.1    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}
    Run Keyword If    '${primary_tmos_version}' == '12.1'    Wait until Keyword Succeeds    6x    5 seconds    Verify Trust Sync Status 12.1    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}
    Run Keyword If    '${primary_tmos_version}' == '13.0'    Wait until Keyword Succeeds    6x    5 seconds    Verify Trust Sync Status 13.0    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}
    Run Keyword If    '${primary_tmos_version}' == '13.0'    Wait until Keyword Succeeds    6x    5 seconds    Verify Trust Sync Status 13.0    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}
    Run Keyword If    '${primary_tmos_version}' == '13.1.1.4'    Wait until Keyword Succeeds    6x    5 seconds    Verify Trust Sync Status 13.1.1.4    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}
    Run Keyword If    '${primary_tmos_version}' == '13.1.1.4'    Wait until Keyword Succeeds    6x    5 seconds    Verify Trust Sync Status 13.1.1.4    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}

Create the device group
    [Documentation]  Creates a group object to which cluster members will be assigned
    set log level  trace
    Create CM Device Group    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    cm_device_group_name=${DSC_GROUP_NAME}

Wait for the device group configuration to propogate
    [Documentation]  Verifies that the cluster management sync "LED Color" is green, meaning sync is successful
    set log level  trace
    wait until keyword succeeds    1 min    5 sec    Verify CM Sync LED Color is Green    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}       
    wait until keyword succeeds    1 min    5 sec    Verify CM Sync LED Color is Green    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}       

Verify Devices are "In Sync" after creating device group
    [Documentation]  Verifies that the configuration is synced between the BIG-IPs as part of the clustering/HA
    set log level  trace
    ${primary_sync_status}    Retrieve CM Sync Status    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    
    should be equal as strings    '${primary_sync_status}'    'In Sync'    
    ${secondary_sync_status}    Retrieve CM Sync Status    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    
    should be equal as strings    '${secondary_sync_status}'    'In Sync'    

Verify that the devices are still in trust-only mode after creating device group
    [Documentation]  Verifies that the configuration is synced between the BIG-IPs as part of the clustering/HA
    set log level  trace
    ${primary_sync_mode}    Retrieve CM Sync Mode    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    
    should be equal as strings    '${primary_sync_mode}'    'trust-only'
    ${secondary_sync_mode}    Retrieve CM Sync Mode    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    
    should be equal as strings    '${secondary_sync_mode}'    'trust-only'

Add both devices to the device group
    [Documentation]  Adds both the primary and standby unit the newly created device group
    set log level  trace
    Add Device to CM Device Group    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    cm_device_group_name=${DSC_GROUP_NAME}    cm_device_name=${PRIMARY_HOSTNAME}
    Add Device to CM Device Group    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    cm_device_group_name=${DSC_GROUP_NAME}    cm_device_name=${SECONDARY_HOSTNAME}
    sleep    10s    reason=let both devices fully discover each other

Wait for the devices to accept device group configuration
    [Documentation]  Verifies that the cluster management sync "LED Color" is green, meaning sync is successful
    set log level  trace
    wait until keyword succeeds    1 min    5 sec    Verify CM Sync LED Color is Blue    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}       
    wait until keyword succeeds    1 min    5 sec    Verify CM Sync LED Color is Blue    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}       

Verify that the devices are now in high-availability mode
    [Documentation]  Verifies that the devices are configured for high-availability mode
    set log level  trace
    ${primary_sync_mode}    Retrieve CM Sync Mode    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    
    should be equal as strings    '${primary_sync_mode}'    'high-availability'
    ${secondary_sync_mode}    Retrieve CM Sync Mode    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    
    should be equal as strings    '${secondary_sync_mode}'    'high-availability'

Verify Devices are "Awaiting Initial Sync" after adding to device group
    [Documentation]  Verifies that both members are clustered and ready for the initial synchronization of configurations
    set log level  trace
    ${primary_sync_status}    Retrieve CM Sync Status    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    
    should be equal as strings    '${primary_sync_status}'    'Awaiting Initial Sync'    
    ${secondary_sync_status}    Retrieve CM Sync Status    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    
    should be equal as strings    '${secondary_sync_status}'    'Awaiting Initial Sync'    

Save the config on each device
    [Documentation]  Saves the configuration to disk on each BIG-IP
    set log level  trace
    Save the BIG-IP Configuration    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}
    Save the BIG-IP Configuration    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}

Force the initial sync
    [Documentation]  Forces the BIG-IPs to resynchronize the shared configuration items via config-sync (part of HA)
    set log level  trace
    Manually Sync BIG-IP Configurations    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    cm_device_group_name=${DSC_GROUP_NAME}

Wait for the initial configuration sync to complete
    [Documentation]  Verifies that the cluster management sync "LED Color" is green, meaning sync is successful
    set log level  trace
    wait until keyword succeeds    1 min    5 sec    Verify CM Sync LED Color is Green    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}       
    wait until keyword succeeds    1 min    5 sec    Verify CM Sync LED Color is Green    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}       

Verify Devices are "In Sync" after initial config sync
    [Documentation]  Verifies that the configuration is synced between the BIG-IPs as part of the clustering/HA
    set log level  trace
    ${primary_sync_status}    Retrieve CM Sync Status    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    
    should be equal as strings    '${primary_sync_status}'    'In Sync'    
    ${secondary_sync_status}    Retrieve CM Sync Status    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    
    should be equal as strings    '${secondary_sync_status}'    'In Sync'    

Verify that the devices are still in high-availability mode after initial config sync
    [Documentation]  Verifies that the configuration is synced between the BIG-IPs as part of the clustering/HA
    set log level  trace
    ${primary_sync_mode}    Retrieve CM Sync Mode    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    
    should be equal as strings    '${primary_sync_mode}'    'high-availability'
    ${secondary_sync_mode}    Retrieve CM Sync Mode    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    
    should be equal as strings    '${secondary_sync_mode}'    'high-availability'

AnyCast Failover Test
  [Documentation]  Anycast IP advertised from both GTMs, removed prefix from primary while dnsperf and ping towards DUT is running 
  set log level  trace
