*** Settings ***
Documentation    Resource file for F5's iControl REST API
Library    BuiltIn
Library    Collections
Library    RequestsLibrary
Library    String
Library    SnmpLibrary
Library    SSHLibrary

*** Keywords ***

#############################
## Generic Testing Keywords
#############################

Ping Host from BIG-IP
    [Documentation]    Sends an ICMP echo request from the BIG-IP (See page 63 of https://cdn.f5.com/websites/devcentral.f5.com/downloads/icontrol-rest-api-user-guide-13-1-0-a.pdf.zip)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${host}    ${count}=1    ${interval}=100    ${packetsize}=56
    ${api_payload}    Create Dictionary    command=run    utilCmdArgs=-c ${count} -i ${interval} -s ${packetsize} ${host}
    ${api_uri}    set variable    /mgmt/tm/util/ping
    ${api_response}    BIG-IP iControl BasicAuth POST    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    ${api_response_json}    To Json    ${api_response.content}
    ${ping_output}    Get from Dictionary    ${api_response_json}    commandResult
    log    ${ping_output}
    Should Contain    ${ping_output}    , 0% packet loss
    [Return]    ${api_response}

Ping IPv6 Host from BIG-IP
    [Documentation]    Sends an ICMP echo request from the BIG-IP (See page 63 of https://cdn.f5.com/websites/devcentral.f5.com/downloads/icontrol-rest-api-user-guide-13-1-0-a.pdf.zip)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${host}    ${count}=1    ${interval}=100    ${packetsize}=56
    ${api_payload}    Create Dictionary    command=run    utilCmdArgs=-c ${count} -i ${interval} -s ${packetsize} ${host}
    ${api_uri}    set variable    /mgmt/tm/util/ping6
    ${api_response}    BIG-IP iControl BasicAuth POST    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    ${api_response_json}    To Json    ${api_response.content}
    ${ping_output}    Get from Dictionary    ${api_response_json}    commandResult
    log    ${ping_output}
    Should Contain    ${ping_output}    , 0% packet loss
    [Return]    ${api_response}

Reboot a BIG-IP
    [Documentation]    Issues the "tmsh reboot" command
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    
    Wait until Keyword Succeeds    3x    5 seconds    Open Connection    ${bigip_host}
    Log In    ${bigip_username}    ${bigip_password}
    ${reboot_command_response}    Execute Command    reboot now
    [Return]    ${reboot_command_response}
        
##############
## Cisco NX-OS
##############

Get IPv4 Received Routes from Nexus Router
    [Documentation]    Gathers the BGP neighbor received-routes on a peer on a Cisco Nexus device
    [Arguments]    ${host}    ${username}    ${password}    ${remote_bgp_peer_ip}    ${remote_vrf}=default    ${peer_vdc}=none    
    Wait until Keyword Succeeds    3x    5 seconds    Open Connection    ${host}    prompt=#
    Log In    ${username}    ${password}
    ${initial_read}    Read    delay=2s
    run keyword if    '${peer_vdc}' != 'none'    Write    switchto vdc ${peer_vdc}
    ${second_read}    Read until Prompt    loglevel=trace
    ${set_terminal_length_0_command}    Write    terminal length 0
    ${set_terminal_length_0_response}    Read until Prompt    loglevel=trace
    ${show_bgp_ipv4_neighbors_write}    Write    show ip bgp neighbors ${remote_bgp_peer_ip} received-routes vrf ${remote_vrf}
    ${peer_adv_routes_raw}    Read until Prompt    loglevel=trace
    Close All Connections
    ${peer_adv_routes_raw}    get regexp matches    ${peer_adv_routes_raw}    (?:[0-9]{1,3}\.){3}[0-9]{1,3}\/[0-9]{1,2}
    ${peer_adv_routes}    create list
    FOR   ${current_adv_route}   IN    @{peer_adv_routes_raw}
        ${current_adv_route_network}    fetch from left    ${current_adv_route}    /
        ${current_adv_route_mask}    fetch from right    ${current_adv_route}    /
        append to list    ${peer_adv_routes}    ${current_adv_route_network}/${current_adv_route_mask}
    END
    [Return]    ${peer_adv_routes}

Get IPv6 Received Routes from Nexus Router
    [Documentation]    Gathers the BGP neighbor received-routes on a peer on a Cisco Nexus device
    [Arguments]    ${host}    ${username}    ${password}    ${remote_bgp_peer_ip}    ${remote_vrf}=default     ${peer_vdc}=none
    Wait until Keyword Succeeds    3x    5 seconds    Open Connection    ${host}    prompt=#
    Log In    ${username}    ${password}
    ${initial_read}    Read    delay=2s
    run keyword if    '${peer_vdc}' != 'none'    Write    switchto vdc ${peer_vdc}
    ${second_read}    Read until Prompt    loglevel=trace
    ${set_terminal_length_0_command}    Write    terminal length 0
    ${set_terminal_length_0_response}    Read until Prompt    loglevel=trace
    ${show_bgp_ipv6_neighbors_write}    Write    show bgp ipv6 unicast neighbors ${remote_bgp_peer_ip} received-routes vrf ${remote_vrf}
    ${peer_adv_routes_raw}    Read until Prompt    loglevel=trace
    Close All Connections
    ${peer_adv_routes_raw}    get regexp matches    ${peer_adv_routes_raw}    (([0-9a-fA-F]{1,4}:){7,7}[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,7}:|([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}|([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}|([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}|([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}|[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})|:((:[0-9a-fA-F]{1,4}){1,7}|:)|fe80:(:[0-9a-fA-F]{0,4}){0,4}%[0-9a-zA-Z]{1,}|::(ffff(:0{1,4}){0,1}:){0,1}((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])|([0-9a-fA-F]{1,4}:){1,4}:((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9]))\/[0-9]{1,3}
    ${peer_adv_routes}    create list
    FOR   ${current_adv_route}   IN    @{peer_adv_routes_raw}
        ${current_adv_route_network}    fetch from left    ${current_adv_route}    /
        ${current_adv_route_mask}    fetch from right    ${current_adv_route}    /
        append to list    ${peer_adv_routes}    ${current_adv_route_network}/${current_adv_route_mask}
    END
    [Return]    ${peer_adv_routes}

Set BGP Max-Path on Cisco Nexus
    [Documentation]    executes the "ip address-family maximum-paths" command
    [Arguments]    ${host}    ${username}    ${password}    ${maximum_paths}    ${local_bgp_as}    ${address_family}    ${remote_vrf}=default     ${peer_vdc}=none
    Wait until Keyword Succeeds    3x    5 seconds    Open Connection    ${host}    prompt=#
    Log In    ${username}    ${password}
    ${initial_read}    Read    delay=2s
    run keyword if    '${peer_vdc}' != 'none'    Write    switchto vdc ${peer_vdc}
    ${second_read}    Read until Prompt    loglevel=trace
    ${set_terminal_length_0_command}    Write    terminal length 0
    ${set_terminal_length_0_response}    Read until Prompt    loglevel=trace
    ${configure_terminal_command}    Write    configure terminal
    ${configure_terminal_response}    Read until Prompt    loglevel=trace
    ${router_bgp_command}    Write    router bgp ${local_bgp_as}
    ${router_bgp_response}    Read until Prompt    loglevel=trace
    run keyword if    '${remote_vrf}' != 'default'    Write    vrf ${remote_vrf}
    run keyword if    '${remote_vrf}' != 'default'    Read until Prompt    loglevel=trace
    ${address_family_command}    Write    address-family ${address_family} unicast
    ${address_family_response}    Read until Prompt    loglevel=trace    
    ${maximum_paths_command}    Write    maximum-paths ${maximum_paths}
    ${maximum_paths_response}    Read until Prompt    loglevel=trace
    ${end_command}    Write    end
    ${end_response}    Read until Prompt    loglevel=trace
    Close All Connections
    [Return]    ${maximum_paths_response}

Clear BGP Max-Path on Cisco Nexus
    [Documentation]    executes the "ip address-family no maximum-paths" command
    [Arguments]    ${host}    ${username}    ${password}    ${local_bgp_as}    ${address_family}    ${remote_vrf}=default     ${peer_vdc}=none
    Wait until Keyword Succeeds    3x    5 seconds    Open Connection    ${host}    prompt=#
    Log In    ${username}    ${password}
    ${initial_read}    Read    delay=2s
    run keyword if    '${peer_vdc}' != 'none'    Write    switchto vdc ${peer_vdc}
    ${second_read}    Read until Prompt    loglevel=trace
    ${set_terminal_length_0_command}    Write    terminal length 0
    ${set_terminal_length_0_response}    Read until Prompt    loglevel=trace
    ${configure_terminal_command}    Write    configure terminal
    ${configure_terminal_response}    Read until Prompt    loglevel=trace
    ${router_bgp_command}    Write    router bgp ${local_bgp_as}
    ${router_bgp_response}    Read until Prompt    loglevel=trace
    run keyword if    '${remote_vrf}' != 'default'    Write    vrf ${remote_vrf}
    run keyword if    '${remote_vrf}' != 'default'    Read until Prompt    loglevel=trace
    ${address_family_command}    Write    address-family ${address_family} unicast
    ${address_family_response}    Read until Prompt    loglevel=trace    
    ${maximum_paths_command}    Write    no maximum-paths
    ${maximum_paths_response}    Read until Prompt    loglevel=trace
    ${end_command}    Write    end
    ${end_response}    Read until Prompt    loglevel=trace
    Close All Connections
    [Return]    ${maximum_paths_response}
    
Retrieve BGP IPv4 Summary from Cisco Nexus
    [Documentation]    executes the "show bgp ipv4 unicast summary" command
    [Arguments]    ${host}    ${username}    ${password}    ${remote_vrf}=default     ${peer_vdc}=none
    Wait until Keyword Succeeds    3x    5 seconds    Open Connection    ${host}    prompt=#
    Log In    ${username}    ${password}
    ${initial_read}    Read    delay=2s
    run keyword if    '${peer_vdc}' != 'none'    Write    switchto vdc ${peer_vdc}
    ${second_read}    Read until Prompt    loglevel=trace
    ${set_terminal_length_0_command}    Write    terminal length 0
    ${set_terminal_length_0_response}    Read until Prompt    loglevel=trace
    ${show_bgp_ipv4_unicast_summary}    Write    show bgp ipv4 unicast summary vrf ${remote_vrf}
    ${bgp_ipv4_unicast_summary}    Read until Prompt    loglevel=trace
    Close All Connections
    [Return]    ${bgp_ipv4_unicast_summary}

Retrieve BGP IPv6 Summary from Cisco Nexus
    [Documentation]    executes the "show bgp ipv6 unicast summary" command
    [Arguments]    ${host}    ${username}    ${password}    ${remote_vrf}=default     ${peer_vdc}=none
    Wait until Keyword Succeeds    3x    5 seconds    Open Connection    ${host}    prompt=#
    Log In    ${username}    ${password}
    ${initial_read}    Read    delay=2s
    run keyword if    '${peer_vdc}' != 'none'    Write    switchto vdc ${peer_vdc}
    ${second_read}    Read until Prompt    loglevel=trace
    ${set_terminal_length_0_command}    Write    terminal length 0
    ${set_terminal_length_0_response}    Read until Prompt    loglevel=trace
    ${show_bgp_ipv6_unicast_summary}    Write    show bgp ipv6 unicast summary vrf ${remote_vrf}
    ${bgp_ipv6_unicast_summary}    Read until Prompt    loglevel=trace
    Close All Connections
    [Return]    ${bgp_ipv6_unicast_summary}

Retrieve BGP IPv4 Status from Cisco Nexus
    [Documentation]    executes the "show bgp ipv4 unicast" command
    [Arguments]    ${host}    ${username}    ${password}    ${remote_vrf}=default     ${peer_vdc}=none
    Wait until Keyword Succeeds    3x    5 seconds    Open Connection    ${host}    prompt=#
    Log In    ${username}    ${password}
    ${initial_read}    Read    delay=2s
    run keyword if    '${peer_vdc}' != 'none'    Write    switchto vdc ${peer_vdc}
    ${second_read}    Read until Prompt    loglevel=trace
    ${set_terminal_length_0_command}    Write    terminal length 0
    ${set_terminal_length_0_response}    Read until Prompt    loglevel=trace
    ${show_bgp_ipv4_unicast}    Write    show bgp ipv4 unicast vrf ${remote_vrf}
    ${bgp_ipv4_unicast}    Read until Prompt    loglevel=trace
    Close All Connections
    [Return]    ${bgp_ipv4_unicast}

Retrieve BGP IPv6 Status from Cisco Nexus
    [Documentation]    executes the "show bgp ipv6 unicast" command
    [Arguments]    ${host}    ${username}    ${password}    ${remote_vrf}=default     ${peer_vdc}=none
    Wait until Keyword Succeeds    3x    5 seconds    Open Connection    ${host}    prompt=#
    Log In    ${username}    ${password}
    ${initial_read}    Read    delay=2s
    run keyword if    '${peer_vdc}' != 'none'    Write    switchto vdc ${peer_vdc}
    ${second_read}    Read until Prompt    loglevel=trace
    ${set_terminal_length_0_command}    Write    terminal length 0
    ${set_terminal_length_0_response}    Read until Prompt    loglevel=trace
    ${show_bgp_ipv6_unicast}    Write    show bgp ipv6 unicast vrf ${remote_vrf}
    ${bgp_ipv6_unicast}    Read until Prompt    loglevel=trace
    Close All Connections
    [Return]    ${bgp_ipv6_unicast}

Retrieve IPv4 Routing Table from Cisco Nexus
    [Documentation]    executes the "show ip route" command
    [Arguments]    ${host}    ${username}    ${password}    ${remote_vrf}=default     ${peer_vdc}=none
    Wait until Keyword Succeeds    3x    5 seconds    Open Connection    ${host}    prompt=#
    Log In    ${username}    ${password}
    ${initial_read}    Read    delay=2s
    run keyword if    '${peer_vdc}' != 'none'    Write    switchto vdc ${peer_vdc}
    ${second_read}    Read until Prompt    loglevel=trace
    ${set_terminal_length_0_command}    Write    terminal length 0
    ${set_terminal_length_0_response}    Read until Prompt    loglevel=trace
    ${show_ip_route}    Write    show ip route vrf ${remote_vrf}
    ${ip_route}    Read until Prompt    loglevel=trace
    Close All Connections
    [Return]    ${ip_route}

Retrieve IPv6 Routing Table from Cisco Nexus
    [Documentation]    executes the "show ipv6 route" command
    [Arguments]    ${host}    ${username}    ${password}    ${remote_vrf}=default     ${peer_vdc}=none
    Wait until Keyword Succeeds    3x    5 seconds    Open Connection    ${host}    prompt=#
    Log In    ${username}    ${password}
    ${initial_read}    Read    delay=2s
    run keyword if    '${peer_vdc}' != 'none'    Write    switchto vdc ${peer_vdc}
    ${second_read}    Read until Prompt    loglevel=trace
    ${set_terminal_length_0_command}    Write    terminal length 0
    ${set_terminal_length_0_response}    Read until Prompt    loglevel=trace
    ${show_ipv6_route}    Write    show ipv6 route vrf ${remote_vrf}
    ${ipv6_route}    Read until Prompt    loglevel=trace
    Close All Connections
    [Return]    ${ipv6_route}

########
## BGP
########

Run BGP Commands on BIG-IP
    [Documentation]    Generic handler for command separate list of BGP commands on the BIG-IP (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/big-ip-dynamic-routing-with-tmsh-and-icontrol-rest-14-0-0.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${commands}    ${route_domain_id}
    ${api_payload}    create dictionary    command=run    utilCmdArgs=-c "zebos -r ${route_domain_id} cmd terminal length 0,${commands}"
    ${api_uri}    set variable    /mgmt/tm/util/bash
    ${api_response}    BIG-IP iControl BasicAuth POST    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Create BGP IPv4 Neighbor
    [Documentation]    Creates a BGP IPv4 Neighbor on the BIG-IP (https://techdocs.f5.com/content/kb/en-us/products/big-ip_ltm/manuals/related/bgp-commandreference-7-10-4/_jcr_content/pdfAttach/download/file.res/arm-bgp-commandreference-7-10-4.pdf)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${bgp_peer_ip}   ${remote_as_number}    ${route_domain_id}=0
    ${bgp_commands}    set variable    configure terminal,router bgp ${local_as_number},neighbor ${bgp_peer_ip} remote-as ${remote_as_number},end,copy running-config startup-config
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    [Return]    ${api_response}

Create BGP IPv6 Neighbor
    [Documentation]    Creates a BGP IPv6 neighbor on the BIG-IP (https://techdocs.f5.com/content/kb/en-us/products/big-ip_ltm/manuals/related/bgp-commandreference-7-10-4/_jcr_content/pdfAttach/download/file.res/arm-bgp-commandreference-7-10-4.pdf)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${bgp_peer_ip}    ${remote_as_number}    ${route_domain_id}=0
    ${bgp_commands}    set variable    configure terminal,router bgp ${local_as_number},neighbor ${bgp_peer_ip} remote-as ${remote_as_number},end,copy running-config startup-config
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    [Return]    ${api_response}

Create BGP IPv4 Neighbor using Peer-Group
    [Documentation]    Creates a BGP IPv4 Neighbor on the BIG-IP (https://techdocs.f5.com/content/kb/en-us/products/big-ip_ltm/manuals/related/bgp-commandreference-7-10-4/_jcr_content/pdfAttach/download/file.res/arm-bgp-commandreference-7-10-4.pdf)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${bgp_peer_ip}   ${peer_group_name}    ${route_domain_id}=0
    ${bgp_commands}    set variable    configure terminal,router bgp ${local_as_number},neighbor ${bgp_peer_ip} peer-group ${peer_group_name},end,copy running-config startup-config
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    [Return]    ${api_response}

Verify BGP IPv4 Neighbor using Peer-Group
    [Documentation]    Creates a BGP IPv4 Neighbor on the BIG-IP (https://techdocs.f5.com/content/kb/en-us/products/big-ip_ltm/manuals/related/bgp-commandreference-7-10-4/_jcr_content/pdfAttach/download/file.res/arm-bgp-commandreference-7-10-4.pdf)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${bgp_peer_ip}   ${peer_group_name}    ${route_domain_id}=0
    ${bgp_commands}    set variable    configure terminal,router bgp ${local_as_number},neighbor ${bgp_peer_ip} peer-group ${peer_group_name},end,copy running-config startup-config
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    [Return]    ${api_response}

Create BGP IPv6 Neighbor using Peer-Group
    [Documentation]    Creates a BGP IPv6 neighbor on the BIG-IP (https://techdocs.f5.com/content/kb/en-us/products/big-ip_ltm/manuals/related/bgp-commandreference-7-10-4/_jcr_content/pdfAttach/download/file.res/arm-bgp-commandreference-7-10-4.pdf)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${bgp_peer_ip}    ${peer_group_name}    ${route_domain_id}=0
    ${bgp_commands}    set variable    configure terminal,router bgp ${local_as_number},neighbor ${bgp_peer_ip} peer-group ${peer_group_name},end,copy running-config startup-config
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    [Return]    ${api_response}

Verify BGP IPv6 Neighbor using Peer-Group
    [Documentation]    Verifies a BGP IPv6 neighbor on the BIG-IP (https://techdocs.f5.com/content/kb/en-us/products/big-ip_ltm/manuals/related/bgp-commandreference-7-10-4/_jcr_content/pdfAttach/download/file.res/arm-bgp-commandreference-7-10-4.pdf)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${bgp_peer_ip}    ${peer_group_name}    ${route_domain_id}=0
    ${bgp_as_configuration}    Retrieve BGP AS Global Configuration    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    local_as_number=${local_as_number}    route_domain_id=${route_domain_id}
    should contain    ${bgp_as_configuration}    neighbor ${bgp_peer_ip} peer-group ${peer_group_name}
    [Return]    ${bgp_as_configuration}

Create BGP IPv4 Network Advertisement
    [Documentation]    Creates a IPv4 network statement on the BIG-IP (https://techdocs.f5.com/content/kb/en-us/products/big-ip_ltm/manuals/related/bgp-commandreference-7-10-4/_jcr_content/pdfAttach/download/file.res/arm-bgp-commandreference-7-10-4.pdf)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${ipv4_prefix}    ${ipv4_mask}    ${route_domain_id}=0
    ${bgp_commands}    set variable    configure terminal,router bgp ${local_as_number},network ${ipv4_prefix} mask ${ipv4_mask},end,copy running-config startup-config
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    [Return]    ${api_response}

Create BGP IPv6 Network Advertisement
    [Documentation]    Creates an IPv6 address-family network statement on the BIG-IP (https://techdocs.f5.com/content/kb/en-us/products/big-ip_ltm/manuals/related/bgp-commandreference-7-10-4/_jcr_content/pdfAttach/download/file.res/arm-bgp-commandreference-7-10-4.pdf)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${ipv6_cidr}    ${route_domain_id}=0
    ${bgp_commands}    set variable    configure terminal,router bgp ${local_as_number},address-family ipv6,network ${ipv6_cidr},end,copy running-config startup-config
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    [Return]    ${api_response}

Disable BGP Default IPv4 Unicast
    [Documentation]   Disables IPv4 Unicast Default Advertising
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${route_domain_id}=0
    ${bgp_commands}    set variable    configure terminal,router bgp ${local_as_number},no bgp default ipv4-unicast,end,copy running-config startup-config
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    [Return]    ${api_response}

Verify Disabled BGP Default IPv4 Unicast
    [Documentation]   Verifies disabled IPv4 Unicast Default Advertising
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${route_domain_id}=0
    ${bgp_as_configuration}    Retrieve BGP AS Global Configuration    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    local_as_number=${local_as_number}    route_domain_id=${route_domain_id}
    should contain    ${bgp_as_configuration}    no bgp default ipv4-unicast
    [Return]    ${bgp_as_configuration}

Show Route Domain ZebOS Configuration
    [Documentation]    Lists the BGP configuration on a route-domain on the BIG-IP (defaults to RD 0) (https://techdocs.f5.com/content/kb/en-us/products/big-ip_ltm/manuals/related/bgp-commandreference-7-10-4/_jcr_content/pdfAttach/download/file.res/arm-bgp-commandreference-7-10-4.pdf)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${route_domain_id}=0
    ${bgp_commands}    set variable    show running-config
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    [Return]    ${api_response}

Show Route Domain BGP Status
    [Documentation]    Shows the BGP status on a \ on the BIG-IP (defaults to 0) (https://techdocs.f5.com/content/kb/en-us/products/big-ip_ltm/manuals/related/bgp-commandreference-7-10-4/_jcr_content/pdfAttach/download/file.res/arm-bgp-commandreference-7-10-4.pdf)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${route_domain_id}=0
    ${bgp_commands}    set variable    show ip bgp,show bgp,show bgp neighbors,show bgp ipv4 neighbors,show bgp ipv6 neighbors
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    ${bgp_status}    get from dictionary    ${api_response.json}    commandResult
    [Return]    ${bgp_status}

Retrieve BGP State for Peer
    [Documentation]    Verifies that BGP is established with a peer (https://techdocs.f5.com/content/kb/en-us/products/big-ip_ltm/manuals/related/bgp-commandreference-7-10-4/_jcr_content/pdfAttach/download/file.res/arm-bgp-commandreference-7-10-4.pdf)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${peer_address}    ${route_domain_id}=0
    ${bgp_commands}    set variable    show ip bgp neighbors ${peer_address}
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    ${bgp_state}       get from dictionary    ${api_response.json}    commandResult
    ${bgp_state}       fetch from right    ${bgp_state}    BGP state =${SPACE}
    ${bgp_state}       fetch from left    ${bgp_state}    ,
    [Return]    ${bgp_state}
    
Retrieve BGP Peer Advertised IPv4 Routes
    [Documentation]    Retrieves a list of advertised IPv4 routes on a BGP peer
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
    [Documentation]    Retrieves a list of advertised IPv4 routes on a BGP peer in CIDR format
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${peer_address}    ${route_domain_id}=0
    ${bgp_commands}    set variable    show ip bgp neighbors ${peer_address} advertised-routes
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    ${peer_adv_routes}    get from dictionary    ${api_response.json}    commandResult
    ${peer_adv_routes}    get regexp matches    ${peer_adv_routes}    (?:[0-9]{1,3}\.){3}[0-9]{1,3}\/[0-9]{1,2}
    [Return]    ${peer_adv_routes}
    
Retrieve BGP Peer Advertised IPv6 Routes
    [Documentation]    Retrieves a list of advertised IPv6 routes on a BGP peer
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${peer_address}    ${route_domain_id}=0
    ${bgp_commands}    set variable    show bgp ipv6 neighbors ${peer_address} advertised-routes
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    ${peer_adv_routes}    get from dictionary    ${api_response.json}    commandResult
    ${peer_adv_routes}    get regexp matches    ${peer_adv_routes}    (([0-9a-fA-F]{1,4}:){7,7}[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,7}:|([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}|([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}|([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}|([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}|[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})|:((:[0-9a-fA-F]{1,4}){1,7}|:)|fe80:(:[0-9a-fA-F]{0,4}){0,4}%[0-9a-zA-Z]{1,}|::(ffff(:0{1,4}){0,1}:){0,1}((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])|([0-9a-fA-F]{1,4}:){1,4}:((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9]))\/[0-9]{1,3}
    [Return]    ${peer_adv_routes}

Configure BGP Neighbor Description
    [Documentation]    Configures the description of a BGP neighbor
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${neighbor}    ${description}    ${route_domain_id}=0
    ${bgp_commands}    set variable    configure terminal,router bgp ${local_as_number},neighbor ${neighbor} description ${description},end,copy running-config startup-config
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    [Return]    ${api_response}

Verify BGP Neighbor Description
    [Documentation]    Verifies the description of a BGP neighbor
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${neighbor}    ${description}    ${route_domain_id}=0
    ${bgp_as_configuration}    Retrieve BGP AS Global Configuration    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    local_as_number=${local_as_number}    route_domain_id=${route_domain_id}
    should contain    ${bgp_as_configuration}    neighbor ${neighbor} description ${description}
    [Return]    ${bgp_as_configuration}
    
Enable ZebOS Logging
    [Documentation]    Enables local logging for the ZebOS daemon
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${route_domain_id}=0    ${log_file}=/var/log/zebos.log
    ${bgp_commands}    set variable    configure terminal,log file ${log_file},end,copy running-config startup-config
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    [Return]    ${api_response}

Verify ZebOS Logging Destination
    [Documentation]    Verifies the configured logging destination for ZebOS
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${route_domain_id}=0    ${log_file}=/var/log/zebos.log
    ${bgp_commands}    set variable    show running-config | grep -e "^ log file /"
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    ${log_file_configuration}    get from dictionary    ${api_response.json}    commandResult
    should contain    ${log_file_configuration}    log file ${log_file}
    [Return]    ${log_file_configuration}
    
Enable BGP Neighbor Change Logging
    [Documentation]    Enables BGP neighbor change logging
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${route_domain_id}=0
    ${bgp_commands}    set variable    configure terminal,router bgp ${local_as_number},bgp log-neighbor-changes,end,copy running-config startup-config
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    [Return]    ${api_response}

Verify BGP Neighbor Change Logging
    [Documentation]    Verifies that bgp log-neighbor-changes exists
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${route_domain_id}=0
    ${bgp_as_configuration}    Retrieve BGP AS Global Configuration    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    local_as_number=${local_as_number}    route_domain_id=${route_domain_id}
    should contain    ${bgp_as_configuration}    bgp log-neighbor-changes
    [Return]    ${bgp_as_configuration}

Configure the BGP Graceful Restart Timer
    [Documentation]    Sets the BGP Graceful Restart Timer
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${graceful_restart_timer}    ${route_domain_id}=0
    ${bgp_commands}    set variable    configure terminal,router bgp ${local_as_number},bgp graceful-restart restart-time ${graceful_restart_timer},end,copy running-config startup-config
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    [Return]    ${api_response}

Verify the BGP Graceful Restart Timer
    [Documentation]    Verifies the BGP graceful restart timer
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${graceful_restart_timer}    ${route_domain_id}=0
    ${bgp_as_configuration}    Retrieve BGP AS Global Configuration    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    local_as_number=${local_as_number}    route_domain_id=${route_domain_id}
    should contain    ${bgp_as_configuration}    bgp graceful-restart restart-time ${graceful_restart_timer}
    [Return]    ${bgp_as_configuration}

Configure IPv4 Kernel Route BGP Redistribution
    [Documentation]    Issues the 'redistribute kernel [route-map]' command
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${route_map}=none    ${route_domain_id}=0
    ${bgp_commands}    set variable if    '${route_map}' == 'none'    configure terminal,router bgp ${local_as_number},redistribute kernel,end,copy running-config startup-config    configure terminal,router bgp ${local_as_number},redistribute kernel route-map ${route_map},end,copy running-config startup-config
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    [Return]    ${api_response}

Verify IPv4 Kernel Route BGP Redistribution
    [Documentation]    Verifies the 'redistribute kernel [route-map]' command
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${route_map}=none    ${route_domain_id}=0
    ${bgp_as_configuration}    Retrieve BGP AS Global Configuration    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    local_as_number=${local_as_number}    route_domain_id=${route_domain_id}
    ${redistribute_configuration}    set variable if    '${route_map}' == 'none'    redistribute kernel    redistribute kernel route-map ${route_map}
    should contain    ${bgp_as_configuration}    ${redistribute_configuration}
    [Return]    ${redistribute_configuration}

Configure IPv4 Connected Route BGP Redistribution
    [Documentation]    Issues the 'redistribute connected [route-map]' command
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${route_map}=none    ${route_domain_id}=0
    ${bgp_commands}    set variable if    '${route_map}' == 'none'    configure terminal,router bgp ${local_as_number},redistribute connected,end,copy running-config startup-config    configure terminal,router bgp ${local_as_number},redistribute connected route-map ${route_map},end,copy running-config startup-config
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    [Return]    ${api_response}

Verify IPv4 Connected Route BGP Redistribution
    [Documentation]    Verifies the 'redistribute connected [route-map]' command
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${route_map}=none    ${route_domain_id}=0
    ${bgp_as_configuration}    Retrieve BGP AS Global Configuration    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    local_as_number=${local_as_number}    route_domain_id=${route_domain_id}
    ${redistribute_configuration}    set variable if    '${route_map}' == 'none'    redistribute connected    redistribute connected route-map ${route_map}
    should contain    ${bgp_as_configuration}    ${redistribute_configuration}
    [Return]    ${redistribute_configuration}

Configure IPv4 Static Route BGP Redistribution
    [Documentation]    Issues the 'redistribute static route-map' command
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${route_map}=none    ${route_domain_id}=0
    ${bgp_commands}    set variable if    '${route_map}' == 'none'    configure terminal,router bgp ${local_as_number},redistribute static,end,copy running-config startup-config    configure terminal,router bgp ${local_as_number},redistribute static route-map ${route_map},end,copy running-config startup-config
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    [Return]    ${api_response}

Verify IPv4 Static Route BGP Redistribution
    [Documentation]    Verifies the 'redistribute static [route-map]' command
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${route_map}=none    ${route_domain_id}=0
    ${bgp_as_configuration}    Retrieve BGP AS Global Configuration    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    local_as_number=${local_as_number}    route_domain_id=${route_domain_id}
    ${redistribute_configuration}    set variable if    '${route_map}' == 'none'    redistribute static    redistribute static route-map ${route_map}
    should contain    ${bgp_as_configuration}    ${redistribute_configuration}
    [Return]    ${redistribute_configuration}

Configure IPv6 Kernel Route BGP Redistribution
    [Documentation]    Issues the 'redistribute kernel route-map' command under the ipv6 address-family
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${route_map}=none    ${route_domain_id}=0
    ${bgp_commands}    set variable if    '${route_map}' == 'none'    configure terminal,router bgp ${local_as_number},address-family ipv6,redistribute kernel,end,copy running-config startup-config    configure terminal,router bgp ${local_as_number},address-family ipv6,redistribute kernel route-map ${route_map},end,copy running-config startup-config
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    [Return]    ${api_response}
 
Verify IPv6 Kernel Route BGP Redistribution
    [Documentation]    Verifies configuration of IPv6 Kernel route redistribution
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${route_map}=none    ${route_domain_id}=0
    ${bgp_as_configuration}    Retrieve BGP AS IPv6 Address-Family Configuration    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    local_as_number=${local_as_number}    route_domain_id=${route_domain_id}
    ${redistribute_configuration}    set variable if    '${route_map}' == 'none'    redistribute kernel    redistribute kernel route-map ${route_map}
    should contain    ${bgp_as_configuration}    ${redistribute_configuration}
    [Return]    ${redistribute_configuration}
    
Configure IPv6 Connected Route BGP Redistribution
    [Documentation]    Issues the 'redistribute connected route-map' command under the ipv6 address-family
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${route_map}=none    ${route_domain_id}=0
    ${bgp_commands}    set variable if    '${route_map}' == 'none'    configure terminal,router bgp ${local_as_number},address-family ipv6,redistribute connected,end,copy running-config startup-config    configure terminal,router bgp ${local_as_number},address-family ipv6,redistribute connected route-map ${route_map},end,copy running-config startup-config
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    [Return]    ${api_response}

Verify IPv6 Connected Route BGP Redistribution
    [Documentation]    Verifies configuration of IPv6 Connected route redistribution
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${route_map}=none    ${route_domain_id}=0
    ${bgp_as_configuration}    Retrieve BGP AS IPv6 Address-Family Configuration    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    local_as_number=${local_as_number}    route_domain_id=${route_domain_id}
    ${redistribute_configuration}    set variable if    '${route_map}' == 'none'    redistribute connected    redistribute connected route-map ${route_map}
    should contain    ${bgp_as_configuration}    ${redistribute_configuration}
    [Return]    ${redistribute_configuration}

Configure IPv6 Static Route BGP Redistribution
    [Documentation]    Issues the 'redistribute static route-map' command under the ipv6 address-family
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${route_map}=none    ${route_domain_id}=0
    ${bgp_commands}    set variable if    '${route_map}' == 'none'    configure terminal,router bgp ${local_as_number},address-family ipv6,redistribute static,end,copy running-config startup-config    configure terminal,router bgp ${local_as_number},address-family ipv6,redistribute static route-map ${route_map},end,copy running-config startup-config
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    [Return]    ${api_response}

Verify IPv6 Static Route BGP Redistribution
    [Documentation]    Verifies configuration of IPv6 Static route redistribution
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${route_map}=none    ${route_domain_id}=0
    ${bgp_as_configuration}    Retrieve BGP AS IPv6 Address-Family Configuration    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    local_as_number=${local_as_number}    route_domain_id=${route_domain_id}
    ${redistribute_configuration}    set variable if    '${route_map}' == 'none'    redistribute static    redistribute static route-map ${route_map}
    should contain    ${bgp_as_configuration}    ${redistribute_configuration}
    [Return]    ${redistribute_configuration}

Configure BGP IPv4 Neighbor Inbound Route-Map
    [Documentation]    Applies an inbound route-map to an IPv4 BGP Neighbor
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${neighbor}    ${route_map_name}    ${route_domain_id}=0
    ${bgp_commands}    set variable    configure terminal,router bgp ${local_as_number},neighbor ${neighbor} route-map ${route_map_name} in,end,copy running-config startup-config
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    [Return]    ${api_response}

Verify BGP IPv4 Neighbor Inbound Route-Map
    [Documentation]    Applies an inbound route-map to an IPv4 BGP Neighbor
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${neighbor}    ${route_map_name}    ${route_domain_id}=0
    ${bgp_as_configuration}    Retrieve BGP AS Global Configuration    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    local_as_number=${local_as_number}    route_domain_id=${route_domain_id}
    should contain    ${bgp_as_configuration}    neighbor ${neighbor} route-map ${route_map_name} in
    [Return]    ${bgp_as_configuration}

Configure BGP IPv4 Neighbor Outbound Route-Map
    [Documentation]    Applies an outbound route-map to an IPv4 BGP Neighbor
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${neighbor}    ${route_map_name}    ${route_domain_id}=0
    ${bgp_commands}    set variable    configure terminal,router bgp ${local_as_number},neighbor ${neighbor} route-map ${route_map_name} out,end,copy running-config startup-config
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    [Return]    ${api_response}

Verify BGP IPv4 Neighbor Outbound Route-Map
    [Documentation]    Applies an outbound route-map to an IPv4 BGP Neighbor
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${neighbor}    ${route_map_name}    ${route_domain_id}=0
    ${bgp_as_configuration}    Retrieve BGP AS Global Configuration    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    local_as_number=${local_as_number}    route_domain_id=${route_domain_id}
    should contain    ${bgp_as_configuration}    neighbor ${neighbor} route-map ${route_map_name} out
    [Return]    ${bgp_as_configuration}
    
Enable BGP IPv4 Neighbor Soft Reconfiguration Inbound
    [Documentation]    Enables Soft Reconfiguration on an IPv4 BGP Neighbor
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${neighbor}    ${route_domain_id}=0
    ${bgp_commands}    set variable    configure terminal,router bgp ${local_as_number},neighbor ${neighbor} soft-reconfiguration inbound,end,copy running-config startup-config
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    [Return]    ${api_response}

Verify Enable BGP IPv4 Neighbor Soft Reconfiguration Inbound
    [Documentation]    Enables Soft Reconfiguration on an IPv4 BGP Neighbor
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${neighbor}    ${route_domain_id}=0
    ${bgp_as_configuration}    Retrieve BGP AS Global Configuration    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    local_as_number=${local_as_number}    route_domain_id=${route_domain_id}
    should contain    ${bgp_as_configuration}    neighbor ${neighbor} soft-reconfiguration inbound
    should not contain    ${bgp_as_configuration}    no neighbor ${neighbor} soft-reconfiguration inbound
    [Return]    ${bgp_as_configuration}

Enable BGP IPv6 Neighbor Soft Reconfiguration Inbound
    [Documentation]    Enables Soft Reconfiguration on an IPv4 BGP Neighbor
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${neighbor}    ${route_domain_id}=0
    ${bgp_commands}    set variable    configure terminal,router bgp ${local_as_number},address-family ipv6,neighbor ${neighbor} soft-reconfiguration inbound,end,copy running-config startup-config
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    [Return]    ${api_response}

Verify Enable BGP IPv6 Neighbor Soft Reconfiguration Inbound
    [Documentation]    Enables Soft Reconfiguration on an IPv4 BGP Neighbor
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${neighbor}    ${route_domain_id}=0
    ${bgp_as_configuration}    Retrieve BGP AS IPv6 Address-Family Configuration    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    local_as_number=${local_as_number}    route_domain_id=${route_domain_id}
    should contain    ${bgp_as_configuration}    neighbor ${neighbor} soft-reconfiguration inbound
    should not contain    ${bgp_as_configuration}    no neighbor ${neighbor} soft-reconfiguration inbound
    [Return]    ${bgp_as_configuration}

Disable the Graceful Restart BGP IPv4 Neighbor Capability
    [Documentation]    Disables the Graceful Restart BGP Neighbor capability
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${neighbor}    ${route_domain_id}=0
    ${bgp_commands}    set variable    configure terminal,router bgp ${local_as_number},no neighbor ${neighbor} capability graceful-restart,end,copy running-config startup-config
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    [Return]    ${api_response}

Verify Disable the Graceful Restart BGP IPv4 Neighbor Capability
    [Documentation]    Verifying disabling the Graceful Restart BGP Neighbor capability
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${neighbor}    ${route_domain_id}=0
    ${bgp_as_configuration}    Retrieve BGP AS IPv6 Address-Family Configuration    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    local_as_number=${local_as_number}    route_domain_id=${route_domain_id}
    should not contain    ${bgp_as_configuration}    neighbor ${neighbor} capability graceful-restart
    should contain    ${bgp_as_configuration}    no neighbor ${neighbor} capability graceful-restart
    [Return]    ${bgp_as_configuration}

Enable the Graceful Restart BGP IPv4 Neighbor Capability
    [Documentation]    Disables the Graceful Restart BGP Neighbor capability
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${neighbor}    ${route_domain_id}=0
    ${bgp_commands}    set variable    configure terminal,router bgp ${local_as_number},neighbor ${neighbor} capability graceful-restart,end,copy running-config startup-config
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    [Return]    ${api_response}

Verify Enable the Graceful Restart BGP IPv4 Neighbor Capability
    [Documentation]    Verifying enabling the Graceful Restart BGP Neighbor capability
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${neighbor}    ${route_domain_id}=0
    ${bgp_as_configuration}    Retrieve BGP AS IPv6 Address-Family Configuration    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    local_as_number=${local_as_number}    route_domain_id=${route_domain_id}
    should contain    ${bgp_as_configuration}    neighbor ${neighbor} capability graceful-restart
    should not contain    ${bgp_as_configuration}    no neighbor ${neighbor} capability graceful-restart
    [Return]    ${bgp_as_configuration}

Disable the Graceful Restart BGP IPv6 Neighbor Capability
    [Documentation]    Disables the Graceful Restart BGP Neighbor capability
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${neighbor}    ${route_domain_id}=0
    ${bgp_commands}    set variable    configure terminal,router bgp ${local_as_number},no neighbor ${neighbor} capability graceful-restart,address-family ipv6,no neighbor ${neighbor} capability graceful-restart,end,copy running-config startup-config
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    [Return]    ${api_response}

Verify Disable the Graceful Restart BGP IPv6 Neighbor Capability
    [Documentation]    Disables the Graceful Restart BGP Neighbor capability
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${neighbor}    ${route_domain_id}=0
    ${bgp_as_configuration}    Retrieve BGP AS IPv6 Address-Family Configuration    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    local_as_number=${local_as_number}    route_domain_id=${route_domain_id}
    should not contain    ${bgp_as_configuration}    \n\ neighbor ${neighbor} capability graceful-restart
    should contain    ${bgp_as_configuration}    no neighbor ${neighbor} capability graceful-restart
    [Return]    ${bgp_as_configuration}

Enable the Graceful Restart BGP IPv6 Neighbor Capability
    [Documentation]    Disables the Graceful Restart BGP Neighbor capability
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${neighbor}    ${route_domain_id}=0
    ${bgp_commands}    set variable    configure terminal,router bgp ${local_as_number},neighbor ${neighbor} capability graceful-restart,end,copy running-config startup-config
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    [Return]    ${api_response}

Verify Enable the Graceful Restart BGP IPv6 Neighbor Capability
    [Documentation]    Disables the Graceful Restart BGP Neighbor capability
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${neighbor}    ${route_domain_id}=0
    ${bgp_as_configuration}    Retrieve BGP AS IPv6 Address-Family Configuration    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    local_as_number=${local_as_number}    route_domain_id=${route_domain_id}
    should contain    ${bgp_as_configuration}    neighbor ${neighbor} capability graceful-restart
    should not contain    ${bgp_as_configuration}    no neighbor ${neighbor} capability graceful-restart
    [Return]    ${bgp_as_configuration}

Create BGP IPv4 Neighbor Peer-Group
    [Documentation]    Creates a BGP IPv4 Peer Group
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${peer_group_name}    ${route_domain_id}=0
    ${bgp_commands}    set variable    configure terminal,router bgp ${local_as_number},neighbor ${peer_group_name} peer-group,end,copy running-config startup-config
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    [Return]    ${api_response}

Retrieve BGP AS Configuration
    [Documentation]    Retrieves the BGP configuration for a single AS
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${route_domain_id}=0
    ${bgp_commands}    set variable    show run bgp | sed -n '/router bgp ${local_as_number}/,/^!/p'
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    ${bgp_configuration}    get from dictionary    ${api_response.json}    commandResult
    [Return]    ${bgp_configuration}

Retrieve BGP AS Global Configuration
    [Documentation]    Retrieves the global "non-address-family" BGP configuration for a single AS
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${route_domain_id}=0
    ${bgp_commands}    set variable    show running-config bgp | sed -n '/router bgp ${local_as_number}/,/^ \!/p' 
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    ${bgp_configuration}    get from dictionary    ${api_response.json}    commandResult
    [Return]    ${bgp_configuration}

Retrieve BGP AS IPv4 Address-Family Configuration
    [Documentation]    Retrieves the IPv4 Address-Family BGP configuration for a single AS
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${route_domain_id}=0
    ${bgp_commands}    set variable    show running-config bgp | sed -n '/router bgp ${local_as_number}/,/^\!/p' | sed -n '/^ address-family ipv4/,/exit-address-family/p' 
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    ${bgp_configuration}    get from dictionary    ${api_response.json}    commandResult
    [Return]    ${bgp_configuration}

Retrieve BGP AS IPv6 Address-Family Configuration
    [Documentation]    Retrieves the IPv6 Address-Family BGP configuration for a single AS
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${route_domain_id}=0
    ${bgp_commands}    set variable    show running-config bgp | sed -n '/router bgp ${local_as_number}/,/^\!/p' | sed -n '/^ address-family ipv6/,/exit-address-family/p' 
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    ${bgp_configuration}    get from dictionary    ${api_response.json}    commandResult
    [Return]    ${bgp_configuration}

Verify BGP IPv4 Neighbor Peer-Group
    [Documentation]    Verifies that a BGP IPv4 Peer Group exists
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${peer_group_name}    ${route_domain_id}=0
    ${bgp_as_configuration}    Retrieve BGP AS Configuration    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    local_as_number=${local_as_number}    route_domain_id=${route_domain_id}
    [Return]    ${bgp_as_configuration}

Configure BGP IPv4 Neighbor Remote AS
    [Documentation]    Specifies a remote-as for a BGP neighbor
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${neighbor}    ${remote_as_number}    ${route_domain_id}=0
    ${bgp_commands}    set variable    configure terminal,router bgp ${local_as_number},neighbor ${neighbor} remote-as ${remote_as_number},end,copy running-config startup-config
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    [Return]    ${api_response}

Verify BGP IPv4 Neighbor Remote AS
    [Documentation]    Verifies a remote-as for a BGP neighbor
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${neighbor}    ${remote_as_number}    ${route_domain_id}=0
    ${bgp_as_configuration}    Retrieve BGP AS Global Configuration    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    local_as_number=${local_as_number}    route_domain_id=${route_domain_id}
    should contain    ${bgp_as_configuration}    neighbor ${neighbor} remote-as ${remote_as_number}
    [Return]    ${bgp_as_configuration}

Configure BGP Neighbor Update Source
    [Documentation]    Specifies an update source interface for a BGP neighbor
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${neighbor}    ${update_source}    ${route_domain_id}=0
    ${bgp_commands}    set variable    configure terminal,router bgp ${local_as_number},neighbor ${neighbor} update-source ${update_source},end,copy running-config startup-config
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    [Return]    ${api_response}

Verify BGP Neighbor Update Source
    [Documentation]    Verifies an update source interface for a BGP neighbor
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${neighbor}    ${update_source}    ${route_domain_id}=0
    ${bgp_as_configuration}    Retrieve BGP AS Global Configuration    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    local_as_number=${local_as_number}    route_domain_id=${route_domain_id}
    should contain    ${bgp_as_configuration}    neighbor ${neighbor} update-source ${update_source}
    [Return]    ${bgp_as_configuration}

Configure BGP Neighbor Timers
    [Documentation]    Sets the keepalive and hold timer values for a BGP neighbor
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${neighbor}    ${keepalive_timer}    ${hold_timer}    ${route_domain_id}=0
    ${bgp_commands}    set variable    configure terminal,router bgp ${local_as_number},neighbor ${neighbor} timers ${keepalive_timer} ${hold_timer},end,copy running-config startup-config
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    [Return]    ${api_response}

Verify BGP Neighbor Timers
    [Documentation]    Verifies the keepalive and hold timer values for a BGP neighbor
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${neighbor}    ${keepalive_timer}    ${hold_timer}    ${route_domain_id}=0
    ${bgp_as_configuration}    Retrieve BGP AS Global Configuration    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    local_as_number=${local_as_number}    route_domain_id=${route_domain_id}
    should contain    ${bgp_as_configuration}    neighbor ${neighbor} timers ${keepalive_timer} ${hold_timer}
    [Return]    ${bgp_as_configuration}

Activate BGP IPv4 Neighbor
    [Documentation]    Activates a BGP IPv4 Neighbor
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${neighbor}    ${route_domain_id}=0
    ${bgp_commands}    set variable    configure terminal,router bgp ${local_as_number},address-family ipv4,neighbor ${neighbor} activate,end,copy running-config startup-config
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    [Return]    ${api_response}

Verify BGP IPv4 Neighbor Activation
    [Documentation]    Verifies activation of a BGP IPv4 Neighbor
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${neighbor}    ${route_domain_id}=0
    ${bgp_as_configuration}    Retrieve BGP AS Global Configuration    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    local_as_number=${local_as_number}    route_domain_id=${route_domain_id}
    should not contain    ${bgp_as_configuration}    no neighbor ${neighbor} activate
    [Return]    ${bgp_as_configuration}
    
Deactivate BGP IPv4 Neighbor
    [Documentation]    Activates a BGP IPv4 Neighbor
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${neighbor}    ${route_domain_id}=0
    ${bgp_commands}    set variable    configure terminal,router bgp ${local_as_number},address-family ipv4,no neighbor ${nighbor} activate,end,copy running-config startup-config
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    [Return]    ${api_response}

Verify BGP IPv4 Neighbor Deactivation
    [Documentation]    Verifies deactivation of a BGP IPv4 Neighbor
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${neighbor}    ${route_domain_id}=0
    ${bgp_as_configuration}    Retrieve BGP AS Global Configuration    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    local_as_number=${local_as_number}    route_domain_id=${route_domain_id}
    should contain    ${bgp_as_configuration}    no neighbor ${neighbor} activate
    [Return]    ${bgp_as_configuration}
  
Activate BGP IPv6 Neighbor
    [Documentation]    Activates a BGP IPv4 Neighbor
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${neighbor}    ${route_domain_id}=0
    ${bgp_commands}    set variable    configure terminal,router bgp ${local_as_number},address-family ipv6,neighbor ${neighbor} activate,end,copy running-config startup-config
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    [Return]    ${api_response}

Verify BGP IPv6 Neighbor Activation
    [Documentation]    Verifies activation of a BGP IPv4 Neighbor
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${neighbor}    ${route_domain_id}=0
    ${bgp_as_configuration}    Retrieve BGP AS IPv6 Address-Family Configuration    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    local_as_number=${local_as_number}    route_domain_id=${route_domain_id}
    should not contain    ${bgp_as_configuration}    no neighbor ${neighbor} activate
    [Return]    ${bgp_as_configuration}
    
Deactivate BGP IPv6 Neighbor
    [Documentation]    Activates a BGP IPv4 Neighbor
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${neighbor}    ${route_domain_id}=0
    ${bgp_commands}    set variable    configure terminal,router bgp ${local_as_number},address-family ipv6,no neighbor ${nighbor} activate,end,copy running-config startup-config
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    [Return]    ${api_response}

Verify BGP IPv6 Neighbor Deactivation
    [Documentation]    Verifies deactivation of a BGP IPv4 Neighbor
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${neighbor}    ${route_domain_id}=0
    ${bgp_as_configuration}    Retrieve BGP AS IPv6 Address-Family Configuration    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    local_as_number=${local_as_number}    route_domain_id=${route_domain_id}
    should not contain    ${bgp_as_configuration}   \n\ neighbor ${neighbor} activate\n
    should contain    ${bgp_as_configuration}    \n\ no neighbor ${neighbor} activate\n
    [Return]    ${bgp_as_configuration}

Create BGP IPv6 Neighbor Peer-Group
    [Documentation]    Creates a BGP IPv6 Neighbor Peer-Group
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${peer_group_name}    ${route_domain_id}=0      
    ${bgp_commands}    set variable    configure terminal,router bgp ${local_as_number},neighbor ${peer_group_name} peer-group,end,copy running-config startup-config
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    [Return]    ${api_response}

Verify BGP IPv6 Neighbor Peer-Group
    [Documentation]    Creates a BGP IPv6 Neighbor Peer-Group
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${peer_group_name}    ${route_domain_id}=0      
    ${bgp_as_configuration}    Retrieve BGP AS Global Configuration    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    local_as_number=${local_as_number}    route_domain_id=${route_domain_id}
    should contain    ${bgp_as_configuration}    neighbor ${peer_group_name} peer-group
    [Return]    ${bgp_as_configuration}

Create BGP IPv6 Neighbor Peer-Group Remote AS
    [Documentation]    Configures the remote-AS on a BGP peer-group
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${peer_group_name}    ${remote_as_number}    ${route_domain_id}=0
    ${bgp_commands}    set variable    configure terminal,router bgp ${local_as_number},neighbor ${peer_group_name} remote-as ${remote_as_number},end,copy running-config startup-config                
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    [Return]    ${api_response}

Verify BGP IPv6 Neighbor Peer-Group Remote AS
    [Documentation]    Configures the remote-AS on a BGP peer-group
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${peer_group_name}    ${remote_as_number}    ${route_domain_id}=0
    ${bgp_as_configuration}    Retrieve BGP AS Global Configuration    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    local_as_number=${local_as_number}    route_domain_id=${route_domain_id}
    should contain    ${bgp_as_configuration}    neighbor ${peer_group_name} remote-as ${remote_as_number}
    [Return]    ${bgp_as_configuration}

Configure IPv6 BGP Neighbor Route-Map
    [Documentation]    Applies a route-map to an existing IPv6 BGP Neighbor
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${neighbor}    ${route_map_name}    ${route_map_direction}    ${route_domain_id}=0
    ${bgp_commands}    set variable    configure terminal,router bgp ${local_as_number},address-family ipv6,neighbor ${neighbor} route-map ${route_map_name} ${route_map_direction},end,copy running-config startup-config
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    [Return]    ${api_response}

Verify IPv6 BGP Neighbor Route-Map
    [Documentation]    Applies a route-map to an existing IPv6 BGP Neighbor
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${local_as_number}    ${neighbor}    ${route_map_name}    ${route_map_direction}    ${route_domain_id}=0
    ${bgp_as_configuration}    Retrieve BGP AS IPv6 Address-Family Configuration    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    local_as_number=${local_as_number}    route_domain_id=${route_domain_id}
    should contain    ${bgp_as_configuration}    neighbor ${neighbor} route-map ${route_map_name}
    [Return]    ${bgp_as_configuration}

Create ZebOS Static Route on the BIG-IP
    [Documentation]    Creates a static route inside of the ZebOS dynamic routing daemon on the BIG-IP
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${network}    ${gateway}    ${route_domain_id}=0
    ${bgp_commands}    set variable    configure terminal,ip route ${network} ${gateway},end,copy running-config startup-config
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    [Return]    ${api_response}

Verify ZebOS Static Route on the BIG-IP
    [Documentation]    Creates a static route inside of the ZebOS dynamic routing daemon on the BIG-IP
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${network}    ${gateway}    ${route_domain_id}=0
    ${bgp_commands}    set variable    show running-config ip route
    ${api_response}    Run BGP Commands on BIG-IP    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    commands=${bgp_commands}    route_domain_id=${route_domain_id}
    ${bgp_configuration}    get from dictionary    ${api_response.json}    commandResult
    should contain    ${bgp_configuration}    ip route ${network} ${gateway}
    [Return]    ${bgp_configuration}

Enable BFD GTSM on the BIG-IP
    [Documentation]    Issues the "bfd gtsm enable" command on the ZebOS daemon for a route-domain
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
        ${bgp_commands}    set variable if    '${match_statement' == 'all'    configure terminal,route-map ${route_map_name} ${action} ${sequence},end,copy running-config startup-config    configure terminal,route-map ${route_map_name} ${action} ${sequence},match ${match_statement},end,copy running-config startup-config
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
 
#######
## cm
#######

Get CM Self Device
    [Documentation]    Retrieves the CM device configuration of the local BIG-IP (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/bigip-system-device-service-clustering-administration-13-1-0/5.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}
    ${api_uri}    Set Variable    /mgmt/tm/cm/device
    ${api_response}    BIG-IP iControl BasicAuth GET    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}
    Should Be Equal As Strings    ${api_response.status_code}    200
    ${api_response_json}    to Json    ${api_response.text}
    ${api_response_dict}    Convert to Dictionary    ${api_response_json}
    ${items_list}    Get from Dictionary    ${api_response_dict}    items
    FOR    ${current_device}    IN    @{items_list}
        ${self_device_flag}    Get from Dictionary    ${current_device}    selfDevice
        ${cm_self_device}    Set Variable If    '${self_device_flag}' == 'true'    ${current_device}
        return from keyword if    '${self_device_flag}' == 'true'    ${cm_self_device}
    END
    [Return]    ${cm_self_device}

Retrieve BIG-IP CM Hostname
    [Documentation]    Retrieves the CM hostname of the local BIG-IP (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/bigip-system-device-service-clustering-administration-13-1-0/5.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}
    ${cm_self_device}    Get CM Self Device    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}
    ${cm_hostname}    Get From Dictionary    ${cm_self_device}    hostname
    [Return]    ${cm_hostname}

Retrieve BIG-IP CM Name
    [Documentation]    Retrieves the CM object name of the local BIG-IP (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/bigip-system-device-service-clustering-administration-13-1-0/5.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}
    ${cm_self_device}    Get CM Self Device    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}
    ${cm_name}    Get From Dictionary    ${cm_self_device}    name
    [Return]    ${cm_name}

Retrieve TMOS Version
    [Documentation]    Retrieves the CM TMOS version of the local BIG-IP (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/bigip-system-device-service-clustering-administration-13-1-0/5.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}
    ${cm_self_device}    Get CM Self Device    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}
    ${cm_version}    Get From Dictionary    ${cm_self_device}    version
    [Return]    ${cm_version}

Retrieve TMOS Build
    [Documentation]    Retrieves the CM TMOS build of the local BIG-IP (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/bigip-system-device-service-clustering-administration-13-1-0/5.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}
    ${cm_self_device}    Get CM Self Device    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}
    ${cm_build}    Get From Dictionary    ${cm_self_device}    build
    [Return]    ${cm_build}

Retrieve TMOS Edition
    [Documentation]    Retrieves the CM TMOS edition of the local BIG-IP (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/bigip-system-device-service-clustering-administration-13-1-0/5.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}
    ${cm_self_device}    Get CM Self Device    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}
    ${cm_edition}    Get From Dictionary    ${cm_self_device}    edition
    [Return]    ${cm_edition}

Retrieve CM Timezone
    [Documentation]    Retrieves the CM timezone of the local BIG-IP (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/bigip-system-device-service-clustering-administration-13-1-0/5.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}
    ${cm_self_device}    Get CM Self Device    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}
    ${cm_timezone}    Get From Dictionary    ${cm_self_device}    timeZone
    [Return]    ${cm_timezone}

Retrieve CM Platform ID
    [Documentation]    Retrieves the CM platform ID of the local BIG-IP (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/bigip-system-device-service-clustering-administration-13-1-0/5.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}
    ${cm_self_device}    Get CM Self Device    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}
    ${cm_platform_id}    Get From Dictionary    ${cm_self_device}    platformId
    [Return]    ${cm_platform_id}

Retrieve CM Multicast Port
    [Documentation]    Retrieves the CM multicast port of the local BIG-IP (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/bigip-system-device-service-clustering-administration-13-1-0/5.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}
    ${cm_self_device}    Get CM Self Device    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}
    ${cm_multicast_port}    Get From Dictionary    ${cm_self_device}    multicastPort
    [Return]    ${cm_multicast_port}

Retrieve CM Multicast IP
    [Documentation]    Retrieves the CM multicast IP address of the local BIG-IP (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/bigip-system-device-service-clustering-administration-13-1-0/5.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}
    ${cm_self_device}    Get CM Self Device    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}
    ${cm_multicast_ip}    Get From Dictionary    ${cm_self_device}    multicastIp
    [Return]    ${cm_multicast_ip}

Retrieve CM Mirror IP
    [Documentation]    Retrieves the CM connection mirroring IP address of the local BIG-IP (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/bigip-system-device-service-clustering-administration-13-1-0/5.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}
    ${cm_self_device}    Get CM Self Device    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}
    ${cm_mirror_ip}    Get From Dictionary    ${cm_self_device}    mirrorIp
    [Return]    ${cm_mirror_ip}

Retrieve CM Secondary Mirror IP
    [Documentation]    Retrieves the CM secondary mirroring IP address of the local BIG-IP (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/bigip-system-device-service-clustering-administration-13-1-0/5.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}
    ${cm_self_device}    Get CM Self Device    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}
    ${cm_mirror_secondary_ip}    Get From Dictionary    ${cm_self_device}    mirrorSecondaryIp
    [Return]    ${cm_mirror_secondary_ip}

Retrieve CM Marketing Name
    [Documentation]    Retrieves the CM marketing name,or platform name, of the local BIG-IP (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/bigip-system-device-service-clustering-administration-13-1-0/5.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}
    ${cm_self_device}    Get CM Self Device    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}
    ${cm_marketing_name}    Get From Dictionary    ${cm_self_device}    marketingName
    [Return]    ${cm_marketing_name}

Retrieve CM Management IP
    [Documentation]    Retrieves the CM management-ip of the local BIG-IP (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/bigip-system-device-service-clustering-administration-13-1-0/5.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}
    ${cm_self_device}    Get CM Self Device    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}
    ${cm_management_ip}    Get From Dictionary    ${cm_self_device}    managementIp
    [Return]    ${cm_management_ip}

Retrieve CM Failover State
    [Documentation]    Retrieves the CM failover state of the local BIG-IP (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/bigip-system-device-service-clustering-administration-13-1-0/5.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}
    ${cm_self_device}    Get CM Self Device    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}
    ${cm_failover_state}    Get From Dictionary    ${cm_self_device}    failoverState
    [Return]    ${cm_failover_state}

Retrieve CM Configsync IP
    [Documentation]    Retrieves the CM config sync IP address of the local BIG-IP (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/bigip-system-device-service-clustering-administration-13-1-0/5.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}
    ${cm_self_device}    Get CM Self Device    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}
    ${cm_configsync_ip}    Get From Dictionary    ${cm_self_device}    configsyncIp
    [Return]    ${cm_configsync_ip}

Retrieve CM Active Modules
    [Documentation]    Retrieves the CM active modules list of the local BIG-IP (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/bigip-system-device-service-clustering-administration-13-1-0/5.html)
    ${cm_self_device}    Get CM Self Device    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}
    ${cm_active_modules}    Get From Dictionary    ${cm_self_device}    activeModules
    [Return]    ${cm_active_modules}

Add Device to CM Trust
    [Documentation]    Creates certificate-based trust between two BIG-IPs using one-time username/password credentials for the exchange (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/bigip-system-device-service-clustering-administration-13-1-0/5.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${peer_bigip_host}    ${peer_bigip_username}    ${peer_bigip_password}    ${peer_bigip_cm_name}
    ${api_payload}    Create Dictionary    command    run    name    Root    caDevice    ${True}    device    ${peer_bigip_host}    deviceName    ${peer_bigip_cm_name}    username    ${peer_bigip_username}    password    ${peer_bigip_password}
    ${api_uri}    Set Variable    /mgmt/tm/cm/add-to-trust
    ${api_response}    BIG-IP iControl BasicAuth POST    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Verify Trust Sync Status 13.1.1.4
    [Documentation]    Verifies that two BIG-IPs are in a trust group and in-sync (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/bigip-system-device-service-clustering-administration-13-1-0/5.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}
    ${api_uri}    Set variable    /mgmt/tm/cm/sync-status
    ${api_response}    BIG-IP iControl BasicAuth GET    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}
    ${api_response_json}    to Json    ${api_response.text}
    ${bigip_mode_entries}    Get from Dictionary    ${api_response_json}    entries
    ${bigip_mode_selflink}    Get from Dictionary    ${bigip_mode_entries}    https://localhost/mgmt/tm/cm/sync-status/0
    ${bigip_mode_nestedstats}    Get from Dictionary    ${bigip_mode_selflink}    nestedStats
    ${bigip_mode_sync_entries}    Get from Dictionary    ${bigip_mode_nestedstats}    entries
    ${bigip_mode_status}    Get from Dictionary    ${bigip_mode_sync_entries}    status
    ${bigip_mode_status_description}    Get from Dictionary    ${bigip_mode_status}    description
    ${expected_response}    Create Dictionary    description    In Sync
    Dictionaries Should Be Equal    ${bigip_mode_status}    ${expected_response}
    [Return]    ${api_response}

Create CM Device Group
    [Documentation]    Creates a CM device group on the BIG-IP (syncs across trust-group members) (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/bigip-system-device-service-clustering-administration-13-1-0/5.html))
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${cm_device_group_name}
    ${api_uri}    Set Variable    /mgmt/tm/cm/device-group
    ${api_payload}    Create Dictionary    name    ${cm_device_group_name}    type    sync-failover
    ${api_response}    BIG-IP iControl BasicAuth POST    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response.text}

Add Device to CM Device Group
    [Documentation]    Adds a BIG-IP to a CM device group (syncs across trust-group members) (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/bigip-system-device-service-clustering-administration-13-1-0/5.html))
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${cm_device_group_name}    ${cm_device_name}
    ${api_uri}    Set Variable    /mgmt/tm/cm/device-group/~Common~${cm_device_group_name}/devices
    ${api_payload}    Create Dictionary    name    ${cm_device_name}
    ${api_response}    BIG-IP iControl BasicAuth POST    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Enable CM Auto Sync
    [Documentation]    Enables auto-sync on peers in a DSC (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/bigip-system-device-service-clustering-administration-13-1-0/5.html))
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${cm_device_group_name}
    ${api_uri}    Set Variable    /mgmt/tm/cm/device-group/~Common~${cm_device_group_name}/
    ${api_payload}    Create Dictionary    autoSync    enabled
    ${api_response}    BIG-IP iControl BasicAuth PATCH    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Disable CM Auto Sync
    [Documentation]    Disables auto-sync on peers in a DSC (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/bigip-system-device-service-clustering-administration-13-1-0/5.html))
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${cm_device_group_name}
    ${api_uri}    Set Variable    /mgmt/tm/cm/device-group/~Common~${cm_device_group_name}/
    ${api_payload}    Create Dictionary    autoSync    disabled
    ${api_response}    BIG-IP iControl BasicAuth PATCH    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Manually Sync BIG-IP Configurations
    [Documentation]    Manually syncs the configuration between peers in a config-sync group (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/bigip-system-device-service-clustering-administration-13-1-0/5.html))
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${cm_device_group_name}
    ${api_uri}    Set Variable    /mgmt/tm/cm/config-sync
    ${api_payload}    Create Dictionary    command    run    utilCmdArgs    to-group ${cm_device_group_name}
    ${api_response}    BIG-IP iControl BasicAuth POST    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    Sleep    3s
    [Return]    ${api_response}

