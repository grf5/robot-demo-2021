*** Keywords ***

########
## BGP
########

Run BGP Commands on BIG-IP
    [Documentation]  Generic handler for command separate list of BGP commands on the BIG-IP (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/big-ip-dynamic-routing-with-tmsh-and-icontrol-rest-14-0-0.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${commands}    ${route_domain_id}
    ${api_payload}    create dictionary    command=run    utilCmdArgs=-c "zebos -r ${route_domain_id} cmd terminal length 0,${commands}"
    ${api_uri}    set variable    /mgmt/tm/util/bash
    ${api_response}    BIG-IP iControl BasicAuth POST    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Create BGP IPv4 Neighbor
    [Documentation]  Creates a BGP IPv4 Neighbor on the BIG-IP (https://techdocs.f5.com/content/kb/en-us/products/big-ip_ltm/manuals/related/bgp-commandreference-7-10-4/_jcr_content/pdfAttach/download/file.res/arm-bgp-commandreference-7-10-4.pdf)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${bgp_peer_ip}   ${remote_as_number}    ${route_domain_id}=0
    ${bgp_commands}    set variable    configure terminal,router bgp ${local_as_number},neighbor ${bgp_peer_ip} remote-as ${remote_as_number},end,copy running-config startup-config
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    [Return]    ${api_response}

Create BGP IPv6 Neighbor
    [Documentation]  Creates a BGP IPv6 neighbor on the BIG-IP (https://techdocs.f5.com/content/kb/en-us/products/big-ip_ltm/manuals/related/bgp-commandreference-7-10-4/_jcr_content/pdfAttach/download/file.res/arm-bgp-commandreference-7-10-4.pdf)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${bgp_peer_ip}    ${remote_as_number}    ${route_domain_id}=0
    ${bgp_commands}    set variable    configure terminal,router bgp ${local_as_number},neighbor ${bgp_peer_ip} remote-as ${remote_as_number},end,copy running-config startup-config
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    [Return]    ${api_response}

Create BGP IPv4 Neighbor using Peer-Group
    [Documentation]  Creates a BGP IPv4 Neighbor on the BIG-IP (https://techdocs.f5.com/content/kb/en-us/products/big-ip_ltm/manuals/related/bgp-commandreference-7-10-4/_jcr_content/pdfAttach/download/file.res/arm-bgp-commandreference-7-10-4.pdf)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${bgp_peer_ip}   ${peer_group_name}    ${route_domain_id}=0
    ${bgp_commands}    set variable    configure terminal,router bgp ${local_as_number},neighbor ${bgp_peer_ip} peer-group ${peer_group_name},end,copy running-config startup-config
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    [Return]    ${api_response}

Verify BGP IPv4 Neighbor using Peer-Group
    [Documentation]  Creates a BGP IPv4 Neighbor on the BIG-IP (https://techdocs.f5.com/content/kb/en-us/products/big-ip_ltm/manuals/related/bgp-commandreference-7-10-4/_jcr_content/pdfAttach/download/file.res/arm-bgp-commandreference-7-10-4.pdf)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${bgp_peer_ip}   ${peer_group_name}    ${route_domain_id}=0
    ${bgp_commands}    set variable    configure terminal,router bgp ${local_as_number},neighbor ${bgp_peer_ip} peer-group ${peer_group_name},end,copy running-config startup-config
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    [Return]    ${api_response}

Create BGP IPv6 Neighbor using Peer-Group
    [Documentation]  Creates a BGP IPv6 neighbor on the BIG-IP (https://techdocs.f5.com/content/kb/en-us/products/big-ip_ltm/manuals/related/bgp-commandreference-7-10-4/_jcr_content/pdfAttach/download/file.res/arm-bgp-commandreference-7-10-4.pdf)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${bgp_peer_ip}    ${peer_group_name}    ${route_domain_id}=0
    ${bgp_commands}    set variable    configure terminal,router bgp ${local_as_number},neighbor ${bgp_peer_ip} peer-group ${peer_group_name},end,copy running-config startup-config
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    [Return]    ${api_response}

Verify BGP IPv6 Neighbor using Peer-Group
    [Documentation]  Verifies a BGP IPv6 neighbor on the BIG-IP (https://techdocs.f5.com/content/kb/en-us/products/big-ip_ltm/manuals/related/bgp-commandreference-7-10-4/_jcr_content/pdfAttach/download/file.res/arm-bgp-commandreference-7-10-4.pdf)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${bgp_peer_ip}    ${peer_group_name}    ${route_domain_id}=0
    ${bgp_as_configuration}    Retrieve BGP AS Global Configuration    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    local_as_number=${local_as_number}    route_domain_id=${route_domain_id}
    should contain    ${bgp_as_configuration}    neighbor ${bgp_peer_ip} peer-group ${peer_group_name}
    [Return]    ${bgp_as_configuration}

Create BGP IPv4 Network Advertisement
    [Documentation]  Creates a IPv4 network statement on the BIG-IP (https://techdocs.f5.com/content/kb/en-us/products/big-ip_ltm/manuals/related/bgp-commandreference-7-10-4/_jcr_content/pdfAttach/download/file.res/arm-bgp-commandreference-7-10-4.pdf)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${ipv4_prefix}    ${ipv4_mask}    ${route_domain_id}=0
    ${bgp_commands}    set variable    configure terminal,router bgp ${local_as_number},network ${ipv4_prefix} mask ${ipv4_mask},end,copy running-config startup-config
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    [Return]    ${api_response}

Create BGP IPv6 Network Advertisement
    [Documentation]  Creates an IPv6 address-family network statement on the BIG-IP (https://techdocs.f5.com/content/kb/en-us/products/big-ip_ltm/manuals/related/bgp-commandreference-7-10-4/_jcr_content/pdfAttach/download/file.res/arm-bgp-commandreference-7-10-4.pdf)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${ipv6_cidr}    ${route_domain_id}=0
    ${bgp_commands}    set variable    configure terminal,router bgp ${local_as_number},address-family ipv6,network ${ipv6_cidr},end,copy running-config startup-config
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    [Return]    ${api_response}

Disable BGP Default IPv4 Unicast
    [Documentation]  Disables IPv4 Unicast Default Advertising
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${route_domain_id}=0
    ${bgp_commands}    set variable    configure terminal,router bgp ${local_as_number},no bgp default ipv4-unicast,end,copy running-config startup-config
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    [Return]    ${api_response}

Verify Disabled BGP Default IPv4 Unicast
    [Documentation]  Verifies disabled IPv4 Unicast Default Advertising
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${route_domain_id}=0
    ${bgp_as_configuration}    Retrieve BGP AS Global Configuration    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    local_as_number=${local_as_number}    route_domain_id=${route_domain_id}
    should contain    ${bgp_as_configuration}    no bgp default ipv4-unicast
    [Return]    ${bgp_as_configuration}

Show Route Domain ZebOS Configuration
    [Documentation]  Lists the BGP configuration on a route-domain on the BIG-IP (defaults to RD 0) (https://techdocs.f5.com/content/kb/en-us/products/big-ip_ltm/manuals/related/bgp-commandreference-7-10-4/_jcr_content/pdfAttach/download/file.res/arm-bgp-commandreference-7-10-4.pdf)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${route_domain_id}=0
    ${bgp_commands}    set variable    show running-config
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    [Return]    ${api_response}

Show Route Domain BGP Status
    [Documentation]  Shows the BGP status on a \ on the BIG-IP (defaults to 0) (https://techdocs.f5.com/content/kb/en-us/products/big-ip_ltm/manuals/related/bgp-commandreference-7-10-4/_jcr_content/pdfAttach/download/file.res/arm-bgp-commandreference-7-10-4.pdf)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${route_domain_id}=0
    ${bgp_commands}    set variable    show ip bgp,show bgp,show bgp neighbors,show bgp ipv4 neighbors,show bgp ipv6 neighbors
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    ${bgp_status}    get from dictionary    ${api_response.json}    commandResult
    [Return]    ${bgp_status}

Retrieve BGP State for Peer
    [Documentation]  Verifies that BGP is established with a peer (https://techdocs.f5.com/content/kb/en-us/products/big-ip_ltm/manuals/related/bgp-commandreference-7-10-4/_jcr_content/pdfAttach/download/file.res/arm-bgp-commandreference-7-10-4.pdf)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${peer_address}    ${route_domain_id}=0
    ${bgp_commands}    set variable    show ip bgp neighbors ${peer_address}
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    ${bgp_state}       get from dictionary    ${api_response.json}    commandResult
    ${bgp_state}       fetch from right    ${bgp_state}    BGP state =${SPACE}
    ${bgp_state}       fetch from left    ${bgp_state}    ,
    [Return]    ${bgp_state}
    
Retrieve BGP Peer Advertised IPv4 Routes
    [Documentation]  Retrieves a list of advertised IPv4 routes on a BGP peer
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${peer_address}    ${route_domain_id}=0
    ${bgp_commands}    set variable    show ip bgp neighbors ${peer_address} advertised-routes
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    ${peer_adv_routes_raw}    get from dictionary    ${api_response.json}    commandResult
    ${peer_adv_routes_raw}    get regexp matches    ${peer_adv_routes_raw}    (?:[0-9]{1,3}\.){3}[0-9]{1,3}\/[0-9]{1,2}
    ${peer_adv_routes}    create list
    FOR   ${current_adv_route}   IN    @{peer_adv_routes_raw}
        ${current_adv_route_network}    fetch from left    ${current_adv_route}    /
        ${current_adv_route_mask}    fetch from right    ${current_adv_route}    /
        ${current_adv_route_mask}    evaluate    (0xffffffff >> (${32} - ${${current_adv_route_mask}})) << (${32} - ${${current_adv_route_mask}})
        ${current_adv_route_mask}    evaluate    (str((0xff000000 & ${current_adv_route_mask}) >> 24) + '.' + str((0x00ff0000 & ${current_adv_route_mask}) >> 16) + '.' + str((0x0000ff00 & ${current_adv_route_mask}) >> 8) + '.' + str((0x000000ff & ${current_adv_route_mask})))
        ${current_adv_route_dict}    create dictionary    prefix=${current_adv_route_network}    mask=${current_adv_route_mask}
        append to list    ${peer_adv_routes}    ${current_adv_route_dict}
    END
    [Return]    ${peer_adv_routes}

Retrieve BGP Peer Advertised IPv4 Routes in CIDR Format
    [Documentation]  Retrieves a list of advertised IPv4 routes on a BGP peer in CIDR format
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${peer_address}    ${route_domain_id}=0
    ${bgp_commands}    set variable    show ip bgp neighbors ${peer_address} advertised-routes
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    ${peer_adv_routes}    get from dictionary    ${api_response.json}    commandResult
    ${peer_adv_routes}    get regexp matches    ${peer_adv_routes}    (?:[0-9]{1,3}\.){3}[0-9]{1,3}\/[0-9]{1,2}
    [Return]    ${peer_adv_routes}
    
Retrieve BGP Peer Advertised IPv6 Routes
    [Documentation]  Retrieves a list of advertised IPv6 routes on a BGP peer
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${peer_address}    ${route_domain_id}=0
    ${bgp_commands}    set variable    show bgp ipv6 neighbors ${peer_address} advertised-routes
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    ${peer_adv_routes}    get from dictionary    ${api_response.json}    commandResult
    ${peer_adv_routes}    get regexp matches    ${peer_adv_routes}    (([0-9a-fA-F]{1,4}:){7,7}[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,7}:|([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}|([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}|([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}|([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}|[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})|:((:[0-9a-fA-F]{1,4}){1,7}|:)|fe80:(:[0-9a-fA-F]{0,4}){0,4}%[0-9a-zA-Z]{1,}|::(ffff(:0{1,4}){0,1}:){0,1}((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])|([0-9a-fA-F]{1,4}:){1,4}:((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9]))\/[0-9]{1,3}
    [Return]    ${peer_adv_routes}

Configure BGP Neighbor Description
    [Documentation]  Configures the description of a BGP neighbor
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${neighbor}    ${description}    ${route_domain_id}=0
    ${bgp_commands}    set variable    configure terminal,router bgp ${local_as_number},neighbor ${neighbor} description ${description},end,copy running-config startup-config
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    [Return]    ${api_response}

Verify BGP Neighbor Description
    [Documentation]  Verifies the description of a BGP neighbor
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${neighbor}    ${description}    ${route_domain_id}=0
    ${bgp_as_configuration}    Retrieve BGP AS Global Configuration    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    local_as_number=${local_as_number}    route_domain_id=${route_domain_id}
    should contain    ${bgp_as_configuration}    neighbor ${neighbor} description ${description}
    [Return]    ${bgp_as_configuration}
    
Enable ZebOS Logging
    [Documentation]  Enables local logging for the ZebOS daemon
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${route_domain_id}=0    ${log_file}=/var/log/zebos.log
    ${bgp_commands}    set variable    configure terminal,log file ${log_file},end,copy running-config startup-config
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    [Return]    ${api_response}

Verify ZebOS Logging Destination
    [Documentation]  Verifies the configured logging destination for ZebOS
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${route_domain_id}=0    ${log_file}=/var/log/zebos.log
    ${bgp_commands}    set variable    show running-config | grep -e "^ log file /"
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    ${log_file_configuration}    get from dictionary    ${api_response.json}    commandResult
    should contain    ${log_file_configuration}    log file ${log_file}
    [Return]    ${log_file_configuration}
    
Enable BGP Neighbor Change Logging
    [Documentation]  Enables BGP neighbor change logging
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${route_domain_id}=0
    ${bgp_commands}    set variable    configure terminal,router bgp ${local_as_number},bgp log-neighbor-changes,end,copy running-config startup-config
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    [Return]    ${api_response}

Verify BGP Neighbor Change Logging
    [Documentation]  Verifies that bgp log-neighbor-changes exists
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${route_domain_id}=0
    ${bgp_as_configuration}    Retrieve BGP AS Global Configuration    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    local_as_number=${local_as_number}    route_domain_id=${route_domain_id}
    should contain    ${bgp_as_configuration}    bgp log-neighbor-changes
    [Return]    ${bgp_as_configuration}

Configure the BGP Graceful Restart Timer
    [Documentation]  Sets the BGP Graceful Restart Timer
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${graceful_restart_timer}    ${route_domain_id}=0
    ${bgp_commands}    set variable    configure terminal,router bgp ${local_as_number},bgp graceful-restart restart-time ${graceful_restart_timer},end,copy running-config startup-config
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    [Return]    ${api_response}

Verify the BGP Graceful Restart Timer
    [Documentation]  Verifies the BGP graceful restart timer
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${graceful_restart_timer}    ${route_domain_id}=0
    ${bgp_as_configuration}    Retrieve BGP AS Global Configuration    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    local_as_number=${local_as_number}    route_domain_id=${route_domain_id}
    should contain    ${bgp_as_configuration}    bgp graceful-restart restart-time ${graceful_restart_timer}
    [Return]    ${bgp_as_configuration}

Configure IPv4 Kernel Route BGP Redistribution
    [Documentation]  Issues the 'redistribute kernel [route-map]' command
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${route_map}=none    ${route_domain_id}=0
    ${bgp_commands}    set variable if    '${route_map}' == 'none'    configure terminal,router bgp ${local_as_number},redistribute kernel,end,copy running-config startup-config    configure terminal,router bgp ${local_as_number},redistribute kernel route-map ${route_map},end,copy running-config startup-config
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    [Return]    ${api_response}

Verify IPv4 Kernel Route BGP Redistribution
    [Documentation]  Verifies the 'redistribute kernel [route-map]' command
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${route_map}=none    ${route_domain_id}=0
    ${bgp_as_configuration}    Retrieve BGP AS Global Configuration    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    local_as_number=${local_as_number}    route_domain_id=${route_domain_id}
    ${redistribute_configuration}    set variable if    '${route_map}' == 'none'    redistribute kernel    redistribute kernel route-map ${route_map}
    should contain    ${bgp_as_configuration}    ${redistribute_configuration}
    [Return]    ${redistribute_configuration}

Configure IPv4 Connected Route BGP Redistribution
    [Documentation]  Issues the 'redistribute connected [route-map]' command
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${route_map}=none    ${route_domain_id}=0
    ${bgp_commands}    set variable if    '${route_map}' == 'none'    configure terminal,router bgp ${local_as_number},redistribute connected,end,copy running-config startup-config    configure terminal,router bgp ${local_as_number},redistribute connected route-map ${route_map},end,copy running-config startup-config
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    [Return]    ${api_response}

Verify IPv4 Connected Route BGP Redistribution
    [Documentation]  Verifies the 'redistribute connected [route-map]' command
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${route_map}=none    ${route_domain_id}=0
    ${bgp_as_configuration}    Retrieve BGP AS Global Configuration    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    local_as_number=${local_as_number}    route_domain_id=${route_domain_id}
    ${redistribute_configuration}    set variable if    '${route_map}' == 'none'    redistribute connected    redistribute connected route-map ${route_map}
    should contain    ${bgp_as_configuration}    ${redistribute_configuration}
    [Return]    ${redistribute_configuration}

Configure IPv4 Static Route BGP Redistribution
    [Documentation]  Issues the 'redistribute static route-map' command
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${route_map}=none    ${route_domain_id}=0
    ${bgp_commands}    set variable if    '${route_map}' == 'none'    configure terminal,router bgp ${local_as_number},redistribute static,end,copy running-config startup-config    configure terminal,router bgp ${local_as_number},redistribute static route-map ${route_map},end,copy running-config startup-config
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    [Return]    ${api_response}

Verify IPv4 Static Route BGP Redistribution
    [Documentation]  Verifies the 'redistribute static [route-map]' command
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${route_map}=none    ${route_domain_id}=0
    ${bgp_as_configuration}    Retrieve BGP AS Global Configuration    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    local_as_number=${local_as_number}    route_domain_id=${route_domain_id}
    ${redistribute_configuration}    set variable if    '${route_map}' == 'none'    redistribute static    redistribute static route-map ${route_map}
    should contain    ${bgp_as_configuration}    ${redistribute_configuration}
    [Return]    ${redistribute_configuration}

Configure IPv6 Kernel Route BGP Redistribution
    [Documentation]  Issues the 'redistribute kernel route-map' command under the ipv6 address-family
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${route_map}=none    ${route_domain_id}=0
    ${bgp_commands}    set variable if    '${route_map}' == 'none'    configure terminal,router bgp ${local_as_number},address-family ipv6,redistribute kernel,end,copy running-config startup-config    configure terminal,router bgp ${local_as_number},address-family ipv6,redistribute kernel route-map ${route_map},end,copy running-config startup-config
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    [Return]    ${api_response}
 
Verify IPv6 Kernel Route BGP Redistribution
    [Documentation]  Verifies configuration of IPv6 Kernel route redistribution
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${route_map}=none    ${route_domain_id}=0
    ${bgp_as_configuration}    Retrieve BGP AS IPv6 Address-Family Configuration    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    local_as_number=${local_as_number}    route_domain_id=${route_domain_id}
    ${redistribute_configuration}    set variable if    '${route_map}' == 'none'    redistribute kernel    redistribute kernel route-map ${route_map}
    should contain    ${bgp_as_configuration}    ${redistribute_configuration}
    [Return]    ${redistribute_configuration}
    
Configure IPv6 Connected Route BGP Redistribution
    [Documentation]  Issues the 'redistribute connected route-map' command under the ipv6 address-family
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${route_map}=none    ${route_domain_id}=0
    ${bgp_commands}    set variable if    '${route_map}' == 'none'    configure terminal,router bgp ${local_as_number},address-family ipv6,redistribute connected,end,copy running-config startup-config    configure terminal,router bgp ${local_as_number},address-family ipv6,redistribute connected route-map ${route_map},end,copy running-config startup-config
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    [Return]    ${api_response}

Verify IPv6 Connected Route BGP Redistribution
    [Documentation]  Verifies configuration of IPv6 Connected route redistribution
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${route_map}=none    ${route_domain_id}=0
    ${bgp_as_configuration}    Retrieve BGP AS IPv6 Address-Family Configuration    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    local_as_number=${local_as_number}    route_domain_id=${route_domain_id}
    ${redistribute_configuration}    set variable if    '${route_map}' == 'none'    redistribute connected    redistribute connected route-map ${route_map}
    should contain    ${bgp_as_configuration}    ${redistribute_configuration}
    [Return]    ${redistribute_configuration}

Configure IPv6 Static Route BGP Redistribution
    [Documentation]  Issues the 'redistribute static route-map' command under the ipv6 address-family
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${route_map}=none    ${route_domain_id}=0
    ${bgp_commands}    set variable if    '${route_map}' == 'none'    configure terminal,router bgp ${local_as_number},address-family ipv6,redistribute static,end,copy running-config startup-config    configure terminal,router bgp ${local_as_number},address-family ipv6,redistribute static route-map ${route_map},end,copy running-config startup-config
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    [Return]    ${api_response}

Verify IPv6 Static Route BGP Redistribution
    [Documentation]  Verifies configuration of IPv6 Static route redistribution
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${route_map}=none    ${route_domain_id}=0
    ${bgp_as_configuration}    Retrieve BGP AS IPv6 Address-Family Configuration    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    local_as_number=${local_as_number}    route_domain_id=${route_domain_id}
    ${redistribute_configuration}    set variable if    '${route_map}' == 'none'    redistribute static    redistribute static route-map ${route_map}
    should contain    ${bgp_as_configuration}    ${redistribute_configuration}
    [Return]    ${redistribute_configuration}

Configure BGP IPv4 Neighbor Inbound Route-Map
    [Documentation]  Applies an inbound route-map to an IPv4 BGP Neighbor
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${neighbor}    ${route_map_name}    ${route_domain_id}=0
    ${bgp_commands}    set variable    configure terminal,router bgp ${local_as_number},neighbor ${neighbor} route-map ${route_map_name} in,end,copy running-config startup-config
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    [Return]    ${api_response}

Verify BGP IPv4 Neighbor Inbound Route-Map
    [Documentation]  Applies an inbound route-map to an IPv4 BGP Neighbor
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${neighbor}    ${route_map_name}    ${route_domain_id}=0
    ${bgp_as_configuration}    Retrieve BGP AS Global Configuration    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    local_as_number=${local_as_number}    route_domain_id=${route_domain_id}
    should contain    ${bgp_as_configuration}    neighbor ${neighbor} route-map ${route_map_name} in
    [Return]    ${bgp_as_configuration}

Configure BGP IPv4 Neighbor Outbound Route-Map
    [Documentation]  Applies an outbound route-map to an IPv4 BGP Neighbor
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${neighbor}    ${route_map_name}    ${route_domain_id}=0
    ${bgp_commands}    set variable    configure terminal,router bgp ${local_as_number},neighbor ${neighbor} route-map ${route_map_name} out,end,copy running-config startup-config
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    [Return]    ${api_response}

Verify BGP IPv4 Neighbor Outbound Route-Map
    [Documentation]  Applies an outbound route-map to an IPv4 BGP Neighbor
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${neighbor}    ${route_map_name}    ${route_domain_id}=0
    ${bgp_as_configuration}    Retrieve BGP AS Global Configuration    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    local_as_number=${local_as_number}    route_domain_id=${route_domain_id}
    should contain    ${bgp_as_configuration}    neighbor ${neighbor} route-map ${route_map_name} out
    [Return]    ${bgp_as_configuration}
    
Enable BGP IPv4 Neighbor Soft Reconfiguration Inbound
    [Documentation]  Enables Soft Reconfiguration on an IPv4 BGP Neighbor
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${neighbor}    ${route_domain_id}=0
    ${bgp_commands}    set variable    configure terminal,router bgp ${local_as_number},neighbor ${neighbor} soft-reconfiguration inbound,end,copy running-config startup-config
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    [Return]    ${api_response}

Verify Enable BGP IPv4 Neighbor Soft Reconfiguration Inbound
    [Documentation]  Enables Soft Reconfiguration on an IPv4 BGP Neighbor
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${neighbor}    ${route_domain_id}=0
    ${bgp_as_configuration}    Retrieve BGP AS Global Configuration    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    local_as_number=${local_as_number}    route_domain_id=${route_domain_id}
    should contain    ${bgp_as_configuration}    neighbor ${neighbor} soft-reconfiguration inbound
    should not contain    ${bgp_as_configuration}    no neighbor ${neighbor} soft-reconfiguration inbound
    [Return]    ${bgp_as_configuration}

Enable BGP IPv6 Neighbor Soft Reconfiguration Inbound
    [Documentation]  Enables Soft Reconfiguration on an IPv4 BGP Neighbor
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${neighbor}    ${route_domain_id}=0
    ${bgp_commands}    set variable    configure terminal,router bgp ${local_as_number},address-family ipv6,neighbor ${neighbor} soft-reconfiguration inbound,end,copy running-config startup-config
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    [Return]    ${api_response}

Verify Enable BGP IPv6 Neighbor Soft Reconfiguration Inbound
    [Documentation]  Enables Soft Reconfiguration on an IPv4 BGP Neighbor
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${neighbor}    ${route_domain_id}=0
    ${bgp_as_configuration}    Retrieve BGP AS IPv6 Address-Family Configuration    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    local_as_number=${local_as_number}    route_domain_id=${route_domain_id}
    should contain    ${bgp_as_configuration}    neighbor ${neighbor} soft-reconfiguration inbound
    should not contain    ${bgp_as_configuration}    no neighbor ${neighbor} soft-reconfiguration inbound
    [Return]    ${bgp_as_configuration}

Disable the Graceful Restart BGP IPv4 Neighbor Capability
    [Documentation]  Disables the Graceful Restart BGP Neighbor capability
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${neighbor}    ${route_domain_id}=0
    ${bgp_commands}    set variable    configure terminal,router bgp ${local_as_number},no neighbor ${neighbor} capability graceful-restart,end,copy running-config startup-config
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    [Return]    ${api_response}

Verify Disable the Graceful Restart BGP IPv4 Neighbor Capability
    [Documentation]  Verifying disabling the Graceful Restart BGP Neighbor capability
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${neighbor}    ${route_domain_id}=0
    ${bgp_as_configuration}    Retrieve BGP AS IPv6 Address-Family Configuration    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    local_as_number=${local_as_number}    route_domain_id=${route_domain_id}
    should not contain    ${bgp_as_configuration}    neighbor ${neighbor} capability graceful-restart
    should contain    ${bgp_as_configuration}    no neighbor ${neighbor} capability graceful-restart
    [Return]    ${bgp_as_configuration}

Enable the Graceful Restart BGP IPv4 Neighbor Capability
    [Documentation]  Disables the Graceful Restart BGP Neighbor capability
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${neighbor}    ${route_domain_id}=0
    ${bgp_commands}    set variable    configure terminal,router bgp ${local_as_number},neighbor ${neighbor} capability graceful-restart,end,copy running-config startup-config
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    [Return]    ${api_response}

Verify Enable the Graceful Restart BGP IPv4 Neighbor Capability
    [Documentation]  Verifying enabling the Graceful Restart BGP Neighbor capability
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${neighbor}    ${route_domain_id}=0
    ${bgp_as_configuration}    Retrieve BGP AS IPv6 Address-Family Configuration    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    local_as_number=${local_as_number}    route_domain_id=${route_domain_id}
    should contain    ${bgp_as_configuration}    neighbor ${neighbor} capability graceful-restart
    should not contain    ${bgp_as_configuration}    no neighbor ${neighbor} capability graceful-restart
    [Return]    ${bgp_as_configuration}

Disable the Graceful Restart BGP IPv6 Neighbor Capability
    [Documentation]  Disables the Graceful Restart BGP Neighbor capability
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${neighbor}    ${route_domain_id}=0
    ${bgp_commands}    set variable    configure terminal,router bgp ${local_as_number},no neighbor ${neighbor} capability graceful-restart,address-family ipv6,no neighbor ${neighbor} capability graceful-restart,end,copy running-config startup-config
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    [Return]    ${api_response}

Verify Disable the Graceful Restart BGP IPv6 Neighbor Capability
    [Documentation]  Disables the Graceful Restart BGP Neighbor capability
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${neighbor}    ${route_domain_id}=0
    ${bgp_as_configuration}    Retrieve BGP AS IPv6 Address-Family Configuration    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    local_as_number=${local_as_number}    route_domain_id=${route_domain_id}
    should not contain    ${bgp_as_configuration}    \n\ neighbor ${neighbor} capability graceful-restart
    should contain    ${bgp_as_configuration}    no neighbor ${neighbor} capability graceful-restart
    [Return]    ${bgp_as_configuration}

Enable the Graceful Restart BGP IPv6 Neighbor Capability
    [Documentation]  Disables the Graceful Restart BGP Neighbor capability
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${neighbor}    ${route_domain_id}=0
    ${bgp_commands}    set variable    configure terminal,router bgp ${local_as_number},neighbor ${neighbor} capability graceful-restart,end,copy running-config startup-config
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    [Return]    ${api_response}

Verify Enable the Graceful Restart BGP IPv6 Neighbor Capability
    [Documentation]  Disables the Graceful Restart BGP Neighbor capability
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${neighbor}    ${route_domain_id}=0
    ${bgp_as_configuration}    Retrieve BGP AS IPv6 Address-Family Configuration    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    local_as_number=${local_as_number}    route_domain_id=${route_domain_id}
    should contain    ${bgp_as_configuration}    neighbor ${neighbor} capability graceful-restart
    should not contain    ${bgp_as_configuration}    no neighbor ${neighbor} capability graceful-restart
    [Return]    ${bgp_as_configuration}

Create BGP IPv4 Neighbor Peer-Group
    [Documentation]  Creates a BGP IPv4 Peer Group
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${peer_group_name}    ${route_domain_id}=0
    ${bgp_commands}    set variable    configure terminal,router bgp ${local_as_number},neighbor ${peer_group_name} peer-group,end,copy running-config startup-config
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    [Return]    ${api_response}

Retrieve BGP AS Configuration
    [Documentation]  Retrieves the BGP configuration for a single AS
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${route_domain_id}=0
    ${bgp_commands}    set variable    show run bgp | sed -n '/router bgp ${local_as_number}/,/^!/p'
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    ${bgp_configuration}    get from dictionary    ${api_response.json}    commandResult
    [Return]    ${bgp_configuration}

Retrieve BGP AS Global Configuration
    [Documentation]  Retrieves the global "non-address-family" BGP configuration for a single AS
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${route_domain_id}=0
    ${bgp_commands}    set variable    show running-config bgp | sed -n '/router bgp ${local_as_number}/,/^ \!/p' 
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    ${bgp_configuration}    get from dictionary    ${api_response.json}    commandResult
    [Return]    ${bgp_configuration}

Retrieve BGP AS IPv4 Address-Family Configuration
    [Documentation]  Retrieves the IPv4 Address-Family BGP configuration for a single AS
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${route_domain_id}=0
    ${bgp_commands}    set variable    show running-config bgp | sed -n '/router bgp ${local_as_number}/,/^\!/p' | sed -n '/^ address-family ipv4/,/exit-address-family/p' 
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    ${bgp_configuration}    get from dictionary    ${api_response.json}    commandResult
    [Return]    ${bgp_configuration}

Retrieve BGP AS IPv6 Address-Family Configuration
    [Documentation]  Retrieves the IPv6 Address-Family BGP configuration for a single AS
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${route_domain_id}=0
    ${bgp_commands}    set variable    show running-config bgp | sed -n '/router bgp ${local_as_number}/,/^\!/p' | sed -n '/^ address-family ipv6/,/exit-address-family/p' 
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    ${bgp_configuration}    get from dictionary    ${api_response.json}    commandResult
    [Return]    ${bgp_configuration}

Verify BGP IPv4 Neighbor Peer-Group
    [Documentation]  Verifies that a BGP IPv4 Peer Group exists
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${peer_group_name}    ${route_domain_id}=0
    ${bgp_as_configuration}    Retrieve BGP AS Configuration    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    local_as_number=${local_as_number}    route_domain_id=${route_domain_id}
    [Return]    ${bgp_as_configuration}

Configure BGP IPv4 Neighbor Remote AS
    [Documentation]  Specifies a remote-as for a BGP neighbor
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${neighbor}    ${remote_as_number}    ${route_domain_id}=0
    ${bgp_commands}    set variable    configure terminal,router bgp ${local_as_number},neighbor ${neighbor} remote-as ${remote_as_number},end,copy running-config startup-config
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    [Return]    ${api_response}

Verify BGP IPv4 Neighbor Remote AS
    [Documentation]  Verifies a remote-as for a BGP neighbor
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${neighbor}    ${remote_as_number}    ${route_domain_id}=0
    ${bgp_as_configuration}    Retrieve BGP AS Global Configuration    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    local_as_number=${local_as_number}    route_domain_id=${route_domain_id}
    should contain    ${bgp_as_configuration}    neighbor ${neighbor} remote-as ${remote_as_number}
    [Return]    ${bgp_as_configuration}

Configure BGP Neighbor Update Source
    [Documentation]  Specifies an update source interface for a BGP neighbor
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${neighbor}    ${update_source}    ${route_domain_id}=0
    ${bgp_commands}    set variable    configure terminal,router bgp ${local_as_number},neighbor ${neighbor} update-source ${update_source},end,copy running-config startup-config
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    [Return]    ${api_response}

Verify BGP Neighbor Update Source
    [Documentation]  Verifies an update source interface for a BGP neighbor
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${neighbor}    ${update_source}    ${route_domain_id}=0
    ${bgp_as_configuration}    Retrieve BGP AS Global Configuration    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    local_as_number=${local_as_number}    route_domain_id=${route_domain_id}
    should contain    ${bgp_as_configuration}    neighbor ${neighbor} update-source ${update_source}
    [Return]    ${bgp_as_configuration}

Configure BGP Neighbor Timers
    [Documentation]  Sets the keepalive and hold timer values for a BGP neighbor
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${neighbor}    ${keepalive_timer}    ${hold_timer}    ${route_domain_id}=0
    ${bgp_commands}    set variable    configure terminal,router bgp ${local_as_number},neighbor ${neighbor} timers ${keepalive_timer} ${hold_timer},end,copy running-config startup-config
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    [Return]    ${api_response}

Verify BGP Neighbor Timers
    [Documentation]  Verifies the keepalive and hold timer values for a BGP neighbor
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${neighbor}    ${keepalive_timer}    ${hold_timer}    ${route_domain_id}=0
    ${bgp_as_configuration}    Retrieve BGP AS Global Configuration    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    local_as_number=${local_as_number}    route_domain_id=${route_domain_id}
    should contain    ${bgp_as_configuration}    neighbor ${neighbor} timers ${keepalive_timer} ${hold_timer}
    [Return]    ${bgp_as_configuration}

Activate BGP IPv4 Neighbor
    [Documentation]  Activates a BGP IPv4 Neighbor
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${neighbor}    ${route_domain_id}=0
    ${bgp_commands}    set variable    configure terminal,router bgp ${local_as_number},address-family ipv4,neighbor ${neighbor} activate,end,copy running-config startup-config
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    [Return]    ${api_response}

Verify BGP IPv4 Neighbor Activation
    [Documentation]  Verifies activation of a BGP IPv4 Neighbor
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${neighbor}    ${route_domain_id}=0
    ${bgp_as_configuration}    Retrieve BGP AS Global Configuration    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    local_as_number=${local_as_number}    route_domain_id=${route_domain_id}
    should not contain    ${bgp_as_configuration}    no neighbor ${neighbor} activate
    [Return]    ${bgp_as_configuration}
    
Deactivate BGP IPv4 Neighbor
    [Documentation]  Activates a BGP IPv4 Neighbor
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${neighbor}    ${route_domain_id}=0
    ${bgp_commands}    set variable    configure terminal,router bgp ${local_as_number},address-family ipv4,no neighbor ${nighbor} activate,end,copy running-config startup-config
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    [Return]    ${api_response}

Verify BGP IPv4 Neighbor Deactivation
    [Documentation]  Verifies deactivation of a BGP IPv4 Neighbor
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${neighbor}    ${route_domain_id}=0
    ${bgp_as_configuration}    Retrieve BGP AS Global Configuration    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    local_as_number=${local_as_number}    route_domain_id=${route_domain_id}
    should contain    ${bgp_as_configuration}    no neighbor ${neighbor} activate
    [Return]    ${bgp_as_configuration}
  
Activate BGP IPv6 Neighbor
    [Documentation]  Activates a BGP IPv4 Neighbor
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${neighbor}    ${route_domain_id}=0
    ${bgp_commands}    set variable    configure terminal,router bgp ${local_as_number},address-family ipv6,neighbor ${neighbor} activate,end,copy running-config startup-config
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    [Return]    ${api_response}

Verify BGP IPv6 Neighbor Activation
    [Documentation]  Verifies activation of a BGP IPv4 Neighbor
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${neighbor}    ${route_domain_id}=0
    ${bgp_as_configuration}    Retrieve BGP AS IPv6 Address-Family Configuration    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    local_as_number=${local_as_number}    route_domain_id=${route_domain_id}
    should not contain    ${bgp_as_configuration}    no neighbor ${neighbor} activate
    [Return]    ${bgp_as_configuration}
    
Deactivate BGP IPv6 Neighbor
    [Documentation]  Activates a BGP IPv4 Neighbor
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${neighbor}    ${route_domain_id}=0
    ${bgp_commands}    set variable    configure terminal,router bgp ${local_as_number},address-family ipv6,no neighbor ${nighbor} activate,end,copy running-config startup-config
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    [Return]    ${api_response}

Verify BGP IPv6 Neighbor Deactivation
    [Documentation]  Verifies deactivation of a BGP IPv4 Neighbor
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${neighbor}    ${route_domain_id}=0
    ${bgp_as_configuration}    Retrieve BGP AS IPv6 Address-Family Configuration    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    local_as_number=${local_as_number}    route_domain_id=${route_domain_id}
    should not contain    ${bgp_as_configuration}   \n\ neighbor ${neighbor} activate\n
    should contain    ${bgp_as_configuration}    \n\ no neighbor ${neighbor} activate\n
    [Return]    ${bgp_as_configuration}

Create BGP IPv6 Neighbor Peer-Group
    [Documentation]  Creates a BGP IPv6 Neighbor Peer-Group
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${peer_group_name}    ${route_domain_id}=0      
    ${bgp_commands}    set variable    configure terminal,router bgp ${local_as_number},neighbor ${peer_group_name} peer-group,end,copy running-config startup-config
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    [Return]    ${api_response}

Verify BGP IPv6 Neighbor Peer-Group
    [Documentation]  Creates a BGP IPv6 Neighbor Peer-Group
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${peer_group_name}    ${route_domain_id}=0      
    ${bgp_as_configuration}    Retrieve BGP AS Global Configuration    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    local_as_number=${local_as_number}    route_domain_id=${route_domain_id}
    should contain    ${bgp_as_configuration}    neighbor ${peer_group_name} peer-group
    [Return]    ${bgp_as_configuration}

Create BGP IPv6 Neighbor Peer-Group Remote AS
    [Documentation]  Configures the remote-AS on a BGP peer-group
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${peer_group_name}    ${remote_as_number}    ${route_domain_id}=0
    ${bgp_commands}    set variable    configure terminal,router bgp ${local_as_number},neighbor ${peer_group_name} remote-as ${remote_as_number},end,copy running-config startup-config                
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    [Return]    ${api_response}

Verify BGP IPv6 Neighbor Peer-Group Remote AS
    [Documentation]  Configures the remote-AS on a BGP peer-group
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${peer_group_name}    ${remote_as_number}    ${route_domain_id}=0
    ${bgp_as_configuration}    Retrieve BGP AS Global Configuration    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    local_as_number=${local_as_number}    route_domain_id=${route_domain_id}
    should contain    ${bgp_as_configuration}    neighbor ${peer_group_name} remote-as ${remote_as_number}
    [Return]    ${bgp_as_configuration}

Configure IPv6 BGP Neighbor Route-Map
    [Documentation]  Applies a route-map to an existing IPv6 BGP Neighbor
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${neighbor}    ${route_map_name}    ${route_map_direction}    ${route_domain_id}=0
    ${bgp_commands}    set variable    configure terminal,router bgp ${local_as_number},address-family ipv6,neighbor ${neighbor} route-map ${route_map_name} ${route_map_direction},end,copy running-config startup-config
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    [Return]    ${api_response}

Verify IPv6 BGP Neighbor Route-Map
    [Documentation]  Applies a route-map to an existing IPv6 BGP Neighbor
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${neighbor}    ${route_map_name}    ${route_map_direction}    ${route_domain_id}=0
    ${bgp_as_configuration}    Retrieve BGP AS IPv6 Address-Family Configuration    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    local_as_number=${local_as_number}    route_domain_id=${route_domain_id}
    should contain    ${bgp_as_configuration}    neighbor ${neighbor} route-map ${route_map_name}
    [Return]    ${bgp_as_configuration}

Create ZebOS Static Route on the BIG-IP
    [Documentation]  Creates a static route inside of the ZebOS dynamic routing daemon on the BIG-IP
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${network}    ${gateway}    ${route_domain_id}=0
    ${bgp_commands}    set variable    configure terminal,ip route ${network} ${gateway},end,copy running-config startup-config
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    [Return]    ${api_response}

Verify ZebOS Static Route on the BIG-IP
    [Documentation]  Creates a static route inside of the ZebOS dynamic routing daemon on the BIG-IP
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${network}    ${gateway}    ${route_domain_id}=0
    ${bgp_commands}    set variable    show running-config ip route
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    ${bgp_configuration}    get from dictionary    ${api_response.json}    commandResult
    should contain    ${bgp_configuration}    ip route ${network} ${gateway}
    [Return]    ${bgp_configuration}

Enable BFD GTSM on the BIG-IP
    [Documentation]  Issues the "bfd gtsm enable" command on the ZebOS daemon for a route-domain
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${route_domain_id}=0
    ${bgp_commands}    set variable    configure terminal,bfd gtsm enable,end,copy running-config startup-config
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    [Return]    ${api_response}

Create IPv4 Prefix List
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${prefix_list_name}    ${entries_list}    ${route_domain_id}=0
    FOR    ${current_entry}    IN    @{entries_list}
        ${sequence}    get from dictionary    ${current_entry}    sequence    
        ${action}    get from dictionary    ${current_entry}    action
        ${subnet_string}    get from dictionary    ${current_entry}    subnetString
        ${bgp_commands}    set variable    configure terminal,ip prefix-list ${prefix_list_name} seq ${sequence} ${action} ${subnet_string},end,copy running-config startup-config
        ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    END
    [Return]    ${api_response}

Verify IPv4 Prefix List
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${prefix_list_name}    ${entries_list}    ${route_domain_id}=0
    ${bgp_commands}    set variable    show running-config prefix-list
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    ${prefix_list_configuration}    get from dictionary    ${api_response.json}    commandResult
    FOR    ${current_entry}    IN    @{entries_list}
        ${sequence}    get from dictionary    ${current_entry}    sequence    
        ${action}    get from dictionary    ${current_entry}    action
        ${subnet_string}    get from dictionary    ${current_entry}    subnetString
        should contain    ${prefix_list_configuration}    ip prefix-list ${prefix_list_name} seq ${sequence} ${action} ${subnet_string}
    END
    [Return]    ${api_response}

Create IPv6 Prefix List
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${prefix_list_name}    ${entries_list}    ${route_domain_id}=0
    FOR    ${current_entry}    IN    @{entries_list}
        ${sequence}    get from dictionary    ${current_entry}    sequence    
        ${action}    get from dictionary    ${current_entry}    action
        ${subnet_string}    get from dictionary    ${current_entry}    subnetString
        ${bgp_commands}    set variable    configure terminal,ipv6 prefix-list ${prefix_list_name} seq ${sequence} ${action} ${subnet_string},end,copy running-config startup-config
        ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    END
    [Return]    ${api_response}

Verify IPv6 Prefix List
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${prefix_list_name}    ${entries_list}    ${route_domain_id}=0
    ${bgp_commands}    set variable    show running-config ipv6 prefix-list
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    ${prefix_list_configuration}    get from dictionary    ${api_response.json}    commandResult
    FOR    ${current_entry}    IN    @{entries_list}
        ${sequence}    get from dictionary    ${current_entry}    sequence    
        ${action}    get from dictionary    ${current_entry}    action
        ${subnet_string}    get from dictionary    ${current_entry}    subnetString
        should contain    ${prefix_list_configuration}    ipv6 prefix-list ${prefix_list_name} seq ${sequence} ${action} ${subnet_string}
    END
    [Return]    ${api_response}
    
Create ZebOS Route-Map
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${route_map_name}    ${route_map_entries_dictionary}    ${route_domain_id}=0
    FOR    ${current_entry}    IN    @{route_map_entries_dictionary}
        ${sequence}    get from dictionary    ${current_entry}    sequence    
        ${action}    get from dictionary    ${current_entry}    action
        ${match_statement}    get from dictionary    ${current_entry}    match
        ${bgp_commands}    set variable if    '${match_statement}' == 'all'    configure terminal,route-map ${route_map_name} ${action} ${sequence},end,copy running-config startup-config    configure terminal,route-map ${route_map_name} ${action} ${sequence},match ${match_statement},end,copy running-config startup-config
        ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    END
    [Return]    ${api_response}

Verify ZebOS Route-Map
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${route_map_name}    ${route_map_entries_dictionary}    ${route_domain_id}=0
    ${bgp_commands}    set variable    show running-config route-map
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    ${route_map_configuration}    get from dictionary    ${api_response.json}    commandResult
    FOR    ${current_entry}    IN    @{route_map_entries_dictionary}
        ${sequence}    get from dictionary    ${current_entry}    sequence    
        ${action}    get from dictionary    ${current_entry}    action
        ${match_statement}    get from dictionary    ${current_entry}    match
        ${route_map_entry}    set variable    route-map ${route_map_name} ${action} ${sequence}
        should contain    ${route_map_configuration}    ${route_map_entry}
        run keyword if    '${match_statement}' != 'all'    should contain    ${route_map_configuration}    match ${match_statement}
    END
    [Return]    ${route_map_configuration}
     
Clear BGP Max-Path on F5 BIG-IP
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_bgp_as}    ${route_domain_id}
    ${bgp_commands}    set variable    configure terminal,router bgp ${local_bgp_as}, no max-paths ebgp,end,copy running-config startup-config
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    [Return]    ${api_response}

Set BGP Max-Path on F5 BIG-IP
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_bgp_as}    ${route_domain_id}    ${maximum_paths}
    ${bgp_commands}    set variable    configure terminal,router bgp ${local_bgp_as}, max-paths ebgp ${maximum_paths},end,copy running-config startup-config
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    [Return]    ${api_response}
    
Retrieve BGP IPv4 Summary from BIG-IP
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${route_domain_id}    
    ${bgp_commands}    set variable    show bgp ipv4 summary
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    ${command_output}    get from dictionary    ${api_response.json}    commandResult
    [Return]    ${command_output}

Retrieve BGP IPv6 Summary from BIG-IP
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${route_domain_id}    
    ${bgp_commands}    set variable    show bgp ipv6 summary
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    ${command_output}    get from dictionary    ${api_response.json}    commandResult
    [Return]    ${command_output}

Retrieve BGP IPv4 Status from BIG-IP
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${route_domain_id}
    ${bgp_commands}    set variable    show ip bgp
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    ${command_output}    get from dictionary    ${api_response.json}    commandResult
    [Return]    ${command_output}

Retrieve BGP IPv6 Status from BIG-IP
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${route_domain_id}
    ${bgp_commands}    set variable    show bgp ipv6
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    ${command_output}    get from dictionary    ${api_response.json}    commandResult
    [Return]    ${command_output}

Retrieve ZebOS IPv4 Routing Table from BIG-IP
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${route_domain_id}
    ${bgp_commands}    set variable    show ip route
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    ${command_output}    get from dictionary    ${api_response.json}    commandResult
    [Return]    ${command_output}

Retrieve ZebOS IPv6 Routing Table from BIG-IP
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${route_domain_id}
    ${bgp_commands}    set variable    show ipv6 route
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    ${command_output}    get from dictionary    ${api_response.json}    commandResult
    [Return]    ${command_output}
 