Move CM Device to New Hostname
    [Documentation]    Renames the local cm device (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/bigip-system-device-service-clustering-administration-13-1-0/5.html))
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${current_name}    ${target}
    ${api_uri}    Set Variable    /mgmt/tm/cm/device
    ${api_payload}    Create Dictionary    command    mv    name    ${current_name}    target    ${target}
    ${api_response}    BIG-IP iControl BasicAuth POST    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Configure CM Device Unicast Address
    [Documentation]    Configures the IP address used to contact the peer for initial certificate based auth configuration (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/bigip-system-device-service-clustering-administration-13-1-0/5.html))
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${device_name}    ${unicast_address}
    ${api_uri}    Set Variable    /mgmt/tm/cm/device/~Common~${device_name}
    ${unicast_address_dict}    Create Dictionary    ip    ${unicast_address}
    ${unicast_address_list}    Create List    ${unicast_address_dict}
    ${api_payload}    Create Dictionary    unicast-address    ${unicast_address_list}
    ${api_response}    BIG-IP iControl BasicAuth PATCH    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Configure CM Device Mirror IP
    [Documentation]    Defines the IP address used for mirroring connections between a stateful device pair (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/bigip-system-device-service-clustering-administration-13-1-0/5.html))
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${device_name}    ${mirror_ip}
    ${api_uri}    Set Variable    /mgmt/tm/cm/device/~Common~${device_name}
    ${api_payload}    Create Dictionary    mirrorIp    ${mirror_ip}
    ${api_response}    BIG-IP iControl BasicAuth PATCH    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Configure CM Device Configsync IP
    [Documentation]    Configures the IP address used for configuration replication between pairs in a config-sync group (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/bigip-system-device-service-clustering-administration-13-1-0/5.html))
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${device_name}    ${configsync_ip}
    ${api_uri}    Set Variable    /mgmt/tm/cm/device/~Common~${device_name}
    ${api_payload}    Create Dictionary    configsyncIp    ${configsync_ip}
    ${api_response}    BIG-IP iControl BasicAuth PATCH    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Retrieve CM Sync Mode
    [Documentation]    Retrieves the device's cluster management sync mode
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}
    ${api_uri}    set variable    /mgmt/tm/cm/sync-status
    ${api_response}    BIG-IP iControl BasicAuth GET    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}
    Should Be Equal As Strings    ${api_response.status_code}    200
    ${cm_sync_mode}    set variable    ${api_response.json['entries']['https://localhost/mgmt/tm/cm/sync-status/0']['nestedStats']['entries']['mode']['description']}
    [Return]    ${cm_sync_mode}
            
Retrieve CM Sync LED Color
    [Documentation]    Retrieves the device's cluster management sync mode
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}
    ${api_uri}    set variable    /mgmt/tm/cm/sync-status
    ${api_response}    BIG-IP iControl BasicAuth GET    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}
    Should Be Equal As Strings    ${api_response.status_code}    200
    ${cm_sync_led_color}    set variable    ${api_response.json['entries']['https://localhost/mgmt/tm/cm/sync-status/0']['nestedStats']['entries']['color']['description']}
    [Return]    ${cm_sync_led_color}

Verify CM Sync LED Color is Green
    [Documentation]    Retrieves the device's cluster management sync mode
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}
    ${api_uri}    set variable    /mgmt/tm/cm/sync-status
    ${api_response}    BIG-IP iControl BasicAuth GET    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}
    Should Be Equal As Strings    ${api_response.status_code}    200
    ${cm_sync_led_color}    set variable    ${api_response.json['entries']['https://localhost/mgmt/tm/cm/sync-status/0']['nestedStats']['entries']['color']['description']}
    should be equal as strings    '${cm_sync_led_color}'    'green'
    [Return]    ${cm_sync_led_color}

Verify CM Sync LED Color is Blue
    [Documentation]    Retrieves the device's cluster management sync mode
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}
    ${api_uri}    set variable    /mgmt/tm/cm/sync-status
    ${api_response}    BIG-IP iControl BasicAuth GET    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}
    Should Be Equal As Strings    ${api_response.status_code}    200
    ${cm_sync_led_color}    set variable    ${api_response.json['entries']['https://localhost/mgmt/tm/cm/sync-status/0']['nestedStats']['entries']['color']['description']}
    should be equal as strings    '${cm_sync_led_color}'    'blue'
    [Return]    ${cm_sync_led_color}
    
Retrieve CM Sync Status
    [Documentation]    Retrieves the device's cluster management sync status
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}
    ${api_uri}    set variable    /mgmt/tm/cm/sync-status
    ${api_response}    BIG-IP iControl BasicAuth GET    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}
    Should Be Equal As Strings    ${api_response.status_code}    200
    ${cm_sync_status}    set variable    ${api_response.json['entries']['https://localhost/mgmt/tm/cm/sync-status/0']['nestedStats']['entries']['status']['description']}
    [Return]    ${cm_sync_status}

Retrieve CM Sync Summary
    [Documentation]    Retrieves the device's cluster management sync summary
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}
    ${api_uri}    set variable    /mgmt/tm/cm/sync-status
    ${api_response}    BIG-IP iControl BasicAuth GET    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}
    Should Be Equal As Strings    ${api_response.status_code}    200
    ${cm_sync_summary}    set variable    ${api_response.json['entries']['https://localhost/mgmt/tm/cm/sync-status/0']['nestedStats']['entries']['summary']['description']}
    [Return]    ${cm_sync_summary}

Create a Traffic Group
    [Documentation]    Creates a new traffic group, which is an object that contains items that become grouped together for HA purposes (See https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/bigip-system-device-service-clustering-administration-13-1-0/6.html#guid-dad72e46-5f70-4938-8711-2a435b236369)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${name}    ${partition}=Common   ${autoFailbackEnabled}=false    ${autoFailbackTime}=${60}    ${defaultDevice}=    ${description}=Created by Robot Framework    ${failoverMethod}=ha-order    ${haLoadFactor}=${1}    ${haOrder}=none    ${mac}=none    ${monitor}=
    ${defaultHaOrder}    Create List
    ${haOrder}    set variable if    "${haOrder}" == "none"    none    ${haOrder}
    ${defaultMonitor}    Create Dictionary
    ${monitor}    set variable if    '${monitor}' == '${EMPTY}'    ${defaultMonitor}    ${monitor}
    ${api_uri}    set variable    /mgmt/tm/cm/traffic-group
    ${api_payload}    Create Dictionary    name=${name}    autoFailbackEnabled=${autoFailbackEnabled}    autoFailbackTime=${autoFailbackTime}    defaultDevice=${defaultDevice}    description=${description}    failoverMethod=${failoverMethod}    haLoadFactor=${haLoadFactor}    haOrder=${haOrder}    mac=${mac}    monitor=${monitor}
    ${api_response}    BIG-IP iControl BasicAuth POST    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Verify a Traffic Group
    [Documentation]    Verifies that a new traffic group was properly created (See https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/bigip-system-device-service-clustering-administration-13-1-0/6.html#guid-dad72e46-5f70-4938-8711-2a435b236369)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${name}    ${partition}=Common   ${autoFailbackEnabled}=false    ${autoFailbackTime}=${60}    ${defaultDevice}=    ${description}=Created by Robot Framework    ${failoverMethod}=ha-order    ${haLoadFactor}=${1}    ${haOrder}=none    ${mac}=none    ${monitor}=
    ${defaultHaOrder}    Create List
    ${haOrder}    set variable if    "${haOrder}" == "none"    none    ${haOrder}
    ${defaultMonitor}    Create Dictionary
    ${monitor}    set variable if    '${monitor}' == '${EMPTY}'    ${defaultMonitor}    ${monitor}
    ${api_uri}    set variable    /mgmt/tm/cm/traffic-group/~${partition}~${name}
    ${api_response}    BIG-IP iControl BasicAuth GET    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}
    Should Be Equal As Strings    ${api_response.status_code}    200
    ${actual_configuration}    set variable    ${api_response.json}
    ${expected_configuration}    Create Dictionary    name=${name}    autoFailbackEnabled=${autoFailbackEnabled}    autoFailbackTime=${autoFailbackTime}    defaultDevice=${defaultDevice}    description=${description}    failoverMethod=${failoverMethod}    haLoadFactor=${haLoadFactor}    haOrder=${haOrder}    mac=${mac}    monitor=${monitor}    
    run keyword if    '${haOrder}' == 'none'   remove from dictionary    ${expected_configuration}    haOrder
    run keyword if    '${defaultDevice}' == ''    remove from dictionary    ${expected_configuration}    defaultDevice
    Dictionary Should Contain Subdictionary    ${actual_configuration}    ${expected_configuration}    
    [Return]    ${api_response}

Retrieve the HA Status of a Traffic-Group Member
    [Documentation]    Returns a dictionary of CM devices in a traffic group and their HA state
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${cm_device_name}    ${traffic_group}=traffic-group-1    ${partition}=Common
    ${cm_device_status}    set variable    device not found
    ${api_uri}    set variable    /mgmt/tm/cm/traffic-group/~${partition}~${traffic_group}/stats
    ${api_response}    BIG-IP iControl BasicAuth GET    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}
    Should Be Equal As Strings    ${api_response.status_code}    200
    ${cm_device_status_dict}    get from dictionary    ${api_response.json}    entries
    FOR    ${key}    IN    @{cm_device_status_dict.keys()}
        ${current_device}    get from dictionary    ${cm_device_status_dict}    ${key}
        ${current_device_hostname_nestedStats}    get from dictionary    ${current_device}    nestedStats
        ${current_device_hostname_entries}    get from dictionary    ${current_device_hostname_nestedStats}    entries
        ${current_device_hostname_deviceName}    get from dictionary    ${current_device_hostname_entries}    deviceName
        ${current_device_hostname}    get from dictionary    ${current_device_hostname_deviceName}    description
        ${current_device_status_nestedStats}    get from dictionary    ${current_device}    nestedStats
        ${current_device_status_entries}    get from dictionary    ${current_device_status_nestedStats}    entries
        ${current_device_status_failoverState}    get from dictionary    ${current_device_status_entries}    failoverState
        ${current_device_status}    get from dictionary    ${current_device_status_failoverState}    description
        ${cm_device_status}    set variable if    '${current_device_hostname}' == '\/${partition}\/${cm_device_name}'    ${current_device_status}    device not found
        Return from keyword if    '${current_device_hostname}' == '\/${partition}\/${cm_device_name}'    ${cm_device_status}    
    END
    [Return]    ${cm_device_status}

Assign HA Group to Traffic Group
    [Documentation]    Configures an HA group on a traffic-group so the failover status of the traffic group is managed for HA
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${ha_group}    ${traffic_group}    ${partition}=Common
    ${monitor_dict}    create dictionary    haGroup=${ha_group}    
    ${api_uri}    set variable    /mgmt/tm/cm/traffic-group/~${partition}~${traffic_group}
    ${api_payload}    create dictionary    kind=tm:cm:traffic-group:traffic-groupstate    monitor=${monitor_dict}    failover-method=ha-score    
    ${api_response}    BIG-IP iControl BasicAuth PATCH    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Remove HA Group from Traffic Group
    [Documentation]    Removes the preference list of devices for HA from a traffic-group
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${ha_group}    ${traffic_group}    ${partition}=Common
    ${monitor_dict}    create dictionary    haGroup=    
    ${api_uri}    set variable    /mgmt/tm/cm/traffic-group/~${partition}~${traffic_group}
    ${api_payload}    create dictionary    kind=tm:cm:traffic-group:traffic-groupstate    monitor=${monitor_dict}    failover-method=ha-order            
    ${api_response}    BIG-IP iControl BasicAuth PATCH    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Enable Auto Failback on a BIG-IP Traffic Group
    [Documentation]    Enables the BIG-IPs to automatically fail back to a "preferred" cluster member, exactly like preemption in HSRP/VRRP
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${traffic_group}    ${partition}=Common
    ${api_uri}    set variable    /mgmt/tm/cm/traffic-group/~${partition}~${traffic_group}
    ${api_payload}    create dictionary    autoFailbackEnabled=${true}
    ${api_response}    BIG-IP iControl BasicAuth PATCH    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Disable Auto Failback on a BIG-IP Traffic Group
    [Documentation]    Disables auto failback on a BIG-IP traffic group; works similar to preempt in HSRP (See https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/bigip-device-service-clustering-admin-11-5-0/8.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${traffic_group}    ${partition}=Common
    ${api_uri}    set variable    /mgmt/tm/cm/traffic-group/~${partition}~${traffic_group}
    ${api_payload}    create dictionary    autoFailbackEnabled=${false}
    ${api_response}    BIG-IP iControl BasicAuth PATCH    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Configure BIG-IP Traffic Group HA Device Order
    [Documentation]    Configures a list of HA devices in order of preference for which one should be active (See https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/bigip-device-service-clustering-admin-11-5-0/8.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${traffic_group}    ${ha_device_order}    ${partition}=Common
    ${api_uri}    set variable    /mgmt/tm/cm/traffic-group/~${partition}~${traffic_group}
    ${ha_device_order}    convert to list    ${ha_device_order}
    ${api_payload}    create dictionary    haOrder=${ha_device_order}
    ${api_response}    BIG-IP iControl BasicAuth PATCH    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Retrieve a BIG-IP Traffic Group Configuration
    [Documentation]    Records the configuration of a traffic-group on the BIG-IP (See https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/bigip-device-service-clustering-admin-11-5-0/8.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${traffic_group}    ${partition}=Common
    ${api_uri}    set variable    /mgmt/tm/cm/traffic-group/~${partition}~${traffic_group}
    ${api_response}    BIG-IP iControl BasicAuth GET    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}
    
########
## gtm
########

Create BIG-IP DNS Listener
    [Documentation]    Configures a VIP for listening for DNS requests (https://support.f5.com/csp/article/K14510)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${name}    ${address}    ${mask}    ${partition}=Common    ${ip-protocol}=udp
    ${api_uri}    Set Variable    /mgmt/tm/gtm/listener
    ${api_payload}    Create Dictionary    name=${name}    address=${address}    mask=${mask}    partition=${partition}    ipProtocol=${ip-protocol}
    ${api_response}    BIG-IP iControl BasicAuth POST    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Create a BIG-IP DNS Data Center
    [Documentation]    Creates a data center obect in BIG-IP DNS that specifies a geographic location of services (https://support.f5.com/csp/article/K13347)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${name}    ${location}    ${description}=Created by Robot Framework    ${partition}=Common
    ${api_uri}    Set Variable    /mgmt/tm/gtm/datacenter
    ${api_payload}    Create Dictionary    name=${name}    location=${location}    description=${description}    partition=${partition}
    ${api_response}    BIG-IP iControl BasicAuth POST    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Create a BIG-IP DNS Server
    [Documentation]    Creates a BIG-IP DNS server object
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${name}    ${datacenter}    ${devices}    ${expose-route-domains}=no    ${partition}=Common    ${description}=Created by Robot Framework    ${virtualServerDiscovery}=disabled    ${product}=bigip
    ${api_uri}    Set Variable    /mgmt/tm/gtm/server
    ${api_payload}    Create Dictionary    name=${name}    partition=${partition}    datacenter=${datacenter}    exposeRouteDomains=${expose-route-domains}    description=${description}    virtualServerDiscovery=${virtualServerDiscovery}    product=${product}    devices=${devices}
    ${api_response}    BIG-IP iControl BasicAuth POST    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Add Devices to a BIG-IP DNS Server
    [Documentation]    Adds a BIG-IP LTM to the BIG-IP DNS Configuration
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${name}    ${server_name}    ${addresses}    ${partition}=Common
    ${api_uri}    Set Variable    /mgmt/tm/gtm/server/~${partition}~${server_name}/devices
    ${api_payload}    Create Dictionary    name=${name}    partition=${partition}    addresses=${addresses}
    ${api_response}    BIG-IP iControl BasicAuth POST    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

#############
## ltm node
#############

Create an LTM Node
    [Documentation]    Creates a node in LTM (https://techdocs.f5.com/content/kb/en-us/products/big-ip_ltm/manuals/product/ltm-basics-13-0-0/3.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${name}    ${address}    ${partition}=Common    ${route_domain_id}=0    ${connectionLimit}=0    ${dynamicRatio}=1   ${description}=Robot Framework  ${monitor}=default  ${rateLimit}=disabled
    ${api_payload}    create dictionary   name=${name}   address=${address}%${route_domain_id}    partition=${partition}    connectionLimit=${connectionLimit}   dynamicRatio=${dynamicRatio}    description=${description}  monitor=${monitor}  rateLimit=${rateLimit}
    ${api_uri}    set variable    /mgmt/tm/ltm/node
    ${api_response}    BIG-IP iControl BasicAuth POST    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

List LTM Node Configuration
    [Documentation]    Lists existing nodes in LTM (https://techdocs.f5.com/content/kb/en-us/products/big-ip_ltm/manuals/product/ltm-basics-13-0-0/3.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${node_name}    ${node_partition}=Common
    ${api_uri}    set variable    /mgmt/tm/ltm/node/~${node_partition}~${node_name}
    ${api_response}    BIG-IP iControl BasicAuth GET    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Show LTM Node Statistics
    [Documentation]    Retrieves statistics for a single LTM node (https://techdocs.f5.com/content/kb/en-us/products/big-ip_ltm/manuals/product/ltm-basics-13-0-0/3.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${node_name}    ${node_partition}=Common
    ${api_uri}    set variable    /mgmt/tm/ltm/node/~${node_partition}~${node_name}/stats
    ${api_response}    BIG-IP iControl BasicAuth GET    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Enable an LTM Node
    [Documentation]    Enables an LTM node, which makes it available to all assigned pools (https://support.f5.com/csp/article/K13310)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${node_name}   ${node_partition}=Common
    ${api_uri}    set variable    /mgmt/tm/ltm/node/~${node_partition}~${node_name}/stats
    ${api_payload}    Create Dictionary    session=user-enabled
    ${api_response}    BIG-IP iControl BasicAuth PATCH    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Disable an LTM Node
    [Documentation]    Disables an LTM node; Nodes that have been disabled accept only new connections that match an existing persistence session (https://support.f5.com/csp/article/K13310)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${node_name}   ${node_partition}=Common
    ${api_uri}    set variable    /mgmt/tm/ltm/node/~${node_partition}~${node_name}
    [Return]    ${api_response}

Mark an LTM Node as Down
    [Documentation]    Marks an LTM node as down; Nodes that have been forced offline do not accept any new connections, even if they match an existing persistence session (https://support.f5.com/csp/article/K13310)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${node_name}   ${node_partition}=Common
    ${api_uri}    set variable    /mgmt/tm/ltm/node/~${node_partition}~${node_name}
    [Return]    ${api_response}

Mark an LTM Node as Up
    [Documentation]    Marks an LTM node as up (https://support.f5.com/csp/article/K13310)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${node_name}   ${node_partition}=Common
    ${api_uri}    set variable    /mgmt/tm/ltm/node/~${node_partition}~${node_name}
    [Return]    ${api_response}

Verify an LTM Node Exists
    [Documentation]    Verifies that an LTM node has been created (https://techdocs.f5.com/content/kb/en-us/products/big-ip_ltm/manuals/product/ltm-basics-13-0-0/3.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${node_name}    ${node_partition}=Common
    ${api_uri}    set variable    /mgmt/tm/ltm/node/~${node_partition}~${node_name}
    ${api_response}    BIG-IP iControl BasicAuth GET    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}
    Should be Equal As Strings    ${api_response.status_code}    200
    ${api_expected_response_dict}    create dictionary    kind=tm:ltm:node:nodestate    name=${node_name}    partition=${node_partition}
    ${api_response_dict}    to json    ${api_response.content}
    Dictionary should contain subdictionary    ${api_response_dict}    ${api_expected_response_dict}
    [Return]    ${api_response}

Delete an LTM Node
    [Documentation]    Deletes an LTM node (https://techdocs.f5.com/content/kb/en-us/products/big-ip_ltm/manuals/product/ltm-basics-13-0-0/3.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${node_name}    ${node_partition}
    ${api_uri}    set variable    /mgmt/tm/ltm/node/~${node_partition}~${node_name}
    ${api_response}    BIG-IP iControl BasicAuth DELETE
    Should be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Reset All Node Stats
    [Documentation]    Clears the statistics for all nodes  (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/ltm-basics-13-0-0/2.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}
    ${api_payload}    Create Dictionary    command=reset-stats
    ${api_uri}    set variable    /mgmt/tm/ltm/node
    ${api_response}    BIG-IP iControl BasicAuth POST    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

#############
## ltm pool
#############

Create an LTM Pool
    [Documentation]    Creates a pool of servers in LTM (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/ltm-basics-13-0-0/4.html#guid-c8d28345-0337-484e-ad92-cf3f21d638f1)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${name}    ${partition}=Common    ${allowNat}=yes    ${allowSnat}=yes    ${ignorePersistedWeight}=disabled   ${loadBalancingMode}=round-robin    ${minActiveMembers}=${0}    ${minUpMembers}=${0}    ${minUpMembersAction}=failover  ${minUpMembersChecking}=disabled    ${queueDepthLimit}=${0}    ${queueOnConnectionLimit}=disabled    ${queueTimeLimit}=${0}  ${reselectTries}=${0}   ${serviceDownAction}=none   ${slowRampTime}=${10}   ${monitor}=none
    ${api_payload}    create dictionary   name=${name}    partition=${partition}  allowNat=${allowNat}    allowSnat=${allowSnat}    ignorePersistedWeight=${ignorePersistedWeight}  loadBalancingMode=${loadBalancingMode}    minActiveMembers=${minActiveMembers}  minUpMembers=${minUpMembers}    minUpMembersAction=${minUpMembersAction}    minUpMembersChecking=${minUpMembersChecking}    queueDepthLimit=${queueDepthLimit}  queueOnConnectionLimit=${queueOnConnectionLimit}    queueTimeLimit=${queueTimeLimit}    reselectTries=${reselectTries}  serviceDownAction=${serviceDownAction}    slowRampTime=${slowRampTime}    monitor=${monitor}
    ${api_uri}    set variable    /mgmt/tm/ltm/pool
    ${api_response}    BIG-IP iControl BasicAuth POST    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Verify an LTM Pool
    [Documentation]    Verifies the existence and configuration of a pool in LTM (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/ltm-basics-13-0-0/4.html#guid-c8d28345-0337-484e-ad92-cf3f21d638f1)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${name}    ${partition}=Common    ${allowNat}=yes    ${allowSnat}=yes    ${ignorePersistedWeight}=disabled   ${loadBalancingMode}=round-robin    ${minActiveMembers}=${0}    ${minUpMembers}=${0}    ${minUpMembersAction}=failover  ${minUpMembersChecking}=disabled    ${queueDepthLimit}=${0}    ${queueOnConnectionLimit}=disabled    ${queueTimeLimit}=${0}  ${reselectTries}=${0}   ${serviceDownAction}=none   ${slowRampTime}=${10}   ${monitor}=none
    ${expected_configuration}    create dictionary   name=${name}    partition=${partition}  allowNat=${allowNat}    allowSnat=${allowSnat}    ignorePersistedWeight=${ignorePersistedWeight}  loadBalancingMode=${loadBalancingMode}    minActiveMembers=${minActiveMembers}  minUpMembers=${minUpMembers}    minUpMembersAction=${minUpMembersAction}    minUpMembersChecking=${minUpMembersChecking}    queueDepthLimit=${queueDepthLimit}  queueOnConnectionLimit=${queueOnConnectionLimit}    queueTimeLimit=${queueTimeLimit}    reselectTries=${reselectTries}  serviceDownAction=${serviceDownAction}    slowRampTime=${slowRampTime}    monitor=${monitor}
    ${api_uri}    set variable    /mgmt/tm/ltm/pool/~${partition}~${name}
    ${api_response}    BIG-IP iControl BasicAuth GET    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}
    Should Be Equal As Strings    ${api_response.status_code}    200
    ${config_json}    set variable    ${api_response.json}
    ${monitor_configured}    evaluate    $config_json.get("monitor","none")
    ${monitor_configured}    remove string using regexp   ${monitor_configured}    (\ \{|\ \})
    ${monitor_configured}    remove string using regexp   ${monitor_configured}    (\ \{|\ \})
    run keyword if    '${monitor_configured' != 'none'    set to dictionary    ${api_response.json}    monitor=${monitor_configured}
    Dictionary Should Contain Subdictionary    ${config_json}    ${expected_configuration}
    [Return]    ${api_response}

Add an LTM Pool Member to a Pool
    [Documentation]    Adds a node to an existing pool (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/ltm-basics-13-0-0/4.html#guid-c8d28345-0337-484e-ad92-cf3f21d638f1)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${pool_name}    ${pool_member_name}    ${port}    ${address}  ${pool_partition}=Common    ${pool_member_partition}=Common    ${route_domain_id}=0    ${connectionLimit}=${0}    ${dynamicRatio}=${1}    ${inheritProfile}=enabled   ${monitor}=default  ${priorityGroup}=${0}   ${rateLimit}=disabled   ${ratio}=${1}  ${session}=user-enabled    ${state}=user-up
    ${api_payload}    create dictionary   name=${pool_member_name}:${port}    address=${address}    partition=${pool_member_partition}    connectionLimit=${connectionLimit}  dynamicRatio=${dynamicRatio}    inheritProfile=${inheritProfile}    monitor=${monitor}    priorityGroup=${priorityGroup}    rateLimit=${rateLimit}  ratio=${ratio}  session=${session}    state=${state}
    ${api_uri}    set variable    /mgmt/tm/ltm/pool/~${pool_partition}~${pool_name}/members
    ${api_response}    BIG-IP iControl BasicAuth POST    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Add an LTM IPv6 Pool Member to a Pool
    [Documentation]    Adds a node to an existing pool (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/ltm-basics-13-0-0/4.html#guid-c8d28345-0337-484e-ad92-cf3f21d638f1)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${pool_name}    ${pool_member_name}    ${port}    ${address}  ${pool_partition}=Common    ${pool_member_partition}=Common    ${route_domain_id}=0    ${connectionLimit}=${0}    ${dynamicRatio}=${1}    ${inheritProfile}=enabled   ${monitor}=default  ${priorityGroup}=${0}   ${rateLimit}=disabled   ${ratio}=${1}  ${session}=user-enabled    ${state}=user-up
    ${api_payload}    create dictionary   name=${pool_member_name}.${port}    address=${address}    partition=${pool_member_partition}    connectionLimit=${connectionLimit}  dynamicRatio=${dynamicRatio}    inheritProfile=${inheritProfile}    monitor=${monitor}    priorityGroup=${priorityGroup}    rateLimit=${rateLimit}  ratio=${ratio}  session=${session}    state=${state}
    ${api_uri}    set variable    /mgmt/tm/ltm/pool/~${pool_partition}~${pool_name}/members
    ${api_response}    BIG-IP iControl BasicAuth POST    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Verify an LTM Pool Member
    [Documentation]    Confirms the existence and configuration of a pool member within a pool
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${pool_name}    ${pool_member_name}    ${port}    ${address}  ${pool_partition}=Common    ${pool_member_partition}=Common    ${route_domain_id}=0    ${connectionLimit}=${0}    ${dynamicRatio}=${1}    ${inheritProfile}=enabled   ${monitor}=default  ${priorityGroup}=${0}   ${rateLimit}=disabled   ${ratio}=${1}  ${session}=user-enabled    ${state}=user-up
    ${expected_configuration}    create dictionary    name=${pool_member_name}:${port}    address=${address}    partition=${pool_member_partition}    connectionLimit=${connectionLimit}  dynamicRatio=${dynamicRatio}    inheritProfile=${inheritProfile}    monitor=${monitor}    priorityGroup=${priorityGroup}    rateLimit=${rateLimit}    ratio=${ratio}
    ${api_uri}    set variable    /mgmt/tm/ltm/pool/~${pool_partition}~${pool_name}/members/~${pool_member_partition}~${pool_member_name}:${port}
    ${api_response}    BIG-IP iControl BasicAuth GET    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}
    Should Be Equal As Strings    ${api_response.status_code}    200
    Dictionary Should Contain Subdictionary    ${api_response.json}    ${expected_configuration}
    [Return]    ${api_response}        

Verify an LTM IPv6 Pool Member
    [Documentation]    Confirms the existence and configuration of a pool member within a pool
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${pool_name}    ${pool_member_name}    ${port}    ${address}  ${pool_partition}=Common    ${pool_member_partition}=Common    ${route_domain_id}=0    ${connectionLimit}=${0}    ${dynamicRatio}=${1}    ${inheritProfile}=enabled   ${monitor}=default  ${priorityGroup}=${0}   ${rateLimit}=disabled   ${ratio}=${1}  ${session}=user-enabled    ${state}=user-up
    ${expected_configuration}    create dictionary    name=${pool_member_name}.${port}    address=${address}    partition=${pool_member_partition}    connectionLimit=${connectionLimit}  dynamicRatio=${dynamicRatio}    inheritProfile=${inheritProfile}    monitor=${monitor}    priorityGroup=${priorityGroup}    rateLimit=${rateLimit}    ratio=${ratio}
    ${api_uri}    set variable    /mgmt/tm/ltm/pool/~${pool_partition}~${pool_name}/members/~${pool_member_partition}~${pool_member_name}.${port}
    ${api_response}    BIG-IP iControl BasicAuth GET    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}
    Should Be Equal As Strings    ${api_response.status_code}    200
    Dictionary Should Contain Subdictionary    ${api_response.json}    ${expected_configuration}
    [Return]    ${api_response}        

Add an LTM Pool Member to a Pool in Bulk
    [Documentation]    Adds a node to an existing pool (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/ltm-basics-13-0-0/4.html#guid-c8d28345-0337-484e-ad92-cf3f21d638f1)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${pool_name}    ${pool_partition}    ${member_list}
    FOR    ${current_member}    IN    @{member_list}
        ${pool_member_partition}    get from dictionary    ${current_member}    partition
        ${address}    get from dictionary    ${current_member}    address
        ${port}    get from dictionary    ${current_member}    port
        ${monitor}    get from dictionary    ${current_member}    monitor
        ${api_payload}    create dictionary   name=${address}:${port}    address=${address}    partition=${pool_member_partition}    monitor=${monitor}
        ${api_uri}    set variable    /mgmt/tm/ltm/pool/~${pool_partition}~${pool_name}/members
        ${api_response}    BIG-IP iControl BasicAuth POST    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
        Should Be Equal As Strings    ${api_response.status_code}    200
    END
    [Return]    ${api_response.json}

Verify an LTM Pool Member in Bulk
    [Documentation]    Adds a node to an existing pool (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/ltm-basics-13-0-0/4.html#guid-c8d28345-0337-484e-ad92-cf3f21d638f1)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${pool_name}    ${pool_partition}    ${member_list}
    FOR    ${current_member}    IN    @{member_list}
        ${pool_member_partition}    get from dictionary    ${current_member}    partition
        ${address}    get from dictionary    ${current_member}    address
        ${port}    get from dictionary    ${current_member}    port
        ${monitor}    get from dictionary    ${current_member}    monitor
        ${expected_configuration}    create dictionary   name=${address}:${port}    address=${address}    partition=${pool_member_partition}    monitor=${monitor}
        ${api_uri}    set variable    /mgmt/tm/ltm/pool/~${pool_partition}~${pool_name}/members/~${pool_member_partition}~${address}:${port}
        ${api_response}    BIG-IP iControl BasicAuth GET    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}
        Should Be Equal As Strings    ${api_response.status_code}    200
        Dictionary should contain subdictionary    ${api_response.json}    ${expected_configuration}
    END
    [Return]    ${api_response.json}

Enable an LTM Pool Member
    [Documentation]    Enables a pool member in a particular pool (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/ltm-basics-13-0-0/5.html#guid-ec0ade90-7b1b-4dfe-aa28-13b50071c34e)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${pool_name}    ${pool_member_name}    ${pool_partition}=Common    ${pool_member_partition}=Common
    ${api_payload}    Create Dictionary    session=user-enabled
    ${api_uri}    set variable    /mgmt/tm/ltm/pool/~${pool_partition}~${pool_name}/members/~${pool_member_partition}~${pool_member_name}
    ${api_response}    BIG-IP iControl BasicAuth PATCH    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Disable an LTM Pool Member
    [Documentation]    Disables a pool member in a particular pool; the node itself remains available to other pools (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/ltm-basics-13-0-0/5.html#guid-ec0ade90-7b1b-4dfe-aa28-13b50071c34e)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${pool_name}    ${pool_member_name}    ${pool_partition}=Common    ${pool_member_partition}=Common
    ${api_payload}    Create Dictionary    session=user-disabled
    ${api_uri}    set variable    /mgmt/tm/ltm/pool/~${pool_partition}~${pool_name}/members/~${pool_member_partition}~${pool_member_name}
    ${api_response}    BIG-IP iControl BasicAuth PATCH    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Mark an LTM Pool Member as Down
    [Documentation]    Marks a pool member dowm in a particular pool (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/ltm-basics-13-0-0/5.html#guid-ec0ade90-7b1b-4dfe-aa28-13b50071c34e)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${pool_name}    ${pool_member_name}    ${pool_partition}=Common    ${pool_member_partition}=Common
    ${api_payload}    Create Dictionary    state=user-down
    ${api_uri}    set variable    /mgmt/tm/ltm/pool/~${pool_partition}~${pool_name}/members/~${pool_member_partition}~${pool_member_name}
    ${api_response}    BIG-IP iControl BasicAuth PATCH    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Mark an LTM Pool Member as Up
    [Documentation]    Marks a pool member up in a particular pool (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/ltm-basics-13-0-0/5.html#guid-ec0ade90-7b1b-4dfe-aa28-13b50071c34e)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${pool_name}    ${pool_member_name}    ${pool_partition}=Common    ${pool_member_partition}=Common
    ${api_payload}    Create Dictionary    state=user-up
    ${api_uri}    set variable    /mgmt/tm/ltm/pool/~${pool_partition}~${pool_name}/members/~${pool_member_partition}~${pool_member_name}
    ${api_response}    BIG-IP iControl BasicAuth PATCH    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Remove an LTM Pool Member from a Pool
    [Documentation]    Removes a single pool member from an existing pool (Marks a pool member dowm in a particular pool (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/ltm-basics-13-0-0/4.html#guid-c8d28345-0337-484e-ad92-cf3f21d638f1))
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${pool_name}    ${pool_member_name}    ${pool_partition}=Common    ${pool_member_partition}=Common
    ${api_uri}    set variable    /mgmt/tm/ltm/pool/~${pool_partition}~{pool_name}/members/~${pool_member_partition}~${pool_member_name}
    ${api_response}    BIG-IP iControl BasicAuth DELETE
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Verify an LTM Pool Exists
    [Documentation]    Verifies that an LTM pool has been created (https://techdocs.f5.com/content/kb/en-us/products/big-ip_ltm/manuals/product/ltm-basics-13-0-0/3.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${pool_name}    ${pool_partition}=Common
    ${api_uri}    set variable    /mgmt/tm/ltm/pool/~${pool_partition}~${pool_name}
    ${api_response}    BIG-IP iControl BasicAuth GET    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}
    Should be Equal As Strings    ${api_response.status_code}    200
    ${api_expected_response_dict}    create dictionary    kind=tm:ltm:pool:poolstate    name=${pool_name}    partition=${pool_partition}
    ${api_response_dict}    to json    ${api_response.content}
    Dictionary should contain subdictionary    ${api_response_dict}    ${api_expected_response_dict}
    [Return]    ${api_response}

Delete an LTM Pool
    [Documentation]    Deletes an LTM pool, does not delete the node objects for each pool member (Marks a pool member dowm in a particular pool (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/ltm-basics-13-0-0/4.html#guid-c8d28345-0337-484e-ad92-cf3f21d638f1))
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${name}    ${partition}=Common
    ${api_uri}    set variable    /mgmt/tm/ltm/pool/~${partition}~${name}
    ${api_response}    BIG-IP iControl BasicAuth DELETE
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Retrieve All LTM Pool Statistics
    [Documentation]    Pulls the statistics for all pools (https://devcentral.f5.com/s/articles/getting-started-with-icontrol-working-with-statistics-20513)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}
    ${api_uri}    set variable    /mgmt/tm/ltm/pool/stats
    ${api_response}    BIG-IP iControl BasicAuth GET    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Retrieve LTM Pool Statistics
    [Documentation]    Pulls the statistics for all LTM pools (https://devcentral.f5.com/s/articles/getting-started-with-icontrol-working-with-statistics-20513)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${name}    ${partition}=Common
    ${api_uri}    set variable    /mgmt/tm/ltm/pool/~${partition}~${name}/stats
    ${api_response}    BIG-IP iControl BasicAuth GET    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Retrieve LTM Pool Member Statistics
    [Documentation]    Pulls the statistics for a single pool member within an existing pool (https://devcentral.f5.com/s/articles/getting-started-with-icontrol-working-with-statistics-20513)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${pool_name}    ${partition}=Common
    ${api_uri}    set variable    /mgmt/tm/ltm/pool/~${partition}~${pool_name}/members/stats
    ${api_response}    BIG-IP iControl BasicAuth GET    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Reset All Pool Stats
    [Documentation]    Clears the statistics for all pools (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/ltm-basics-13-0-0/2.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}
    ${api_payload}    Create Dictionary    command=reset-stats
    ${api_uri}    set variable    /mgmt/tm/ltm/pool
    ${api_response}    BIG-IP iControl BasicAuth POST    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}


################
## ltm profile
################

Create a BIG-IP Client SSL Profile
    [Documentation]    Creates a client SSL profile in LTM (https://support.f5.com/csp/article/K14783)
    [Arguments]    ${bigip_host}   ${bigip_username}    ${bigip_password}    ${name}	 	${partition}=Common    ${alertTimeout}=indefinite	 	${allowDynamicRecordSizing}=disabled	 	${allowExpiredCrl}=disabled	 	${allowNonSsl}=disabled	 	${authenticate}=once	 	${authenticateDepth}=9	${cacheSize}=262144	${cacheTimeout}=3600	${cert}=/Common/default.crt	 	${certLifespan}=30	${certLookupByIpaddrPort}=disabled	 	${ciphers}=DEFAULT	 	${defaultsFrom}=/Common/clientssl	 	${forwardProxyBypassDefaultAction}=intercept	 	${genericAlert}=enabled	 	${handshakeTimeout}=10	 	${inheritCertkeychain}=true	 	${key}=/Common/default.key	 	${kind}=tm:ltm:profile:client-ssl:client-sslstate	 	${maxActiveHandshakes}=indefinite	 	${maxAggregateRenegotiationPerMinute}=indefinite	 	${maxRenegotiationsPerMinute}=5	${maximumRecordSize}=16384	${modSslMethods}=disabled	 	${mode}=enabled	 	${peerCertMode}=ignore	 	${peerNoRenegotiateTimeout}=10	 	${proxySsl}=disabled	 	${proxySslPassthrough}=disabled	 	${renegotiateMaxRecordDelay}=indefinite	 	${renegotiatePeriod}=indefinite	 	${renegotiateSize}=indefinite	 	${renegotiation}=enabled	 	${retainCertificate}=true	 	${secureRenegotiation}=require	 	${sessionMirroring}=disabled	 	${sessionTicket}=disabled	 	${sessionTicketTimeout}=0	${sniDefault}=false	 	${sniRequire}=false	 	${sslForwardProxy}=disabled	 	${sslForwardProxyBypass}=disabled	 	${sslSignHash}=any	 	${strictResume}=disabled	 	${uncleanShutdown}=enabled
    ${api_payload}    create dictionary   name=${name}    partition=${partition}  name=${name}    alertTimeout=${alertTimeout}    allowDynamicRecordSizing=${allowDynamicRecordSizing}    allowExpiredCrl=${allowExpiredCrl}    allowNonSsl=${allowNonSsl}    authenticate=${authenticate}    authenticateDepth=${authenticateDepth}    certLifespan=${certLifespan}    ciphers=${ciphers}    defaultsFrom=${defaultsFrom}    forwardProxyBypassDefaultAction=${forwardProxyBypassDefaultAction}    genericAlert=${genericAlert}    handshakeTimeout=${handshakeTimeout}    inheritCertkeychain=${inheritCertkeychain}    key=${key}    kind=${kind}    maxActiveHandshakes=${maxActiveHandshakes}    maxAggregateRenegotiationPerMinute=${maxAggregateRenegotiationPerMinute}    maxRenegotiationsPerMinute=${maxRenegotiationsPerMinute}    mode=${mode}    peerCertMode=${peerCertMode}    peerNoRenegotiateTimeout=${peerNoRenegotiateTimeout}    proxySsl=${proxySsl}    proxySslPassthrough=${proxySslPassthrough}    renegotiateMaxRecordDelay=${renegotiateMaxRecordDelay}    renegotiatePeriod=${renegotiatePeriod}    renegotiateSize=${renegotiateSize}    renegotiation=${renegotiation}    retainCertificate=${retainCertificate}    secureRenegotiation=${secureRenegotiation}    sessionMirroring=${sessionMirroring}    sessionTicket=${sessionTicket}    sessionTicketTimeout=${sessionTicketTimeout}    sniRequire=${sniRequire}    sslForwardProxy=${sslForwardProxy}    sslForwardProxyBypass=${sslForwardProxyBypass}    sslSignHash=${sslSignHash}    strictResume=${strictResume}    uncleanShutdown=${uncleanShutdown}
    set test variable   ${api_payload}
    ${api_uri}    set variable    /mgmt/tm/ltm/profile/client-ssl
    set test variable   ${api_uri}
    ${api_response}    BIG-IP iControl BasicAuth POST    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

################
## ltm virtual
################

Reset Virtual Stats
    [Documentation]    Clears the statistics for a particular virtual server (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/ltm-basics-13-0-0/2.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${name}
    ${api_payload}    Create Dictionary    command=reset-stats    name=${name}
    ${api_uri}    set variable    /mgmt/tm/ltm/virtual
    ${api_response}    BIG-IP iControl BasicAuth POST    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Reset All Virtual Stats
    [Documentation]    Clears the statistics for all virtual servers (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/ltm-basics-13-0-0/2.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}
    ${api_payload}    Create Dictionary    command=reset-stats
    ${api_uri}    set variable    /mgmt/tm/ltm/virtual
    ${api_response}    BIG-IP iControl BasicAuth POST    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Create an LTM FastL4 Virtual Server
    [Documentation]    Creates a FastL4 virtual server in LTM (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/ltm-basics-13-0-0/2.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${name}    ${destination}    ${partition}=Common    ${addressStatus}=yes    ${autoLasthop}=default  ${connectionLimit}=${0}    ${enabled}=${True}  ${ipProtocol}=any   ${mask}=255.255.255.255    ${source}=0.0.0.0\/0    ${sourcePort}=preserve    ${translateAddress}=disabled    ${translatePort}=disabled    ${pool}=none    ${sourceAddressTranslation_pool}=none   ${sourceAddressTranslation_type}=none
    ${SourceAddressTranslation}    create dictionary    pool=${sourceAddressTranslation_pool}   type=${sourceAddressTranslation_type}
    ${api_payload}    create dictionary    name=${name}    destination=${destination}    partition=${partition}    addressStatus=${addressStatus}    autoLasthop=${autoLasthop}  connectionLimit=${connectionLimit}    ipProtocol=${ipProtocol}   mask=${mask}    source=${source}    sourcePort=${sourcePort}    translateAddress=${translateAddress}    translatePort=${translatePort}    pool=${pool}    sourceAddressTranslation=${sourceAddressTranslation}
    ${api_uri}    set variable    /mgmt/tm/ltm/virtual
    ${api_response}    BIG-IP iControl BasicAuth POST    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Verify an LTM FastL4 Virtual Server    
    [Documentation]    Verifies that a LTM IPv4 virtual server with a fastL4 profile is properly configured (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/ltm-basics-13-0-0/2.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${name}    ${destination}    ${partition}=Common    ${addressStatus}=yes    ${autoLasthop}=default  ${connectionLimit}=${0}    ${enabled}=${True}  ${ipProtocol}=any   ${mask}=255.255.255.255    ${source}=0.0.0.0\/0    ${sourcePort}=preserve    ${translateAddress}=disabled    ${translatePort}=disabled    ${pool}=none    ${sourceAddressTranslation_pool}=none   ${sourceAddressTranslation_type}=none
    ${SourceAddressTranslation}    create dictionary    pool=${sourceAddressTranslation_pool}   type=${sourceAddressTranslation_type}
    run keyword if    '${sourceAddressTranslation_pool}' == 'none'    remove from dictionary    ${SourceAddressTranslation}    pool
    ${expected_configuration}    create dictionary    name=${name}    destination=/${partition}/${destination}    partition=${partition}    addressStatus=${addressStatus}    autoLasthop=${autoLasthop}  connectionLimit=${connectionLimit}    ipProtocol=${ipProtocol}   mask=${mask}    source=${source}    sourcePort=${sourcePort}    translateAddress=${translateAddress}    translatePort=${translatePort}    pool=/${partition}/${pool}    sourceAddressTranslation=${sourceAddressTranslation}
    ${api_uri}    set variable    /mgmt/tm/ltm/virtual/~${partition}~${name}
    ${api_response}    BIG-IP iControl BasicAuth GET    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    
    Should Be Equal As Strings    ${api_response.status_code}    200
    Dictionary Should Contain Subdictionary    ${api_response.json}    ${expected_configuration}
    [Return]    ${api_response}    

Create an LTM FastL4 IPv6 Virtual Server
    [Documentation]    Creates a FastL4 virtual server in LTM (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/ltm-basics-13-0-0/2.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${name}    ${destination}    ${partition}=Common    ${addressStatus}=yes    ${autoLasthop}=default  ${connectionLimit}=${0}    ${enabled}=${True}  ${ipProtocol}=any   ${mask}=any    ${source}=::/0    ${sourcePort}=preserve    ${translateAddress}=disabled    ${translatePort}=disabled    ${pool}=none    ${sourceAddressTranslation_pool}=none   ${sourceAddressTranslation_type}=none
    ${SourceAddressTranslation}    create dictionary    pool=${sourceAddressTranslation_pool}   type=${sourceAddressTranslation_type}
    ${api_payload}    create dictionary    name=${name}    destination=${destination}    partition=${partition}    addressStatus=${addressStatus}    autoLasthop=${autoLasthop}  connectionLimit=${connectionLimit}    ipProtocol=${ipProtocol}   mask=${mask}    source=${source}    sourcePort=${sourcePort}    translateAddress=${translateAddress}    translatePort=${translatePort}    pool=${pool}    sourceAddressTranslation=${sourceAddressTranslation}
    ${api_uri}    set variable    /mgmt/tm/ltm/virtual
    ${api_response}    BIG-IP iControl BasicAuth POST    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Verify an LTM FastL4 IPv6 Virtual Server    
    [Documentation]    Verifies that a LTM IPv6 virtual server with a fastL4 profile is properly configured (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/ltm-basics-13-0-0/2.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${name}    ${destination}    ${partition}=Common    ${addressStatus}=yes    ${autoLasthop}=default  ${connectionLimit}=${0}    ${enabled}=${True}  ${ipProtocol}=any   ${mask}=any    ${source}=::\/0    ${sourcePort}=preserve    ${translateAddress}=disabled    ${translatePort}=disabled    ${pool}=none    ${sourceAddressTranslation_pool}=none   ${sourceAddressTranslation_type}=none
    ${SourceAddressTranslation}    create dictionary    pool=${sourceAddressTranslation_pool}   type=${sourceAddressTranslation_type}
    run keyword if    '${sourceAddressTranslation_pool}' == 'none'    remove from dictionary    ${SourceAddressTranslation}    pool
    ${expected_configuration}    create dictionary    name=${name}    destination=/${partition}/${destination}    partition=${partition}    addressStatus=${addressStatus}    autoLasthop=${autoLasthop}  connectionLimit=${connectionLimit}    ipProtocol=${ipProtocol}   mask=${mask}    source=${source}    sourcePort=${sourcePort}    translateAddress=${translateAddress}    translatePort=${translatePort}    pool=/${partition}/${pool}    sourceAddressTranslation=${sourceAddressTranslation}
    ${api_uri}    set variable    /mgmt/tm/ltm/virtual/~${partition}~${name}
    ${api_response}    BIG-IP iControl BasicAuth GET    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    
    Should Be Equal As Strings    ${api_response.status_code}    200
    Dictionary Should Contain Subdictionary    ${api_response.json}    ${expected_configuration}
    [Return]    ${api_response}    

Create an LTM IP Forwarding Virtual Server
    [Documentation]    Creates an IP Forwarding virtual server in LTM (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/ltm-basics-13-0-0/2.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${name}    ${destination}    ${partition}=Common    ${addressStatus}=yes    ${autoLasthop}=default  ${connectionLimit}=${0}    ${enabled}=${True}  ${ipProtocol}=any   ${mask}=any    ${source}=0.0.0.0\/0    ${sourcePort}=preserve    ${translateAddress}=disabled    ${translatePort}=disabled   ${pool}=none    ${sourceAddressTranslation_pool}=none   ${sourceAddressTranslation_type}=none
    ${SourceAddressTranslation}    create dictionary    pool=${sourceAddressTranslation_pool}   type=${sourceAddressTranslation_type}
    ${api_payload}    create dictionary    name=${name}    destination=${destination}    partition=${partition}    addressStatus=${addressStatus}    autoLasthop=${autoLasthop}  connectionLimit=${connectionLimit}    ipProtocol=${ipProtocol}   mask=${mask}    source=${source}    sourcePort=${sourcePort}    translateAddress=${translateAddress}    translatePort=${translatePort}    pool=${pool}    sourceAddressTranslation=${sourceAddressTranslation}
    ${api_uri}    set variable    /mgmt/tm/ltm/virtual
    ${api_response}    BIG-IP iControl BasicAuth POST    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Create an LTM IP Forwarding IPv6 Virtual Server
    [Documentation]    Creates an IP Forwarding virtual server in LTM (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/ltm-basics-13-0-0/2.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${name}    ${destination}    ${partition}=Common    ${addressStatus}=yes    ${autoLasthop}=default  ${connectionLimit}=${0}    ${enabled}=${True}  ${ipProtocol}=any   ${mask}=any    ${source}=::/0    ${sourcePort}=preserve    ${translateAddress}=disabled    ${translatePort}=disabled   ${pool}=none    ${sourceAddressTranslation_pool}=none   ${sourceAddressTranslation_type}=none
    ${SourceAddressTranslation}    create dictionary    pool=${sourceAddressTranslation_pool}   type=${sourceAddressTranslation_type}
    ${api_payload}    create dictionary    name=${name}    destination=${destination}    partition=${partition}    addressStatus=${addressStatus}    autoLasthop=${autoLasthop}  connectionLimit=${connectionLimit}    ipProtocol=${ipProtocol}   mask=${mask}    source=${source}    sourcePort=${sourcePort}    translateAddress=${translateAddress}    translatePort=${translatePort}    pool=${pool}    sourceAddressTranslation=${sourceAddressTranslation}
    ${api_uri}    set variable    /mgmt/tm/ltm/virtual
    ${api_response}    BIG-IP iControl BasicAuth POST    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Create an LTM Standard Virtual Server
    [Documentation]    Creates a Standard virtual server in LTM (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/ltm-basics-13-0-0/2.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${name}    ${destination}    ${partition}=Common    ${addressStatus}=yes    ${autoLasthop}=default  ${connectionLimit}=${0}    ${enabled}=${True}  ${ipProtocol}=any   ${mask}=any    ${source}=0.0.0.0\/0    ${sourcePort}=preserve    ${translateAddress}=disabled    ${translatePort}=disabled   ${pool}=none    ${sourceAddressTranslation_pool}=none   ${sourceAddressTranslation_type}=none
    ${SourceAddressTranslation}    create dictionary    pool=${sourceAddressTranslation_pool}   type=${sourceAddressTranslation_type}
    ${api_payload}    create dictionary    name=${name}    destination=${destination}    partition=${partition}    addressStatus=${addressStatus}    autoLasthop=${autoLasthop}  connectionLimit=${connectionLimit}    ipProtocol=${ipProtocol}   mask=${mask}    source=${source}    sourcePort=${sourcePort}    translateAddress=${translateAddress}    translatePort=${translatePort}    pool=${pool}    sourceAddressTranslation=${sourceAddressTranslation}
    ${api_uri}    set variable    /mgmt/tm/ltm/virtual
    ${api_response}    BIG-IP iControl BasicAuth POST    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Create an LTM Standard IPv6 Virtual Server
    [Documentation]    Creates a Standard virtual server in LTM (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/ltm-basics-13-0-0/2.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${name}    ${destination}    ${partition}=Common    ${addressStatus}=yes    ${autoLasthop}=default  ${connectionLimit}=${0}    ${enabled}=${True}  ${ipProtocol}=any   ${mask}=any    ${source}=0.0.0.0\/0    ${sourcePort}=preserve    ${translateAddress}=disabled    ${translatePort}=disabled   ${pool}=none    ${sourceAddressTranslation_pool}=none   ${sourceAddressTranslation_type}=none
    ${SourceAddressTranslation}    create dictionary    pool=${sourceAddressTranslation_pool}   type=${sourceAddressTranslation_type}
    ${api_payload}    create dictionary    name=${name}    destination=${destination}    partition=${partition}    addressStatus=${addressStatus}    autoLasthop=${autoLasthop}  connectionLimit=${connectionLimit}    ipProtocol=${ipProtocol}   mask=${mask}    source=${source}    sourcePort=${sourcePort}    translateAddress=${translateAddress}    translatePort=${translatePort}    pool=${pool}    sourceAddressTranslation=${sourceAddressTranslation}
    ${api_uri}    set variable    /mgmt/tm/ltm/virtual
    ${api_response}    BIG-IP iControl BasicAuth POST    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Verify an LTM Virtual Server Exists
    [Documentation]    Verifies that an LTM virtual server has been created (https://techdocs.f5.com/content/kb/en-us/products/big-ip_ltm/manuals/product/ltm-basics-13-0-0/3.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${virtual_server_name}    ${virtual_server_partition}=Common
    ${api_uri}    set variable    /mgmt/tm/ltm/virtual/~${virtual_server_partition}~${virtual_server_name}
    ${api_response}    BIG-IP iControl BasicAuth GET    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}
    Should be Equal As Strings    ${api_response.status_code}    200
    ${api_expected_response_dict}    create dictionary    kind=tm:ltm:virtual:virtualstate    name=${virtual_server_name}    partition=${virtual_server_partition}
    ${api_response_dict}    to json    ${api_response.content}
    Dictionary should contain subdictionary    ${api_response_dict}    ${api_expected_response_dict}
    [Return]    ${api_response}

Delete an LTM Virtual Server
    [Documentation]    Deletes a virtual server in LTM (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/ltm-basics-13-0-0/2.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${name}    ${partition}=Common
    ${api_uri}    set variable    /mgmt/tm/ltm/virtual/~${partition}~${name}
    ${api_response}    BIG-IP iControl BasicAuth DELETE
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Add a Profile to an LTM Virtual Server
    [Documentation]    Adds a LTM profile to a virtual server in LTM (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/ltm-profiles-reference-13-1-0/1.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${profile_name}    ${virtual_server_name}    ${profile_partition}=Common    ${virtual_server_partition}=Common
    ${api_uri}    set variable    /mgmt/tm/ltm/virtual/~${virtual_server_partition}~${virtual_server_name}/profiles
    ${api_payload}    create dictionary    name=${profile_name}    partition=${profile_partition}
    ${api_response}    BIG-IP iControl BasicAuth POST    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}    
    [Return]    ${api_response}

Retrieve LTM Virtual Server Statistics
    [Documentation]    Pulls statistics on a specific virtual server (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/ltm-basics-13-0-0/2.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${name}    ${partition}=Common
    ${api_uri}    set variable    /mgmt/tm/ltm/virtual/~${partition}~${name}
    ${api_response}    BIG-IP iControl BasicAuth GET    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Retrieve All LTM Virtual Servers Statistics
    [Documentation]    Pulls statistics on all virtual servers (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/ltm-basics-13-0-0/2.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}
    ${api_uri}    set variable    /mgmt/tm/ltm/virtual/stats
    ${api_response}    BIG-IP iControl BasicAuth GET    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Get LTM Virtual Server Availability State
    [Documentation]    Pulls the current availability state on a specific virtual server (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/ltm-basics-13-0-0/2.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${name}    ${partition}=Common
    ${api_uri}    set variable    /mgmt/tm/ltm/virtual/~${partition}~${name}/stats
    ${api_response}    BIG-IP iControl BasicAuth GET    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}
    Should Be Equal As Strings    ${api_response.status_code}    200
    ${virtual_server_stats_dict}    to json    ${api_response.content}
    ${virtual_server_status}    get from dictionary    ${virtual_server_stats_dict}    entries
    ${virtual_server_status}    get from dictionary    ${virtual_server_status}    https:\/\/localhost\/mgmt\/tm\/ltm\/virtual\/~${partition}~${name}\/~${partition}~${name}\/stats
    ${virtual_server_status}    get from dictionary    ${virtual_server_status}    nestedStats
    ${virtual_server_status}    get from dictionary    ${virtual_server_status}    entries
    ${virtual_server_status}    get from dictionary    ${virtual_server_status}    status.availabilityState
    ${virtual_server_status}    get from dictionary    ${virtual_server_status}    description
    [return]    ${virtual_server_status}

Get LTM Virtual Server Enabled State
    [Documentation]    Pulls the current enabled state on a specific virtual server (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/ltm-basics-13-0-0/2.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${name}    ${partition}=Common
    ${api_uri}    set variable    /mgmt/tm/ltm/virtual/~${partition}~${name}/stats
    ${api_response}    BIG-IP iControl BasicAuth GET    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}
    Should Be Equal As Strings    ${api_response.status_code}    200
    ${virtual_server_stats_dict}    to json    ${api_response.content}
    ${virtual_server_status}    get from dictionary    ${virtual_server_stats_dict}    entries
    ${virtual_server_status}    get from dictionary    ${virtual_server_status}    https:\/\/localhost\/mgmt\/tm\/ltm\/virtual\/~${partition}~${name}\/~${partition}~${name}\/stats
    ${virtual_server_status}    get from dictionary    ${virtual_server_status}    nestedStats
    ${virtual_server_status}    get from dictionary    ${virtual_server_status}    entries
    ${virtual_server_status}    get from dictionary    ${virtual_server_status}    status.enabledState
    ${virtual_server_status}    get from dictionary    ${virtual_server_status}    description
    [return]    ${virtual_server_status}

Apply Firewall Policy to Virtual Server
    [Documentation]    Binds an existing firewall policy to a specific virtual server (https://techdocs.f5.com/kb/en-us/products/big-ip-afm/manuals/product/big-ip-network-firewall-policies-and-implementations-14-1-0.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${policy_name}    ${virtual_name}    ${policy_partition}=Common    ${virtual_partition}=Common
    ${api_uri}    set variable    /mgmt/tm/ltm/virtual/~${virtual_partition}~${virtual_name}
    ${api_payload}    create dictionary    fwEnforcedPolicy=/${policy_partition}/${policy_name}
    ${api_response}    BIG-IP iControl BasicAuth PATCH    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Retrieve the Firewall Policy Attached to a Virtual Server
    [Documentation]    Shows the firewall policy attached a particular virtual server (https://techdocs.f5.com/kb/en-us/products/big-ip-afm/manuals/product/big-ip-network-firewall-policies-and-implementations-14-1-0.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${virtual_name}    ${partition}=Common
    ${api_uri}    set variable    /mgmt/tm/ltm/virtual/~${partition}~${virtual_name}
    ${api_response}    BIG-IP iControl BasicAuth GET    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Configure Session Mirroring on a Virtual Server
    [Documentation]    Enables session mirroring on an virtual server for HA connection mirroring
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${name}    ${mirroring}    ${partition}=Common
    ${api_uri}    set variable    /mgmt/tm/ltm/virtual/~${partition}~${name}
    ${api_payload}    create dictionary    mirror=${mirroring}
    ${api_response}    BIG-IP iControl BasicAuth PATCH    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Retrieve a Virtual Server Configuration
    [Documentation]   Returns a full virtual server configuration
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${name}    ${partition}=Common
    ${api_uri}    set variable    /mgmt/tm/ltm/virtual/~${partition}~${name}
    ${api_response}    BIG-IP iControl BasicAuth GET    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

########################
## ltm virtual-address
########################

Configure Route Health Injection on a Virtual Address    
    [Documentation]    Requires address and route-advertisement parameters, partition and route_domain_id are optional. "address" is a IPv4 or IPv6 network. "route-advertisement" can be enabled or disabled.
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${address}    ${route-advertisement}    ${partition}=Common   ${route_domain_id}=0
    ${api_payload}    create dictionary    route-advertisement=${route-advertisement}
    ${api_uri}    set variable    /mgmt/tm/ltm/virtual-address/~${partition}~${address}
    ${api_response}    BIG-IP iControl BasicAuth PATCH    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings  ${api_response.status_code}    200
    [Return]    ${api_response}


##############
## net route
##############

Create Static Route Configuration on the BIG-IP
    [Documentation]    Creates a static route on the BIG-IP (https://support.f5.com/csp/article/K13833)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${name}    ${partition}    ${cidr_network}    ${gateway}    ${description}
    ${api_payload}    create dictionary    name=${name}    network=${cidr_network}    gw=${gateway}   partition=${partition}  description=${description}
    ${api_uri}    set variable    /mgmt/tm/net/route
    ${api_response}    BIG-IP iControl BasicAuth POST    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    ${api_response_json}    To Json    ${api_response.content}
    [Return]    ${api_response}

Verify Static Route Configuration on the BIG-IP
    [Documentation]    Lists configured static routes on the BIG-IP (https://support.f5.com/csp/article/K13833)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${name}    ${partition}    ${cidr_network}    ${gateway}    ${description}
    ${verification_dict}    create dictionary    name=${name}    partition=${partition}    network=${cidr_network}    gw=${gateway}   description=${description}
    ${api_uri}    set variable    /mgmt/tm/net/route/~${partition}~${name}
    ${api_response}    BIG-IP iControl BasicAuth GET    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}
    should be equal as strings    ${api_response.status_code}    200
    ${api_response_json}    to json    ${api_response.content}
    dictionary should contain sub dictionary    ${api_response_json}    ${verification_dict}
    [Return]    ${api_response}

Create Static Default Route Configuration on the BIG-IP
    [Documentation]    Creates a static default route on the BIG-IP (https://support.f5.com/csp/article/K13833)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${partition}    ${gateway}    ${description}
    ${api_payload}    create dictionary    name=default    gw=${gateway}   partition=${partition}  description=${description}
    ${api_uri}    set variable    /mgmt/tm/net/route
    ${api_response}    BIG-IP iControl BasicAuth POST    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    ${api_response_json}    To Json    ${api_response.content}
    [Return]    ${api_response}

Verify Static Default Route Configuration on the BIG-IP
    [Documentation]    Verifies the configuration of the static default route (https://support.f5.com/csp/article/K13833)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${partition}    ${gateway}    ${description}
    ${verification_dict}    create dictionary    name=default-inet6    partition=${partition}    gw=${gateway}   description=${description}
    ${api_uri}    set variable    /mgmt/tm/net/route/~${partition}~${name}
    ${api_response}    BIG-IP iControl BasicAuth GET    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}
    should be equal as strings    ${api_response.status_code}    200
    ${api_response_json}    to json    ${api_response.content}
    dictionary should contain sub dictionary    ${api_response_json}    ${verification_dict}
    [Return]    ${api_response}

Create Static IPv6 Default Route Configuration on the BIG-IP
    [Documentation]    Creates a static default route for IPv6 (https://support.f5.com/csp/article/K13833)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${partition}    ${gateway}    ${description}
    ${api_payload}    create dictionary    name=default-inet6    gw=${gateway}   partition=${partition}  description=${description}
    ${api_uri}    set variable    /mgmt/tm/net/route
    ${api_response}    BIG-IP iControl BasicAuth POST    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    ${api_response_json}    To Json    ${api_response.content}
    [Return]    ${api_response}

Verify Static IPv6 Default Route Configuration on the BIG-IP
    [Documentation]    Verifies the configuration of the static default route for IPv6 (https://support.f5.com/csp/article/K13833)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${partition}    ${gateway}    ${description}
    ${verification_dict}    create dictionary    name=default-inet6    partition=${partition}    gw=${gateway}   description=${description}
    ${api_uri}    set variable    /mgmt/tm/net/route/~${partition}~${name}
    ${api_response}    BIG-IP iControl BasicAuth GET    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}
    should be equal as strings    ${api_response.status_code}    200
    ${api_response_json}    to json    ${api_response.content}
    dictionary should contain sub dictionary    ${api_response_json}    ${verification_dict}
    [Return]    ${api_response}

Verify Static Route Presence in BIG-IP Route Table
    [Documentation]    Verifies that a route actually exists in the BIG-IP routing table (https://support.f5.com/csp/article/K13833)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${name}    ${partition}    ${cidr_network}    ${gateway}
    ${api_uri}    set variable    /mgmt/tm/net/route/stats
    ${api_response}    BIG-IP iControl BasicAuth GET    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}
    should be equal as strings    ${api_response.status_code}    200
    ${api_response_json}    to json    ${api_response.content}
    ${route_table_entries}    get from dictionary    ${api_response_json}    entries
    log    ROUTE TABLE LIST: ${route_table_entries}
    ${selflink_name}    set variable    https://localhost/mgmt/tm/net/route/~${partition}~${name}/stats
    list should contain value    ${route_table_entries}    ${selflink_name}
    [Return]    ${api_response}

Delete Static Route Configuration on the BIG-IP
    [Documentation]    Deletes a static route on the BIG-IP (https://support.f5.com/csp/article/K13833)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${name}    ${partition}
    ${api_uri}    set variable    /mgmt/tm/net/route/~${partition}~${name}
    ${api_response}    BIG-IP iControl BasicAuth DELETE    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Verify Static Route Deletion on the BIG-IP
    [Documentation]    Verifies that a static route does not exist on the BIG-IP (https://support.f5.com/csp/article/K13833)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${name}    ${partition}
    ${api_uri}    set variable    /mgmt/tm/net/route/~${partition}~${name}
    ${api_response}    BIG-IP iControl BasicAuth GET    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}
    should be equal as strings    ${api_response.status_code}    400
    [Return]    ${api_response}

Verify Static Route Removal in BIG-IP Route Table
    [Documentation]    Verifies that a static route does not appear in the BIG-IP routing table (https://support.f5.com/csp/article/K13833)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${name}    ${partition}
    ${api_uri}    set variable    /mgmt/tm/net/route/stats
    ${api_response}    BIG-IP iControl BasicAuth GET    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}
    should be equal as strings    ${api_response.status_code}    200
    ${api_response_json}    to json    ${api_response.content}
    ${route_table_entries}    get from dictionary    ${api_response_json}    entries
    log    ROUTE TABLE LIST: ${route_table_entries}
    ${selflink_name}    set variable    https://localhost/mgmt/tm/net/route/~${partition}~${name}/stats
    list should not contain value   ${route_table_entries}    ${selflink_name}
    [Return]    ${api_response}

Display BIG-IP Static Route Configuration
    [Documentation]    Lists the static routes configured on the BIG-IP (https://support.f5.com/csp/article/K13833)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}
    ${api_uri}    set variable    /mgmt/tm/net/route
    ${api_response}    BIG-IP iControl BasicAuth GET    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}
    Should Be Equal As Strings    ${api_response.status_code}    200
    ${api_response_json}    To Json    ${api_response.content}
    log dictionary    ${api_response_json}
    [Return]    ${api_response}

#####################
## net route-domain
#####################

Create a Route Domain on the BIG-IP
    [Documentation]    Creates a route domain (VRF) on the BIG-IP (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/tmos-routing-administration-13-1-0/9.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${route_domain_name}    ${route_domain_id}    ${partition}=Common
    ${api_payload}    create dictionary    name=${route_domain_name}   id=${route_domain_id}   partition=${partition}
    ${api_uri}    set variable    /mgmt/tm/net/route-domain
    ${api_response}    BIG-IP iControl BasicAuth POST    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    ${verification_dict}    create dictionary    kind=tm:net:route-domain:route-domainstate    name=${route_domain_name}   partition=${partition}
    ${api_response_dict}    to json    ${api_response.text}
    dictionary should contain subdictionary    ${api_response_dict}    ${verification_dict}
    [Return]    ${api_response}

Verify a Route Domain on the BIG-IP
    [Documentation]    Verifies a route domain (VRF) on the BIG-IP (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/tmos-routing-administration-13-1-0/9.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${route_domain_name}    ${route_domain_id}    ${partition}=Common
    ${api_uri}    set variable    /mgmt/tm/net/route-domain/~${partition}~${route_domain_name}
    ${api_response}    BIG-IP iControl BasicAuth GET    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}
    Should Be Equal As Strings    ${api_response.status_code}    200
    ${configured_route_domain_id}    get from dictionary    ${api_response.json}    id
    should be equal as strings    ${route_domain_id}    ${configured_route_domain_id}
    [Return]    ${api_response.json}

Add a Description to a BIG-IP Route Domain
    [Documentation]    Adds a description to an existing route domain (VRF) on the BIG-IP (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/tmos-routing-administration-13-1-0/9.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${route_domain_name}    ${description}    ${partition}=Common
    ${api_payload}    create dictionary    description=${description}
    ${api_uri}    set variable    /mgmt/tm/net/route-domain/~${partition}~${route_domain_name}
    ${api_response}    BIG-IP iControl BasicAuth PATCH    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Set Route Domain VLAN List
    [Documentation]    Maps VLANs on the BIG-IP to a route-domain (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/tmos-routing-administration-13-1-0/9.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${route_domain_name}    ${vlan_list}    ${partition}=Common
    ${api_payload}    create dictionary    vlans=${vlan_list}
    ${api_uri}    set variable    /mgmt/tm/net/route-domain/~${partition}~${route_domain_name}
    ${api_response}    BIG-IP iControl BasicAuth PATCH    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Enable BGP Only on BIG-IP Route Domain
    [Documentation]    Enables BGP on an existing route domain (VRF) on the BIG-IP (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/tmos-routing-administration-13-1-0/9.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${route_domain_name}    ${partition}=Common
    ${api_routing_protocol_list}    create list    BGP
    ${api_payload}    create dictionary    routingProtocol=${api_routing_protocol_list}
    ${api_uri}    set variable    /mgmt/tm/net/route-domain/~${partition}~${route_domain_name}
    ${api_response}    BIG-IP iControl BasicAuth PATCH    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    Sleep    10s
    [Return]    ${api_response}

List Dynamic Routing Protocols Enabled on a Route Domain
    [Documentation]    Returns the list of routing protocols on an existing route domain (VRF) on the BIG-IP (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/tmos-routing-administration-13-1-0/9.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${route_domain_name}    ${partition}=Common
    ${api_uri}    set variable    /mgmt/tm/net/route-domain/~${partition}~${route_domain_name}
    ${api_response}    BIG-IP iControl BasicAuth GET    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}
    Should Be Equal As Strings    ${api_response.status_code}    200
    ${routing_protocols_list}    get from dictionary    ${api_response.json}    routingProtocol
    [Return]    ${routing_protocols_list}

Enable BGP and BFD on BIG-IP Route Domain
    [Documentation]    Enables BGP and BFD on an existing route domain (VRF) on the BIG-IP (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/tmos-routing-administration-13-1-0/9.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${route_domain_name}    ${partition}=Common
    ${api_routing_protocol_list}    create list    BGP    BFD
    ${api_payload}    create dictionary    routingProtocol=${api_routing_protocol_list}
    ${api_uri}    set variable    /mgmt/tm/net/route-domain/~${partition}~${route_domain_name}
    ${api_response}    BIG-IP iControl BasicAuth PATCH    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    Sleep    10s
    [Return]    ${api_response}

Disable Dynamic Routing on BIG-IP Route Domain
    [Documentation]    Disables all dynamic routing on an existing route domain (VRF) on the BIG-IP (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/tmos-routing-administration-13-1-0/9.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${route_domain_name}    ${partition}=Common
    ${api_routing_protocol_list}    create list
    ${api_payload}    create dictionary    routingProtocol=${api_routing_protocol_list}
    ${api_uri}    set variable    /mgmt/tm/net/route-domain/~${partition}~${route_domain_name}
    ${api_response}    BIG-IP iControl BasicAuth PATCH    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    Sleep    5s
    [Return]    ${api_response}

Enable Route Domain Strict Routing
    [Documentation]    Enables strict-routing on an existing route domain (VRF) on the BIG-IP (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/tmos-routing-administration-13-1-0/9.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${route_domain_name}    ${partition}=Common
    ${api_payload}    create dictionary    strict=enabled
    ${api_uri}    set variable    /mgmt/tm/net/route-domain/~${partition}~${route_domain_name}
    ${api_response}    BIG-IP iControl BasicAuth PATCH    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Disable Route Domain Strict Routing
    [Documentation]    Disables strict-routing on an existing route domain (VRF) on the BIG-IP (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/tmos-routing-administration-13-1-0/9.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${route_domain_name}    ${partition}=Common
    ${api_payload}    create dictionary    strict=disabled
    ${api_uri}    set variable    /mgmt/tm/net/route-domain/~${partition}~${route_domain_name}
    ${api_response}    BIG-IP iControl BasicAuth PATCH    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

#############
## net self
#############

Reset Self-IP Stats
    [Documentation]    Resets the counters on a particular self-ip on the BIG-IP (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/tmos-routing-administration-13-0-0/5.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${name}
    ${api_payload}    Create Dictionary    command=reset-stats    name=${name}
    ${api_uri}    set variable    /mgmt/tm/net/self
    ${api_response}    BIG-IP iControl BasicAuth POST    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Reset All Self-IP Stats
    [Documentation]    Resets the counters on all self-ips on the BIG-IP (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/tmos-routing-administration-13-0-0/5.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}
    ${api_payload}    Create Dictionary    command=reset-stats
    ${api_uri}    set variable    /mgmt/tm/net/self
    ${api_response}    BIG-IP iControl BasicAuth POST    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Create BIG-IP Non-floating Self IP Address
    [Documentation]    Creates a non-floating self-ip on the BIG-IP (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/tmos-routing-administration-13-0-0/5.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${name}    ${vlan}    ${address}    ${partition}="Common"    ${allow-service}="none"    ${description}="Robot Framework"
    ${api_payload}    Create Dictionary   name=${name}    partition=${partition}  address=${address}  allowService=${allow-service}   trafficGroup=traffic-group-local-only  description=${description}  vlan=${vlan}
    ${api_uri}    set variable    /mgmt/tm/net/self
    ${api_response}    BIG-IP iControl BasicAuth POST    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Create BIG-IP Floating Self IP Address
    [Documentation]    Creates a floating self-ip on the BIG-IP (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/tmos-routing-administration-13-0-0/5.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${name}    ${vlan}    ${address}    ${partition}="Common"   ${allow-service}="none"    ${description}="Robot Framework"    ${traffic-group}="traffic-group-1"
    ${api_payload}    Create Dictionary   name=${name}    partition=${partition}  address=${address}  allowService=${allow-service}   trafficGroup=${traffic-group}   description=${description}  vlan=${vlan}
    ${api_uri}    set variable    /mgmt/tm/net/self
    ${api_response}    BIG-IP iControl BasicAuth POST    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Verify BIG-IP Non-floating Self IP Address
    [Documentation]    Verifies the configuration of a non-floating self-ip on the BIG-IP (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/tmos-routing-administration-13-0-0/5.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${name}    ${address}    ${partition}="Common"
    ${api_uri}    set variable    /mgmt/tm/net/self/~${partition}~${name}
    ${api_response}    BIG-IP iControl BasicAuth GET    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Verify BIG-IP Floating Self IP Address
    [Documentation]    Verifies the configuration of a floating self-ip on the BIG-IP (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/tmos-routing-administration-13-0-0/5.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${name}    ${address}    ${partition}="Common"    ${traffic-group}=traffic-group-1
    ${api_uri}    set variable    /mgmt/tm/net/self/~${partition}~${name}
    ${api_response}    BIG-IP iControl BasicAuth GET    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

##############
## net trunk
##############

Reset Trunk Stats
    [Documentation]    Resets statistics on a trunk in the BIG-IP (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/tmos-routing-administration-13-0-0/3.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${name}
    ${api_payload}    Create Dictionary    command=reset-stats    name=${name}
    ${api_uri}    set variable    /mgmt/tm/net/trunk
    ${api_response}    BIG-IP iControl BasicAuth POST    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Reset All Trunk Stats
    [Documentation]    Resets statistics on all trunks in the BIG-IP (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/tmos-routing-administration-13-0-0/3.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}
    ${api_payload}    Create Dictionary    command=reset-stats
    ${api_uri}    set variable    /mgmt/tm/net/trunk
    ${api_response}    BIG-IP iControl BasicAuth POST    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Create BIG-IP Trunk    
    [Documentation]    Creates a trunk (port aggregation object) on the BIG-IP (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/tmos-routing-administration-13-0-0/3.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${name}    ${lacp}=disabled    ${lacpMode}=active    ${lacpTimeout}=long   ${stp}=enabled    ${linkSelectPolicy}=auto   ${qinqEthertype}=0x8100    ${distributionHash}=src-dst-ipport    ${description}=Created by Robot Framework       
    ${api_uri}    set variable    /mgmt/tm/net/trunk
    ${api_payload}    create dictionary    name=${name}    lacp=${lacp}    lacpMode=${lacpMode}    lacpTimeout=${lacpTimeout}    stp=${stp}    linkSelectPolicy=${linkSelectPolicy}    qinqEthertype=${qinqEthertype}    distributionHash=${distributionHash}    description=${description}
    ${api_response}    BIG-IP iControl BasicAuth POST    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Verify BIG-IP Trunk Exists    
    [Documentation]    Verifies that a trunk (port aggregation object) exists on the BIG-IP (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/tmos-routing-administration-13-0-0/3.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${name}
    ${api_uri}    set variable    /mgmt/tm/net/trunk/${name}
    ${api_response}    BIG-IP iControl BasicAuth GET    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}
    Should Be Equal As Strings    ${api_response.status_code}    200
    ${api_response_dict}    to json    ${api_response.content}
    ${trunk_name_dict}    create dictionary    name=${name}
    dictionary should contain sub dictionary    ${api_response_dict}    ${trunk_name_dict}
    [Return]    ${api_response}

Delete BIG-IP Trunk
    [Documentation]    Deletes a trunk (port aggregation object) on the BIG-IP (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/tmos-routing-administration-13-0-0/3.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${name}
    ${api_uri}    set variable    /mgmt/tm/net/trunk/${name}
    ${api_response}    BIG-IP iControl BasicAuth DELETE
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Set Trunk Description
    [Documentation]    Configures a description on a trunk (port aggregation object) on the BIG-IP (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/tmos-routing-administration-13-0-0/3.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${trunk_name}    ${trunk_description}
    ${api_uri}    set variable    /mgmt/tm/net/trunk/${trunk_name}
    ${api_payload}    create dictionary    description=${trunk_description}
    ${api_response}    BIG-IP iControl BasicAuth PATCH    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Retrieve BIG-IP Trunk Status and Statistics
    [Documentation]    Retrieve status and statistics for a BIG-IP trunk (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/tmos-routing-administration-13-0-0/3.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}   ${trunk_name}
    ${api_uri}    set variable    /mgmt/tm/net/trunk/${trunk_name}/stats
    ${api_response}    BIG-IP iControl BasicAuth GET    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}
    Should Be Equal As Strings    ${api_response.status_code}    200
    ${api_response_dict}    to json    ${api_response.content}
    dictionary should contain item  ${api_response_dict}    kind    tm:net:trunk:trunkstats
    ${trunk_stats_dict}    get from dictionary    ${api_response_dict}    entries
    log    ${trunk_stats_dict}
    [Return]    ${api_response}

Verify BIG-IP Trunk is Up
    [Documentation]    Verify UP status on a BIG-IP trunk (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/tmos-routing-administration-13-0-0/3.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}   ${trunk_name}
    ${api_uri}    set variable    /mgmt/tm/net/trunk/${trunk_name}/stats
    ${api_response}    BIG-IP iControl BasicAuth GET    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}
    Should Be Equal As Strings    ${api_response.status_code}    200
    ${api_response_dict}    to json    ${api_response.content}
    dictionary should contain item  ${api_response_dict}    kind    tm:net:trunk:trunkstats
    ${trunk_stats_dict}    get from dictionary    ${api_response_dict}    entries
    ${trunk_stats_status}    get from dictionary    ${trunk_stats_dict}    https:\/\/localhost\/mgmt\/tm\/net\/trunk\/${trunk_name}\/${trunk_name}\/stats
    ${trunk_stats_status}    get from dictionary    ${trunk_stats_status}    nestedStats
    ${trunk_stats_status}    get from dictionary    ${trunk_stats_status}    entries
    ${trunk_stats_status}    get from dictionary    ${trunk_stats_status}    status
    ${trunk_stats_status}    get from dictionary    ${trunk_stats_status}    description
    Should Be Equal As Strings    ${trunk_stats_status}    up
    [Return]    ${api_response}

Set BIG-IP Trunk Interface List
    [Documentation]    Assign multiple interfaces to a BIG-IP trunk (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/tmos-routing-administration-13-0-0/3.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}   ${trunk_name}    ${physical_interface_list}
    ${physical_interface_list}    convert to list    ${physical_interface_list}
    ${api_payload}    create dictionary    interfaces    ${physical_interface_list}
    ${api_uri}    set variable    /mgmt/tm/net/trunk/${trunk_name}
    ${api_response}    BIG-IP iControl BasicAuth PATCH    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

List BIG-IP Trunk Interface Configuration
    [Documentation]    Assign interfaces to a BIG-IP trunk (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/tmos-routing-administration-13-0-0/3.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}   ${trunk_name}
    ${api_uri}    set variable    /mgmt/tm/net/trunk/${trunk_name}
    ${api_response}    BIG-IP iControl BasicAuth GET    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Add Interface to BIG-IP Trunk
    [Documentation]    Adds a single interface to a BIG-IP trunk (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/tmos-routing-administration-13-0-0/3.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}   ${trunk_name}    ${physical_interface}
    log    Getting list of existing interfaces on trunk
    ${api_uri}    set variable    /mgmt/tm/net/trunk/${trunk_name}
    ${api_response}    BIG-IP iControl BasicAuth GET    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}
    Should Be Equal As Strings    ${api_response.status_code}    200
    ${api_response_dict}    to json    ${api_response.content}
    dictionary should contain key   ${api_response_dict}    interfaces
    ${initial_interface_list}    get from dictionary    ${api_response_dict}    interfaces
    ${initial_interface_list}    convert to list    ${initial_interface_list}
    ${initial_interface_list}    set test variable    ${initial_interface_list}
    log    Initial Interface List: ${initial_interface_list}
    log    Adding target interface to interface list
    ${physical_interface}    convert to list    ${physical_interface}
    list should not contain value   ${initial_interface_list}    ${physical_interface}
    ${new_interface_list}    set variable    ${initial_interface_list}
    append to list    ${initial_interface_list}    ${physical_interface}
    log    New interface list: ${initial_interface_list} ${new_interface_list}
    ${api_payload}    create dictionary    interfaces    ${new_interface_list}
    ${api_uri}    set variable    /mgmt/tm/net/trunk/${trunk_name}
    ${api_response}    BIG-IP iControl BasicAuth PATCH    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Remove Interface from BIG-IP Trunk
    [Documentation]    Removes a single interface from a BIG-IP trunk (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/tmos-routing-administration-13-0-0/3.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}   ${trunk_name}    ${physical_interface}
    log    Getting list of existing interfaces on trunk
    ${api_uri}    set variable    /mgmt/tm/net/trunk/${trunk_name}
    ${api_response}    BIG-IP iControl BasicAuth GET    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}
    Should Be Equal As Strings    ${api_response.status_code}    200
    ${api_response_dict}    to json    ${api_response.content}
    ${initial_interface_list}    get from dictionary    ${api_response_dict}    interfaces
    ${initial_interface_list}    convert to list    ${initial_interface_list}
    ${initial_interface_list}    set test variable    ${initial_interface_list}
    log    Initial Interface List: ${initial_interface_list}
    log    Removing target interface from interface list
    ${physical_interface}    convert to list    ${physical_interface}
    list should contain value    ${initial_interface_list}    ${physical_interface}
    ${new_interface_list}    set variable    ${initial_interface_list}
    set test variable    ${new_interface_list}
    remove values from list    ${initial_interface_list}    ${physical_interface}
    log    New interface list: ${initial_interface_list} ${new_interface_list}
    ${api_payload}    create dictionary    interfaces    ${new_interface_list}
    ${api_uri}    /mgmt/tm/net/trunk/${trunk_name}
    ${api_response}    BIG-IP iControl BasicAuth PATCH    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Verify BIG-IP Trunk Interface Removal
    [Documentation]    Verifies removal of a single interface from a BIG-IP trunk (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/tmos-routing-administration-13-0-0/3.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}   ${trunk_name}    ${physical_interface}
    log    Verifying removal of physical interface from BIG-IP trunk
    ${api_uri}    set variable   /mgmt/tm/net/trunk/${trunk_name}
    set test variable    ${api_uri}
    ${api_response}    BIG-IP iControl BasicAuth GET    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}
    Should Be Equal As Strings    ${api_response.status_code}    200
    ${api_response_dict}    to json    ${api_response.content}
    log    ${api_response_dict}
    dictionary should not contain value    ${api_response_dict}    ${physical_interface}
    [Return]    ${api_response}

Verify BIG-IP Trunk Interface Addition
    [Documentation]    Verifies the addition of a single interface from a BIG-IP trunk (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/tmos-routing-administration-13-0-0/3.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}   ${trunk_name}    ${physical_interface}
    log    Verifying addition of physical interface from BIG-IP trunk
    ${api_uri}    set variable   /mgmt/tm/net/trunk/${trunk_name}
    set test variable    ${api_uri}
    ${api_response}    BIG-IP iControl BasicAuth GET    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}
    Should Be Equal As Strings    ${api_response.status_code}    200
    ${api_response_dict}    to json    ${api_response.content}
    log    ${api_response_dict}
    dictionary should contain value    ${api_response_dict}    ${physical_interface}
    [Return]    ${api_response}

Verify BIG-IP Trunk Interface List
    [Documentation]    Verifies the list of interfaces on a BIG-IP trunk (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/tmos-routing-administration-13-0-0/3.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}   ${trunk_name}    ${physical_interface_list}
    log    Verifying addition of physical interface from BIG-IP trunk
    ${api_uri}    set variable   /mgmt/tm/net/trunk/${trunk_name}
    set test variable    ${api_uri}
    ${api_response}    BIG-IP iControl BasicAuth GET    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}
    Should Be Equal As Strings    ${api_response.status_code}    200
    ${api_response_dict}    to json    ${api_response.content}
    ${configured_interface_list}    get from dictionary    ${api_response_dict}    interfaces
    log    Full API response: ${api_response_dict}
    list should contain sub list    ${physical_interface_list}    ${configured_interface_list}
    list should contain sub list    ${configured_interface_list}    ${physical_interface_list}
    [Return]    ${api_response}

Verify Trunk Collision Counters on BIG-IP
    [Documentation]    Verifies there are no collisions on a BIG-IP trunk (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/tmos-routing-administration-13-0-0/3.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}   ${trunk_name}    ${trunk_collisions_threshold}=250
    ${api_uri}    set variable    /mgmt/tm/net/trunk/${trunk_name}/stats
    set test variable    ${api_uri}
    ${api_response}    BIG-IP iControl BasicAuth GET    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}
    Should Be Equal As Strings    ${api_response.status_code}    200
    ${api_response_dict}    to json    ${api_response.content}
    dictionary should contain item  ${api_response_dict}    kind    tm:net:trunk:trunkstats
    ${trunk_stats_dict}    get from dictionary    ${api_response_dict}    entries
    ${trunk_stats_dict}    get from dictionary    ${trunk_stats_dict}    https://localhost/mgmt/tm/net/trunk/${trunk_name}/${trunk_name}/stats
    ${trunk_stats_dict}    get from dictionary    ${trunk_stats_dict}    nestedStats
    ${trunk_stats_dict}    get from dictionary    ${trunk_stats_dict}    entries
    ${counters_collisions_dict}    get from dictionary    ${trunk_stats_dict}    counters.collisions
    ${counters_collisions_count}    get from dictionary    ${counters_collisions_dict}   value
    ${trunk_tmname}    get from dictionary    ${trunk_stats_dict}    tmName
    ${trunk_tmname}    get from dictionary    ${trunk_tmname}    description
    log    Trunk ${trunk_tmname} - Collisions: ${counters_collisions_count}
    should be true    ${counters_collisions_count} < ${trunk_collisions_threshold}
    [Return]    ${api_response}

Verify Trunk Drop Counters on BIG-IP
    [Documentation]    Verifies that trunk drops are below a certain threshold (defaults to 1000) (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/tmos-routing-administration-13-0-0/3.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}   ${trunk_name}    ${trunk_dropsIn_threshold}=1000    ${trunk_dropsOut_threshold}=1000
    ${api_uri}    set variable    /mgmt/tm/net/trunk/${trunk_name}/stats
    set test variable    ${api_uri}
    ${api_response}    BIG-IP iControl BasicAuth GET    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}
    Should Be Equal As Strings    ${api_response.status_code}    200
    ${api_response_dict}    to json    ${api_response.content}
    dictionary should contain item  ${api_response_dict}    kind    tm:net:trunk:trunkstats
    ${trunk_stats_dict}    get from dictionary   ${api_response_dict}    entries
    ${trunk_stats_dict}    get from dictionary   ${trunk_stats_dict}    https://localhost/mgmt/tm/net/trunk/${trunk_name}/${trunk_name}/stats
    ${trunk_stats_dict}    get from dictionary   ${trunk_stats_dict}    nestedStats
    ${trunk_stats_dict}    get from dictionary   ${trunk_stats_dict}    entries
    ${counters_dropsIn_dict}    get from dictionary   ${trunk_stats_dict}    counters.dropsIn
    ${counters_dropsIn_count}    get from dictionary   ${counters_dropsIn_dict}    value
    ${counters_dropsOut_dict}    get from dictionary   ${trunk_stats_dict}    counters.dropsOut
    ${counters_dropsOut_count}    get from dictionary   ${counters_dropsOut_dict}   value
    ${trunk_tmname}    get from dictionary   ${trunk_stats_dict}    tmName
    ${trunk_tmname}    get from dictionary   ${trunk_tmname}    description
    log    Trunk ${trunk_tmname} - Drops IN: ${counters_dropsIn_count}
    log    Trunk ${trunk_tmname} - Drops Out: ${counters_dropsOut_count}
    should be true    ${counters_dropsIn_count} < ${trunk_dropsIn_threshold}
    should be true    ${counters_dropsOut_count} < ${trunk_dropsOut_threshold}
    [Return]    ${api_response}

Verify Trunk Error Counters on BIG-IP
    [Documentation]    Verifies that trunk errors are below a certain threshold (defaults to 500 for both in and out thresholds) (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/tmos-routing-administration-13-0-0/3.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}   ${trunk_name}    ${trunk_errorsIn_threshold}=500    ${trunk_errorsOut_threshold}=500
    ${api_uri}    set variable    /mgmt/tm/net/trunk/${trunk_name}/stats
    set test variable    ${api_uri}
    ${api_response}    BIG-IP iControl BasicAuth GET    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}
    Should Be Equal As Strings    ${api_response.status_code}    200
    ${api_response_dict}    to json    ${api_response.content}
    dictionary should contain item  ${api_response_dict}    kind    tm:net:trunk:trunkstats
    ${trunk_stats_dict}    get from dictionary   ${api_response_dict}    entries
    ${trunk_stats_dict}    get from dictionary   ${trunk_stats_dict}    https://localhost/mgmt/tm/net/trunk/${trunk_name}/${trunk_name}/stats
    ${trunk_stats_dict}    get from dictionary   ${trunk_stats_dict}    nestedStats
    ${trunk_stats_dict}    get from dictionary   ${trunk_stats_dict}    entries
    ${counters_errorsIn_dict}    get from dictionary   ${trunk_stats_dict}    counters.errorsIn
    ${counters_errorsIn_count}    get from dictionary   ${counters_errorsIn_dict}    value
    ${counters_errorsOut_dict}    get from dictionary   ${trunk_stats_dict}    counters.errorsOut
    ${counters_errorsOut_count}    get from dictionary   ${counters_errorsOut_dict}   value
    ${trunk_tmname}    get from dictionary   ${trunk_stats_dict}    tmName
    ${trunk_tmname}    get from dictionary   ${trunk_tmname}    description
    log    Trunk ${trunk_tmname} - Errors In: ${counters_errorsIn_count}
    log    Trunk ${trunk_tmname} - Errors Out: ${counters_errorsOut_count}
    should be true    ${counters_errorsIn_count} < ${trunk_errorsIn_threshold}
    should be true    ${counters_errorsOut_count} < ${trunk_errorsOut_threshold}
    [Return]    ${api_response}

Get BIG-IP Trunk bitsIn Value
    [Documentation]    Retrieve the "bits in" counter on a BIG-IP trunk (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/tmos-routing-administration-13-0-0/3.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}   ${trunk_name}
    ${api_uri}    set variable    /mgmt/tm/net/trunk/${trunk_name}/stats
    set test variable    ${api_uri}
    ${api_response}    BIG-IP iControl BasicAuth GET    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}
    Should Be Equal As Strings    ${api_response.status_code}    200
    ${api_response_dict}    to json    ${api_response.content}
    dictionary should contain item  ${api_response_dict}    kind    tm:net:trunk:trunkstats
    ${trunk_stats_dict}    get from dictionary   ${api_response_dict}    entries
    ${trunk_stats_dict}    get from dictionary   ${trunk_stats_dict}    https://localhost/mgmt/tm/net/trunk/${trunk_name}/${trunk_name}/stats
    ${trunk_stats_dict}    get from dictionary   ${trunk_stats_dict}    nestedStats
    ${trunk_stats_dict}    get from dictionary   ${trunk_stats_dict}    entries
    ${counters_bitsIn_dict}    get from dictionary   ${trunk_stats_dict}    counters.bitsIn
    ${counters_bitsIn_count}    get from dictionary   ${counters_bitsIn_dict}    value
    ${trunk_tmname}    get from dictionary   ${trunk_stats_dict}    tmName
    ${trunk_tmname}    get from dictionary   ${trunk_tmname}    description
    log    Trunk ${trunk_tmname} - Bits In Counter: ${counters_bitsIn_count}
    [Return]    ${api_response}

Get BIG-IP Trunk bitsOut Value
    [Documentation]    Retrieve the "bits out" counter on a BIG-IP trunk (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/tmos-routing-administration-13-0-0/3.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}   ${trunk_name}
    ${api_uri}    set variable    /mgmt/tm/net/trunk/${trunk_name}/stats
    set test variable    ${api_uri}
    ${api_response}    BIG-IP iControl BasicAuth GET    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}
    Should Be Equal As Strings    ${api_response.status_code}    200
    ${api_response_dict}    to json    ${api_response.content}
    dictionary should contain item  ${api_response_dict}    kind    tm:net:trunk:trunkstats
    ${trunk_stats_dict}    get from dictionary   ${api_response_dict}    entries
    ${trunk_stats_dict}    get from dictionary   ${trunk_stats_dict}    https://localhost/mgmt/tm/net/trunk/${trunk_name}/${trunk_name}/stats
    ${trunk_stats_dict}    get from dictionary   ${trunk_stats_dict}    nestedStats
    ${trunk_stats_dict}    get from dictionary   ${trunk_stats_dict}    entries
    ${counters_bitsOut_dict}    get from dictionary   ${trunk_stats_dict}    counters.bitsOut
    ${counters_bitsOut_count}    get from dictionary   ${counters_bitsOut_dict}    value
    ${trunk_tmname}    get from dictionary   ${trunk_stats_dict}    tmName
    ${trunk_tmname}    get from dictionary   ${trunk_tmname}    description
    log    Trunk ${trunk_tmname} - Bits Out Counter: ${counters_bitsOut_count}
    [Return]    ${api_response}


######################
## security firewall
######################

Create Firewall Policy
    [Documentation]    Creates a new blank firewall policy on the BIG-IP (https://techdocs.f5.com/kb/en-us/products/big-ip-afm/manuals/product/network-firewall-policies-implementations-13-0-0.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${policy_name}    ${partition}=Common
    ${api_uri}    set variable    /mgmt/tm/security/firewall/policy
    ${api_payload}    create dictionary    name=${policy_name}    partition=${partition}
    ${api_response}    BIG-IP iControl BasicAuth POST    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Verify Firewall Policy Exists
    [Documentation]    Verifies if a firewall policy exists on the BIG-IP (https://techdocs.f5.com/kb/en-us/products/big-ip-afm/manuals/product/network-firewall-policies-implementations-13-0-0.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${policy_name}    ${partition}=Common
    ${api_uri}    set variable    /mgmt/tm/security/firewall/policy/~${partition}~${policy_name}
    ${api_response}    BIG-IP iControl BasicAuth GET    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Create Firewall Port List
    [Documentation]    Creates a firewall port list on the BIG-IP (https://techdocs.f5.com/kb/en-us/products/big-ip-afm/manuals/product/network-firewall-policies-implementations-13-0-0.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${port_list_name}    ${port_list}    ${partition}=Common
    ${api_uri}    set variable    /mgmt/tm/security/firewall/port-list
    ${api_payload}    create dictionary    name=${port_list_name}    partition=${partition}    ports=${port_list}
    ${api_response}    BIG-IP iControl BasicAuth POST    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Retrieve Firewall Port List
    [Documentation]    Retrieves a firewall port list from the BIG-IP (https://techdocs.f5.com/kb/en-us/products/big-ip-afm/manuals/product/network-firewall-policies-implementations-13-0-0.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${port_list_name}    ${partition}=Common
    ${api_uri}    set variable    /mgmt/tm/security/firewall/port-list/~${partition}~${port_list_name}
    ${api_response}    BIG-IP iControl BasicAuth GET    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Create Firewall Address List
    [Documentation]    Creates a firewall address list on the BIG-IP (https://techdocs.f5.com/kb/en-us/products/big-ip-afm/manuals/product/network-firewall-policies-implementations-13-0-0.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${address_list_name}    ${address_list}    ${partition}=Common
    ${api_uri}    set variable    /mgmt/tm/security/firewall/address-list
    ${api_payload}    create dictionary    name=${address_list_name}    partition=${partition}    addresses=${address_list}
    ${api_response}    BIG-IP iControl BasicAuth POST    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Retrieve Firewall Address List
    [Documentation]    Retrieves a firewall address list from the BIG-IP (https://techdocs.f5.com/kb/en-us/products/big-ip-afm/manuals/product/network-firewall-policies-implementations-13-0-0.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${address_list_name}    ${partition}=Common
    ${api_uri}    set variable    /mgmt/tm/security/firewall/address-list/~${partition}~${address_list_name}
    ${api_response}    BIG-IP iControl BasicAuth GET    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Add Rule to Firewall Policy
    [Documentation]    Creates a new rule in an AFM firewall policy (https://techdocs.f5.com/kb/en-us/products/big-ip-afm/manuals/product/network-firewall-policies-implementations-13-0-0.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${policy_name}    ${rule}    ${partition}=Common
    ${rule}    to json    ${rule}
    ${api_uri}    set variable    /mgmt/tm/security/firewall/policy/~${partition}~${policy_name}/rules
    ${api_payload}    set variable    ${rule}
    ${api_response}    BIG-IP iControl BasicAuth POST    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Retrieve Firewall Rule from Policy
    [Documentation]    Retrieves a rule from an AFM firewall policy (https://techdocs.f5.com/kb/en-us/products/big-ip-afm/manuals/product/network-firewall-policies-implementations-13-0-0.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${policy_name}    ${rule_name}    ${partition}=Common
    ${api_uri}    set variable    /mgmt/tm/security/firewall/policy/~${partition}~${policy_name}/rules/${rule_name}
    ${api_response}    BIG-IP iControl BasicAuth GET    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Retrieve Firewall Policy Stats
    [Documentation]    Retrieve hit counters for a firewall policy (https://support.f5.com/csp/article/K00842042)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${policy_name}    ${partition}=Common
    ${api_uri}    set variable    /mgmt/tm/security/firewall/policy/~${partition}~${policy_name}/stats
    ${api_response}    BIG-IP iControl BasicAuth GET    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

###############
## sys config
###############

Save the BIG-IP Configuration
    [Documentation]    Writes the BIG-IP configuration to disk (https://support.f5.com/csp/article/K50710744)
    [Arguments]    ${bigip_host}   ${bigip_username}    ${bigip_password}
    ${api_payload}    create dictionary    command    save
    ${api_uri}    set variable    /mgmt/tm/sys/config
    ${api_response}    BIG-IP iControl BasicAuth POST    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}


Load the BIG-IP Default Configuration
    [Documentation]    Loads the factory default configuration to a BIG-IP (https://support.f5.com/csp/article/K50710744)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}
    ${api_payload}    create dictionary    command=load    name=default
    ${api_uri}    set variable    /mgmt/tm/sys/config
    ${api_response}    BIG-IP iControl BasicAuth POST    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    should be equal as strings    ${api_response.status_code}    200
    [Return]    ${api_response}

############
## sys cpu
############

Retrieve CPU Statistics
    [Documentation]    Retrieves CPU utilization statistics on the BIG-IP (https://support.f5.com/csp/article/K15468)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}
    ${api_uri}    set variable    /mgmt/tm/sys/cpu
    set test variable    ${api_uri}
    ${api_response}    BIG-IP iControl BasicAuth GET    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}
    should be equal as strings    ${api_response.status_code}    200
    [Teardown]    Run Keywords   Delete All Sessions
    [Return]    ${api_response}

#################
## sys failover
#################

Send a BIG-IP to Standby
    [Documentation]    Sends an active BIG-IP to standby; must be executed on active member (https://support.f5.com/csp/article/K48900343)
    ...   Warning! The Force to Standby feature should not be used when the HA group feature is enabled! (https://support.f5.com/csp/article/K14515)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${traffic-group}=traffic-group-1
    ${api_payload}    create dictionary    kind=tm:sys:failover:runstate    command=run    standby=${true}
    ${api_uri}    set variable    /mgmt/tm/sys/failover
    ${api_response}    BIG-IP iControl BasicAuth POST    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    should be equal as strings    ${api_response.status_code}    200
    sleep    2s
    ${failover_state}    Retrieve CM Failover State    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}
    should be equal as strings    ${failover_state}    standby
    [Return]    ${failover_state}

Take a BIG-IP Offline
    [Documentation]    Instructs a BIG-IP HA member to stop participating in clustering (https://support.f5.com/csp/article/K15122)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}
    ${api_payload}    create dictionary    kind=tm:sys:failover:runstate    command=run    offline=${true}
    set test variable    ${api_payload}
    ${api_uri}    set variable    /mgmt/tm/sys/failover
    set test variable    ${api_uri}
    ${api_response}    BIG-IP iControl BasicAuth POST    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    should be equal as strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Place a BIG-IP Online
    [Documentation]    Instructs a BIG-IP HA member to resume participation in clustering (https://support.f5.com/csp/article/K15122)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}
    ${api_payload}    create dictionary    kind=tm:sys:failover:runstate    command=run    online=${true}
    set test variable    ${api_payload}
    ${api_uri}    set variable    /mgmt/tm/sys/failover
    set test variable    ${api_uri}
    ${api_response}    BIG-IP iControl BasicAuth POST    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    should be equal as strings    ${api_response.status_code}    200
    [Return]    ${api_response}

########################
## sys global-settings
########################

Disable BIG-IP Management Interface DHCP
    [Documentation]    Disables DHCP on the BIG-IP's mgmt port (https://support.f5.com/csp/article/K14298)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}
    ${api_payload}    create dictionary    mgmtDhcp    disabled
    ${api_uri}    set variable    /mgmt/tm/sys/global-settings
    ${api_response}    BIG-IP iControl BasicAuth PATCH    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Enable BIG-IP Management Interface DHCP
    [Documentation]    Enables DHCP on the BIG-IP's mgmt port (https://support.f5.com/csp/article/K14298)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}
    ${api_payload}    create dictionary    mgmtDhcp    enabled
    ${api_uri}    set variable    /mgmt/tm/sys/global-settings
    ${api_response}    BIG-IP iControl BasicAuth PATCH    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}


############
## sys ha
############

Create BIG-IP HA Group
    [Documentation]    Creates an HA group on the BIG-IP, which is a group of devices and objects that are used to create an HA score for score-based HA (See https://devcentral.f5.com/s/articles/configure-ha-groups-on-big-ip-26678)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${ha_group_name}    ${active_bonus}=10    ${clusters}=[]    ${description}="Created by Robot Framework"    ${state}=enabled     ${pools}=[]    ${trunks}=[]    
    ${pools}    to json    ${pools}
    ${clusters}    to json    ${clusters}
    ${trunks}    to json    ${trunks}
    ${api_payload}    create dictionary    kind=tm:sys:ha-group:ha-groupstate    name=${ha_group_name}    activeBonus=${${active_bonus}}    description=${description}    pools=${pools}    clusters=${clusters}    trunks=${trunks}    
    run keyword if    '${state}' == 'disabled'    set to dictionary    ${api_payload}    disabled=${true}
    run keyword if    '${state}' == 'enabled'    set to dictionary    ${api_payload}    enabled=${true}
    ${api_uri}    set variable    /mgmt/tm/sys/ha-group
    ${api_response}    BIG-IP iControl BasicAuth POST    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}    
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}


####################
## sys performance
####################

Retrieve All BIG-IP Performance Statistics
    [Documentation]    Retrieves all of the BIG-IP statistics (CPU, Memory, Throughput, Connections) - See relevant related keyword for documentation
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}
    ${api_uri}    set variable    /mgmt/tm/sys/performance/all-stats
    ${api_response}    BIG-IP iControl BasicAuth GET    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}
    should be equal as strings    ${api_response.status_code}    200
    Log    API RESPONSE: ${api_response.content}
    [Teardown]    Run Keywords   Delete All Sessions
    [Return]    ${api_response}

Retrieve BIG-IP Performance Connection Statistics
    [Documentation]    Retrieves connection and connections-per-second statistics (https://support.f5.com/csp/article/K14174)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}
    ${api_uri}    set variable    /mgmt/tm/sys/performance/connections
    ${api_response}    BIG-IP iControl BasicAuth GET    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}
    should be equal as strings    ${api_response.status_code}    200
    Log    API RESPONSE: ${api_response.content}
    [Teardown]    Run Keywords   Delete All Sessions
    [Return]    ${api_response}

Retrieve BIG-IP Performance DNS Express Statistics
    [Documentation]    Retrieves statistics on BIG-IP DNS Express (https://support.f5.com/csp/article/K14510)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}
    ${api_uri}    set variable    /mgmt/tm/sys/performance/dnsexpress
    ${api_response}    BIG-IP iControl BasicAuth GET    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}
    should be equal as strings    ${api_response.status_code}    200
    Log    API RESPONSE: ${api_response.content}
    [Teardown]    Run Keywords   Delete All Sessions
    [Return]    ${api_response}

Retrieve BIG-IP Performance DNSSEC Statistics
    [Documentation]    Shows DNSSEC performance statistics (https://support.f5.com/csp/article/K14510)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}
    ${api_uri}    set variable    /mgmt/tm/sys/performance/dnssec
    ${api_response}    BIG-IP iControl BasicAuth GET    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}
    should be equal as strings    ${api_response.status_code}    200
    Log    API RESPONSE: ${api_response.content}
    [Teardown]    Run Keywords   Delete All Sessions
    [Return]    ${api_response}

Retrieve BIG-IP Performance RAM Cache Statistics
    [Documentation]    Retrieves statistics on the BIG-IP's RAM cache usage (https://support.f5.com/csp/article/K13244)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}
    ${api_uri}    set variable    /mgmt/tm/sys/performance/ramcache
    set test variable    ${api_uri}
    ${api_response}    BIG-IP iControl BasicAuth GET    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}
    should be equal as strings    ${api_response.status_code}    200
    Log    API RESPONSE: ${api_response.content}
    [Teardown]    Run Keywords   Delete All Sessions
    [Return]    ${api_response}

Retrieve BIG-IP Performance System Statistics
    [Documentation]    Retrieves the BIG-IP CPU and Memory utilization (https://support.f5.com/csp/article/K16419)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}
    ${api_uri}    set variable    /mgmt/tm/sys/performance/system
    set test variable    ${api_uri}
    ${api_response}    BIG-IP iControl BasicAuth GET    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}
    should be equal as strings    ${api_response.status_code}    200
    Log    API RESPONSE: ${api_response.content}
    [Teardown]    Run Keywords   Delete All Sessions
    [Return]    ${api_response}

Retrieve BIG-IP Performance Throughput Statistics
    [Documentation]    Retrieves the BIG-IP throughput statistics (https://support.f5.com/csp/article/K50309321)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}
    ${api_uri}    set variable    /mgmt/tm/sys/performance/throughput
    set test variable    ${api_uri}
    ${api_response}    BIG-IP iControl BasicAuth GET    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}
    should be equal as strings    ${api_response.status_code}    200
    Log    API RESPONSE: ${api_response.content}
    [Teardown]    Run Keywords   Delete All Sessions
    [Return]    ${api_response}

Reset All Performance Stats
    [Documentation]    Clears all of the performance stats (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/ltm-basics-13-0-0/2.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}
    ${api_payload}    Create Dictionary    command=reset-stats
    ${api_uri}    set variable    /mgmt/tm/sys/performance/all-stats
    ${api_response}    BIG-IP iControl BasicAuth POST    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Reset Performance Throughput Stats
    [Documentation]    Clears the performance throughput stats (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/ltm-basics-13-0-0/2.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}
    ${api_payload}    Create Dictionary    command=reset-stats
    ${api_uri}    set variable    /mgmt/tm/sys/performance/throughput
    ${api_response}    BIG-IP iControl BasicAuth POST    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Reset Performance System Stats
    [Documentation]    Clears the performance system stats (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/ltm-basics-13-0-0/2.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}
    ${api_payload}    Create Dictionary    command=reset-stats
    ${api_uri}    set variable    /mgmt/tm/sys/performance/system
    ${api_response}    BIG-IP iControl BasicAuth POST    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Reset Performance Ramcache Stats
    [Documentation]    Clears the performance ramcache stats (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/ltm-basics-13-0-0/2.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}
    ${api_payload}    Create Dictionary    command=reset-stats
    ${api_uri}    set variable    /mgmt/tm/sys/performance/ramcache
    ${api_response}    BIG-IP iControl BasicAuth POST    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Reset Performance DNSSEC Stats
    [Documentation]    Clears the performance DNSSEC stats (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/ltm-basics-13-0-0/2.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}
    ${api_payload}    Create Dictionary    command=reset-stats
    ${api_uri}    set variable    /mgmt/tm/sys/performance/dnssec
    ${api_response}    BIG-IP iControl BasicAuth POST    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Reset Performance DNS Express Stats
    [Documentation]    Clears the performance DNS Express stats (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/ltm-basics-13-0-0/2.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}
    ${api_payload}    Create Dictionary    command=reset-stats
    ${api_uri}    set variable    /mgmt/tm/sys/performance/dnsexpress
    ${api_response}    BIG-IP iControl BasicAuth POST    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Reset Performance Connection Stats
    [Documentation]    Clears the performance connection stats (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/ltm-basics-13-0-0/2.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}
    ${api_payload}    Create Dictionary    command=reset-stats
    ${api_uri}    set variable    /mgmt/tm/sys/performance/connection
    ${api_response}    BIG-IP iControl BasicAuth POST    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}


############
## sys scf
############

Save an SCF on the BIG-IP
    [Documentation]    Saves a Single Configuration File (SCF) on the BIG-IP (https://support.f5.com/csp/article/K13408)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}   ${scf_filename}
    ${options_dict}    create dictionary    file=${SCF_FILENAME}    no-passphrase=
    ${options_list}    create list    ${options_dict}
    ${api_payload}    create dictionary    command=save    options=${options_list}
    ${api_uri}    set variable    /mgmt/tm/sys/config
    ${api_response}    BIG-IP iControl BasicAuth POST    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    should be equal as strings    ${api_response.status_code}    200
    Log    API RESPONSE: ${api_response.content}
    [Return]    ${api_response}

Load an SCF on the BIG-IP
    [Documentation]    Loads a Single Configuration File (SCF) on the BIG-IP (https://support.f5.com/csp/article/K13408)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}   ${scf_filename}
    ${options_dict}    create dictionary    file=${SCF_FILENAME}    no-passphrase=
    ${options_list}    create list    ${options_dict}
    ${api_payload}    create dictionary    command=load    options=${options_list}
    ${api_uri}    set variable    /mgmt/tm/sys/config
    ${api_response}    BIG-IP iControl BasicAuth POST    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    should be equal as strings    ${api_response.status_code}    200
    Log    API RESPONSE: ${api_response.content}
    [Return]    ${api_response}

#############
## sys snmp
#############

Create BIG-IP SNMP Community
    [Documentation]    Creates an SNMP community on the BIG-IP (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/bigip-external-monitoring-implementations-13-0-0/13.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${name}    ${communityName}    ${access}=ro    ${ipv6}=disabled    ${description}=
    ${api_payload}    Create Dictionary   access=${access}    communityName=${communityName}    ipv6=${ipv6}   description=${description}    name=${name}
    ${api_uri}    set variable    /mgmt/tm/sys/snmp/communities
    ${api_response}    BIG-IP iControl BasicAuth POST    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Create SNMPv3 User
    [Documentation]    Creates an SNMPv3 User on the BIG-IP (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/bigip-external-monitoring-implementations-13-0-0/13.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${name}    ${username}    ${authProtocol}    ${privacyProtocol}    ${authPassword}   ${privacyPassword}    ${securityLevel}
    ${api_uri}    set variable    /mgmt/tm/sys/snmp/users
    ${api_payload}    create dictionary    name=${name}    username=${username}    authProtocol=${authProtocol}   privacyProtocol=${privacyProtocol}    authPassword=${authPassword}   privacyPassword=${privacyPassword}    securityLevel=${securityLevel}
    ${api_response}    BIG-IP iControl BasicAuth POST    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Delete SNMP Community
    [Documentation]    Deletes an SNMP community on the BIG-IP (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/bigip-external-monitoring-implementations-13-0-0/13.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${name}
    ${api_uri}    set variable    /mgmt/tm/sys/snmp/communities/${name}
    ${api_response}    BIG-IP iControl BasicAuth DELETE    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Remove Host from BIG-IP SNMP Allow-List
    [Documentation]    Adds a host to the BIG-IP SNMP allow ACL (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/bigip-external-monitoring-implementations-13-0-0/13.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${snmphost}
    ${api_uri}    set variable    /mgmt/tm/sys/snmp
    ${api_response}    BIG-IP iControl BasicAuth GET    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}
    Should Be Equal As Strings    ${api_response.status_code}    200
    ${snmp-allow-list}    evaluate    json.loads('''${api_response.content}''')   json
    ${snmp-allow-list}    Get from Dictionary    ${snmp-allow-list}    allowedAddresses
    Log    Pre-modification SNMP allow list: ${snmp-allow-list}
    Remove from List    ${snmp-allow-list}    ${snmphost}
    Log    Post-modification SNMP allow list: ${snmp-allow-list}
    ${api_uri}    set variable    /mgmt/tm/sys/snmp
    ${api_payload}    Create Dictionary    allowedAddresses=${snmp-allow-list}
    ${api_response}    BIG-IP iControl BasicAuth PATCH    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Add Host to BIG-IP SNMP Allow-List
    [Documentation]    Adds the IP address or subnet to the SNMP allowed hosts list (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/bigip-external-monitoring-implementations-13-0-0/13.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${snmphost}
    ${api_uri}    set variable    /mgmt/tm/sys/snmp
    ${api_response}    BIG-IP iControl BasicAuth GET    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}
    Should Be Equal As Strings    ${api_response.status_code}    200
    ${snmp-allow-list}    evaluate    json.loads('''${api_response.content}''')   json
    ${snmp-allow-list}    Get from Dictionary    ${snmp-allow-list}    allowedAddresses
    Append to List    ${snmp-allow-list}    ${snmphost}
    ${api_uri}    set variable    /mgmt/tm/sys/snmp
    ${api_payload}    Create Dictionary    allowedAddresses=${snmp-allow-list}
    ${api_response}    BIG-IP iControl BasicAuth PATCH    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Get SNMPv2 IPv4 sysDescr
    [Documentation]    Gathers the response of the sysDescr field to test SNMPv2 connectivity on the BIG-IP (https://support.f5.com/csp/article/K13322)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${snmphost}    ${snmpcommunity}    ${snmpv2_port}    ${snmpv2_timeout}    ${snmpv2_retries}
    ${connect_status}    Open Snmp Connection    host=${snmphost}    community_string=${snmpcommunity}   port=${snmpv2_port}    timeout=${snmpv2_timeout}    retries=${snmpv2_retries}
    Log    SNMP Connect Status: ${connect_status}
    ${snmp_ipv4_sysDescr} =    Get Display String    .iso.3.6.1.2.1.1.5
    Log    SNMP value for OID .iso.3.6.1.2.1.1.5 returned: ${snmp_ipv4_sysDescr}
    [Teardown]    Close All Snmp Connections
    [Return]    ${snmp_ipv4_sysDescr}

Get SNMPv3 IPv4 sysDescr
    [Documentation]    Gathers the response of the sysDescr field to test SNMPv3 connectivity on the BIG-IP (https://support.f5.com/csp/article/K13322)
    [Arguments]    ${snmphost}    ${snmpv3_user}    ${snmpv3_auth_pass}    ${snmpv3_priv_pass}    ${snmpv3_auth_proto}    ${snmpv3_priv_proto}    ${snmpv3_port}    ${snmpv3_timeout}   ${snmpv3_retries}
    ${connect_status}    Open Snmp V3 Connection    ${snmphost}    ${snmpv3_user}    ${snmpv3_auth_pass}    ${snmpv3_priv_pass}    ${snmpv3_auth_proto}    ${snmpv3_priv_proto}    ${snmpv3_port}    ${snmpv3_timeout}   ${snmpv3_retries}
    Log    SNMP Connect Status: ${connect_status}
    ${snmp_ipv4_sysDescr} =    Get Display String    .iso.3.6.1.2.1.1.5
    Log    SNMP value for OID .iso.3.6.1.2.1.1.5 returned: ${snmp_ipv4_sysDescr}
    [Teardown]    Close All Snmp Connections
    [Return]    ${snmp_ipv4_sysDescr}

Create BIG-IP SNMPv2 Trap Destination
    [Documentation]    Creates an SNMPv2 trap destination on the BIG-IP (https://techdocs.f5.com/kb/en-us/products/big-ip-afm/manuals/product/dos-firewall-implementations-13-1-0/8.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${name}    ${community}    ${host}    ${description}="Created by Robot Framework"
    ${api_payload}    create dictionary    name=${name}    community=${community}    host=${host}    version=2c    description=${description}
    ${api_uri}    set variable    /mgmt/tm/sys/snmp
    ${api_response}    BIG-IP iControl BasicAuth PATCH    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Trigger an SNMPv2 Trap on the BIG-IP
    [Documentation]    Triggers an SNMP trap from the syslog-ng utility on the BIG-IP (https://support.f5.com/csp/article/K11127)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${snmpv2_trap_facility}    ${snmpv2_trap_level}    ${snmpv2_trap_message}
    ${api_payload}    create dictionary    command    run    utilCmdArgs    -c "logger -p ${snmpv2_trap_facility}}.${snmpv2_trap_level}} '${snmpv2_trap_message}}'"
    ${api_uri}    set variable    /mgmt/tm/util/bash
    ${api_response}    BIG-IP iControl BasicAuth POST    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Walk SNMPv3 Host
    [Documentation]    Performs an SNMPv3 walk on the BIG-IP (https://linux.die.net/man/1/snmpwalk)
    [Arguments]    ${snmphost}    ${snmpv3_user}    ${snmpv3_auth_pass}    ${snmpv3_priv_pass}    ${snmpv3_auth_proto}    ${snmpv3_priv_proto}    ${snmpv3_port}    ${snmpv3_timeout}   ${snmpv3_retries}
    ${connect_status}    Open Snmp V3 Connection    ${snmphost}    ${snmpv3_user}    ${snmpv3_auth_pass}    ${snmpv3_priv_pass}    ${snmpv3_auth_proto}    ${snmpv3_priv_proto}    ${snmpv3_port}    ${snmpv3_timeout}   ${snmpv3_retries}
    Log    SNMP Connect Status: ${connect_status}
    ${walk_response}    walk    .iso.3.6.1.2.1.1
    log    SNMP Walk Result: ${walk_response}

Create BIG-IP SNMPv3 Trap Destination
    [Documentation]    Creates an SNMPv3 trap destination on the BIG-IP (https://techdocs.f5.com/kb/en-us/products/big-ip-afm/manuals/product/dos-firewall-implementations-13-1-0/8.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${snmphost}    ${snmpv3_user}    ${snmpv3_auth_pass}    ${snmpv3_priv_pass}    ${snmpv3_auth_proto}    ${snmpv3_priv_proto}    ${snmpv3_port}    ${snmpv3_community}    ${snmpv3_security_level}    ${snmpv3_security_name}
    ${api_payload}    create dictionary    name=robot_framework_snmpv3  authPassword=${snmpv3_auth_pass}    authProtocol=${snmpv3_auth_proto}    community=${snmpv3_community}    host=${snmphost}    port=${${snmpv3_port}}  privacyPassword=${snmpv3_priv_pass}    privacyProtocol=${snmpv3_priv_proto}    securityName=${snmpv3_security_name}    version=3   securityLevel=${snmpv3_security_level}
    ${api_uri}    set variable    /mgmt/tm/sys/snmp/traps
    ${api_response}    BIG-IP iControl BasicAuth POST    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Set the BIG-IP SNMP Trap Community
    [Documentation]    Sets the community to use when sending SNMP traps (https://techdocs.f5.com/kb/en-us/products/big-ip-afm/manuals/product/dos-firewall-implementations-13-1-0/8.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${community_name}
    ${api_payload}    create dictionary    trapCommunity=${community_name}
    ${api_uri}    set variable    /mgmt/tm/sys/snmp
    ${api_response}    BIG-IP iControl BasicAuth PATCH    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Trigger an SNMPv3 Trap on the BIG-IP
    [Documentation]    Triggers an SNMP trap from the syslog-ng utility on the BIG-IP (https://support.f5.com/csp/article/K11127)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}
    ${api_payload}    create dictionary    command    run    utilCmdArgs    -c "logger -p ${SNMPV3_TRAP_FACILITY}.${SNMPV3_TRAP_LEVEL} '${SNMPV3_TRAP_MESSAGE}'"
    ${api_uri}    set variable    /mgmt/tm/util/bash
    ${api_response}    BIG-IP iControl BasicAuth POST    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}


##################
## sys turboflex
##################

Enable BIG-IP Turboflex Profile
    [Documentation]    Changes the Turboflex profile in use on a BIG-IP platform (not supported on all platforms) (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/f5-platform-turboflex-profiles.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${turboflex_profile}
    ${api_uri}    set variable    /mgmt/tm/sys/turboflex/profile-config
    ${api_payload}    create dictionary    kind=tm:sys:turboflex:profile-config:profile-configstate    type=${turboflex_profile}
    ${api_response}    BIG-IP iControl BasicAuth PATCH    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

View BIG-IP Turboflex Profile
    [Documentation]    Displays the current Turboflex profile in use on a BIG-IP platform (not supported on all platforms) (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/f5-platform-turboflex-profiles.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}
    ${api_uri}    set variable    /mgmt/tm/sys/turboflex/profile-config
    ${api_response}    BIG-IP iControl BasicAuth GET    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}


###########
## BIG-IQ 
###########

Import a BIG-IP Cluster into the BIG-IQ
    [Documentation]    Imports a BIG-IP pair into BIG-IQ
    [Arguments]        ${bigiq_host}    ${bigiq_username}    ${bigip_password}    ${bigiq_bigip_import_task_name}    ${bigiq_bigip_cluster_name}    ${primary_bigip_host}    ${primary_bigip_username}     ${primary_bigip_password}    ${primary_module_list}    ${secondary_bigip_host}    ${secondary_bigip_username}    ${secondary_bigip_password}    ${secondary_module_list}    ${primary_bigip_port}=443    ${secondary_bigip_port}=443    
    ${primary_bigip_details}    create dictionary    address=${primary_bigip_host}    userName=${primary_bigip_username}    password=${primary_bigip_password}    httpsPort=${${primary_bigip_port}}
    ${primary_bigip_dict}    create dictionary    newDevice=${primary_bigip_details}    clusterName=${bigiq_bigip_cluster_name}    useBigiqSync=False    deployWhenDscChangesPending=False    moduleList
    ${secondary_bigip_details}    create dictionary    address=${secondary_bigip_host}    userName=${secondary_bigip_username}    password=${secondary_bigip_password}    httpsPort=${${secondary_bigip_port}}
    ${secondary_bigip_dict}    create dictionary    newDevice=${secondary_bigip_details}    clusterName=${bigiq_bigip_cluster_name}    useBigiqSync=False    deployWhenDscChangesPending=False    moduleList
    ${device_details}    create list    ${primary_bigip_dict}    ${secondary_bigip_dict}
    ${stats_collection}    create dictionary    enabled=${FALSE}    zone=default
    ${api_payload}    create dictionary    name=${bigiq_bigip_import_task_name}    defaultStatsConfig=${stats_collection}    deviceDetails=${device_details}    conflictPolicy=USE_BIGIQ    versionedConflictPolicy=USE_BIGIQ    deviceConflictPolicy=USE_BIGIP    snapshotWorkingConfig=true
    ${api_uri}    set variable    /mgmt/cm/global/tasks/device-discovery-import-controller
    ${api_response}    BIG-IP iControl BasicAuth POST    bigip_host=${bigiq_host}    bigip_username=${bigiq_username}    bigip_password=${bigiq_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response.json}
    
Verify BIG-IQ Import Task Completion
    [Documentation]    Checks a task status for FINISHED for a BIG-IQ import task
    [Arguments]        ${bigiq_host}    ${bigiq_username}    ${bigip_password}    ${bigiq_bigip_import_task_url}        
    ${api_uri}    set variable    ${bigiq_bigip_import_task_url}
    ${api_response}    BIG-IP iControl BasicAuth POST    bigip_host=${bigiq_host}    bigip_username=${bigiq_username}    bigip_password=${bigiq_password}    api_uri=${api_uri}
    Should Be Equal As Strings    ${api_response.status_code}    200
    ${task_status}    get from dictionary    ${api_response.json}    status
    Should be Equal As Strings    ${task_status}    FINISHED
    [Return]    ${api_response.json}
     
Get BIG-IQ Snapshot Names    
    [Documentation]    Retrieves a list of available snapshots on the BIG-IQ for a particular module
    [Arguments]    ${bigiq_host}    ${bigiq_username}    ${bigiq_password}    ${module}
    ${api_uri}    /mgmt/cm/${module}/working-config/snapshots    
    ${api_response}    BIG-IP iControl BasicAuth GET    bigip_host=${bigiq_host}    bigip_username=${bigiq_username}    bigip_password=${bigiq_password}
    should be equal as strings    ${api_response.status_code}    200
    [Return]    ${api_response.json}

Resolve BIG-IQ List of Devices in BIG-IP Cluster    
    [Documentation]    Lists all of the BIG-IP devices in a BIG-IQ device cluster
    [Arguments]    ${bigiq_host}    ${bigiq_username}    ${bigiq_password}    ${bigip_cluster_name}    
    ${api_uri}    /mgmt/shared/resolver/device-groups/cm-bigip-cluster_${bigip_cluster_name}/devices
    ${api_response}    BIG-IP iControl BasicAuth GET    bigip_host=${bigiq_host}    bigip_username=${bigiq_username}    bigip_password=${bigiq_password}    api_uri=${api_uri}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response.json}

Create Node on BIG-IQ
    [Documentation]    Creates a node object on the BIG-IQ for deployment on a BIG-IP (https://techdocs.f5.com/kb/en-us/products/big-iq-centralized-mgmt/manuals/product/big-iq-centralized-management-local-traffic-and-network-implementations-6-1-0.html}
    [Arguments]    ${bigiq_host}    ${bigiq_username}    ${bigiq_password}    ${name}    ${address}    ${device_reference}    ${partition}=Common    ${description}=
    ${api_uri}    /mgmt/cm/adc-core/working-config/ltm/node
    ${api_payload}     create dictionary    name=${name}    partition=${partition}    description=${description}    address=${address}    deviceReference=${device_reference}
    ${api_response}    BIG-IP iControl BasicAuth POST    bigip_host=${bigiq_host}    bigip_username=${bigiq_username}    bigip_password=${bigiq_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response.json}

Create Pool on BIG-IQ
    [Documentation]    Creates a pool object on the BIG-IQ for configuration on a BIG-IP (https://techdocs.f5.com/kb/en-us/products/big-iq-centralized-mgmt/manuals/product/big-iq-centralized-management-local-traffic-and-network-implementations-6-1-0.html)
    [Arguments]    ${bigiq_host}    ${bigiq_username}    ${bigiq_password}    ${name}    ${device_reference}    ${partition}=Common    ${description}=Created by Robot Framework
    ${api_url}    set variable    /mgmt/cm/adc-core/working-config/ltm/pool
    ${api_payload}    create dictionary    name=${name}    partition=${partition}    description=${description}    deviceReference=${device_reference}
    ${api_response}    BIG-IP iControl BasicAuth POST    bigip_host=${bigiq_host}    bigip_username=${bigiq_username}    bigip_password=${bigiq_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response.json}

Populate Pool on BIG-IQ
    [Documentation]    Creates a pool member within an existing pool using an existing node (https://techdocs.f5.com/kb/en-us/products/big-iq-centralized-mgmt/manuals/product/big-iq-centralized-management-local-traffic-and-network-implementations-6-1-0.html)
    [Arguments]      ${bigiq_host}    ${bigiq_username}    ${bigiq_password}    ${pool_member_name}    ${pool_member_port}    ${pool_reference}    ${node_reference}    ${partition}=Common    ${description}=Created by Robot Framework      
    ${pool_uri}    replace string    ${pool_reference}    https://localhost    ${EMPTY}
    ${api_url}    set variable    ${pool_uri}/members
    ${api_payload}    create dictionary    name=${pool_member_name}:${pool_member_port}    partition=${partition}    description=${description}    port=${pool_member_port}    nodeReference=${nodeReference}    
    ${api_response}    BIG-IP iControl BasicAuth POST    bigip_host=${bigiq_host}    bigip_username=${bigiq_username}    bigip_password=${bigiq_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response.json}
    
Create Virtual Server on BIG-IQ    
    [Documentation]    Creates a virtual server using an existing pool on the BIG-IQ for deployment on a BIG-IP (https://techdocs.f5.com/kb/en-us/products/big-iq-centralized-mgmt/manuals/product/big-iq-centralized-management-local-traffic-and-network-implementations-6-1-0.html)
    [Arguments]      ${bigiq_host}    ${bigiq_username}    ${bigiq_password}    ${name}    ${ip_protocol}    ${destination_address}    ${mask}   ${destination_port}    ${source_address}    ${source_address_translation}    ${device_reference}    ${pool_reference}    ${partition}=Common    ${description}=${EMPTY}    
    ${api_uri}    set variable    /mgmt/cm/adc-core/working-config/ltm/virtual
    ${api_payload}    create dictionary    name=${name}    partition=${partition}    description=${description}    ipProtocol=${ip_protocol}    destinationAddress=${destination_address}    mask=${mask}    destinationPort=${destination_port}   sourceAddress=${source_address}    sourceAddressTranslation=${source_address_translation}    deviceReference=${device_reference}    poolReference=${pool_reference}
    ${api_response}    BIG-IP iControl BasicAuth POST    bigip_host=${bigiq_host}    bigip_username=${bigiq_username}    bigip_password=${bigiq_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response.json}

Deploy BIG-IQ LTM Configuration
    [Documentation]    Deploys an LTM configuration to a BIG-IP using BIG-IQ
    [Arguments]    ${bigiq_host}    ${bigiq_username}    ${bigiq_password}    ${name}    ${skip_verify_config}    ${skip_distribution}    ${device_references}    ${objects_to_deploy_references}    ${deploy_specified_objects_only}    
    ${api_uri}    set variable    /mgmt/cm/adc-core/tasks/deploy-configuration
    ${api_payload}    create dictionary    skipVerifyConfig=${skip_verify_config}    skipDistribution=${skip_distribution}    name=${name}    deviceReferences=${device_references}    objectsToDeployReferences=${objects_to_deploy_references}    deploySpecifiedObjectsOnly=${deploy_specified_objects_only}
    ${api_response}    BIG-IP iControl BasicAuth POST    bigip_host=${bigiq_host}    bigip_username=${bigiq_username}    bigip_password=${bigiq_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response.json}

Restore an LTM Snapshot on the BIG-IQ
    [Documentation]    Reverts to a snapshot of a module configuration on the BIG-IP via BIG-IQ
    [Arguments]    ${bigiq_host}    ${bigiq_username}    ${bigiq_password}    ${name}    ${snapshot_reference}
    ${api_url}    set variable    /mgmt/cm/adc-core/tasks/restore-config
    ${api_payload}    create dictionary     name=${name}    snapshotReference=${snapshot_reference}
    ${api_response}    BIG-IP iControl BasicAuth POST    bigip_host=${bigiq_host}    bigip_username=${bigiq_username}    bigip_password=${bigiq_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response.json}


#Keywords to interact with Uplink Nexus 5K Switch

Disable Uplink Switch Interface
    [Documentation]    Steps to disable uplink at switch side
    [Arguments]  ${UPLINK_SWITCH_IP}  ${SWITCH_USER}  ${SWITCH_PASSWORD}  ${UPLINK_INTERFACE}
    Open Connection  ${UPLINK_SWITCH_IP}
    Login  ${SWITCH_USER}  ${SWITCH_PASSWORD}  delay=2.0 seconds
#    Set Client Configuration  prompt=#
#    Read Until Prompt
    Write  configure
    Write  int eth ${UPLINK_INTERFACE}
    Write  shutdown
    Close Connection

Re-enable Uplink Switch Interface
    [Documentation]    Steps to re-enable uplink at switch side
    [Arguments]  ${UPLINK_SWITCH_IP}  ${SWITCH_USER}  ${SWITCH_PASSWORD}  ${UPLINK_INTERFACE}
    Open Connection  ${UPLINK_SWITCH_IP}
    Login  ${SWITCH_USER}  ${SWITCH_PASSWORD}  delay=2.0 seconds
    Write  configure
    Write  int eth ${UPLINK_INTERFACE}
    Write  no shutdown
    Close Connection
