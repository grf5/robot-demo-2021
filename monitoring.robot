*** Settings ***
Documentation    This test checks for SNMP configuration and operation on the BIG-IP
Resource    robotframework-f5-tmos.robot

*** Variables ***
${PRIMARY_HOSTNAME}                     %{PRIMARY_HOSTNAME}
${PRIMARY_MGMT_IP}                      %{PRIMARY_MGMT_IP}
${PRIMARY_HTTP_USERNAME}                %{PRIMARY_HTTP_USERNAME}
${PRIMARY_HTTP_PASSWORD}                %{PRIMARY_HTTP_PASSWORD}
${SECONDARY_HOSTNAME}                   %{SECONDARY_HOSTNAME}
${SECONDARY_MGMT_IP}                    %{SECONDARY_MGMT_IP}
${SECONDARY_HTTP_USERNAME}              %{SECONDARY_HTTP_USERNAME}
${SECONDARY_HTTP_PASSWORD}              %{SECONDARY_HTTP_PASSWORD}
${ROBOT_HOST_IP}                        %{ROBOT_HOST_IP}
${SNMPv2_TRAP_HOST}                     %{SNMPv2_TRAP_HOST}
${SNMPV2_TRAP_FACILITY}                 %{SNMPV2_TRAP_FACILITY}
${SNMPV2_TRAP_LEVEL}                    %{SNMPV2_TRAP_LEVEL}
${SNMPV2_TRAP_MESSAGE}                  %{SNMPV2_TRAP_MESSAGE}
${SNMPV2_POLL_COMMUNITY}                %{SNMPV2_POLL_COMMUNITY}
${SNMPV2_PORT}                          %{SNMPV2_PORT}
${SNMPV2_TIMEOUT}                       %{SNMPV2_TIMEOUT}
${SNMPV2_RETRIES}                       %{SNMPV2_RETRIES}
${SNMPV3_TRAP_HOST}                     %{SNMPV3_TRAP_HOST}
${SNMPV3_TRAP_PORT}                     %{SNMPV3_TRAP_PORT}
${SNMPV3_TRAP_FACILITY}                 %{SNMPV3_TRAP_FACILITY}
${SNMPV3_TRAP_LEVEL}                    %{SNMPV3_TRAP_LEVEL}
${SNMPV3_TRAP_MESSAGE}                  %{SNMPV3_TRAP_MESSAGE}
${SNMPV3_USER}                          %{SNMPV3_USER}
${SNMPV3_COMMUNITY}                     %{SNMPV3_COMMUNITY}
${SNMPV3_AUTH_PASS}                     %{SNMPV3_AUTH_PASS}
${SNMPV3_AUTH_PROTO}                    %{SNMPV3_AUTH_PROTO}
${SNMPV3_PRIV_PASS}                     %{SNMPV3_PRIV_PASS}
${SNMPV3_PRIV_PROTO}                    %{SNMPV3_PRIV_PROTO}
${SNMPV3_PRIV_PROTO_SNMPLIB}            %{SNMPV3_PRIV_PROTO_SNMPLIB}
${SNMPV3_SECURITY_LEVEL}                %{SNMPV3_SECURITY_LEVEL}
${SNMPV3_SECURITY_NAME}                 %{SNMPV3_SECURITY_NAME}
${SNMPV3_PORT}                          %{SNMPV3_PORT}
${SNMPV3_TIMEOUT}                       %{SNMPV3_TIMEOUT}
${SNMPV3_RETRIES}                       %{SNMPV3_RETRIES}

*** Test Cases ***
Perform BIG-IP Quick Check
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

Syslog Configuration
    [Documentation]  Configures syslog on the BIG-IP
    set log level  trace
    log  Configure logging publisher, destination and logging profile on BIG-IP

Syslog Functionality - Splunk
    [Documentation]  Verifies that logs are being sent to Splunk
    set log level  trace
    log  Splunk-specific task would be run in this step

Delete the Default 'comm-public' SNMP Community on BIG-IP
    [Documentation]  Deletes the default SNMP community on the BIG-IP
    set log level  trace
    Delete SNMP Community    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    name=comm-public
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    Delete SNMP Community    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    name=comm-public

Configure BIG-IP SNMP Allowed List on BIG-IP
    [Documentation]  Adds a host to the SNMP ACL on the BIG-IP
    set log level  trace
    Add Host to BIG-IP SNMP Allow-List  bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    snmphost=${ROBOT_HOST_IP}
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    Add Host to BIG-IP SNMP Allow-List  bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    snmphost=${ROBOT_HOST_IP}

Configure SNMP Community on BIG-IP
    [Documentation]  Creates an SNMP community on the BIG-IP
    set log level  trace
    Create BIG-IP SNMP Community    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    name=${SNMPV2_POLL_COMMUNITY}   communityName=${SNMPV2_POLL_COMMUNITY}    description=Robot Framework TEST
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    Create BIG-IP SNMP Community    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    name=${SNMPV2_POLL_COMMUNITY}   communityName=${SNMPV2_POLL_COMMUNITY}    description=Robot Framework TEST

Change the SNMP Traps Community on BIG-IP
    [Documentation]  Changes the BIG-IP SNMP trap community
    set log level  trace
    Set the BIG-IP SNMP Trap Community    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    community_name=${SNMPV2_POLL_COMMUNITY}
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    Set the BIG-IP SNMP Trap Community    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    community_name=${SNMPV2_POLL_COMMUNITY}

Create SNMPv2 Trap Destination on BIG-IP
    [Documentation]  Creates an SNMP trap destination on the BIG-IP with SNMPv2 protocol specified
    set log level  trace
    Create BIG-IP SNMPv2 Trap Destination   bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    name=${SNMPV2_TRAP_HOST}    community=${SNMPV2_POLL_COMMUNITY}    host=${SNMPV2_TRAP_HOST}   
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    Create BIG-IP SNMPv2 Trap Destination   bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    name=${SNMPV2_TRAP_HOST}    community=${SNMPV2_POLL_COMMUNITY}    host=${SNMPV2_TRAP_HOST}

Create SNMPv3 User on BIG-IP
    [Documentation]  Creates a set of SNMPv3 credentials on the BIG-IP
    set log level  trace
    ${SNMPV3_PRIV_PROTO_F5}    set variable    ${SNMPV3_PRIV_PROTO}
    ${SNMPV3_PRIV_PROTO_F5}    set variable if    'aes' in '${SNMPV3_PRIV_PROTO}'    aes    ${SNMPV3_PRIV_PROTO}
    Create SNMPv3 User    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    name=${SNMPV3_USER}    username=${SNMPV3_USER}    authProtocol=${SNMPV3_AUTH_PROTO}   privacyProtocol=${SNMPV3_PRIV_PROTO_F5}    authPassword=${SNMPV3_AUTH_PASS}   privacyPassword=${SNMPV3_PRIV_PASS}    securityLevel=${SNMPV3_SECURITY_LEVEL}
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    ${SNMPV3_PRIV_PROTO_F5}    set variable    ${SNMPV3_PRIV_PROTO}
    ${SNMPV3_PRIV_PROTO_F5}    set variable if    'aes' in '${SNMPV3_PRIV_PROTO}'    aes    ${SNMPV3_PRIV_PROTO}
    Create SNMPv3 User    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    name=${SNMPV3_USER}    username=${SNMPV3_USER}    authProtocol=${SNMPV3_AUTH_PROTO}   privacyProtocol=${SNMPV3_PRIV_PROTO_F5}    authPassword=${SNMPV3_AUTH_PASS}   privacyPassword=${SNMPV3_PRIV_PASS}    securityLevel=${SNMPV3_SECURITY_LEVEL}

Test SNMPv2 Polling
    [Documentation]  Validates SNMP polling connectivity to the BIG-IP
    set log level  trace
    Get SNMPv2 IPv4 sysDescr    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    snmphost=${PRIMARY_MGMT_IP}    snmpcommunity=${SNMPV2_POLL_COMMUNITY}    snmpv2_port=${SNMPV2_PORT}    snmpv2_timeout=${SNMPV2_TIMEOUT}    snmpv2_retries=${SNMPV2_RETRIES}
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    Get SNMPv2 IPv4 sysDescr    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    snmphost=${SECONDARY_MGMT_IP}    snmpcommunity=${SNMPV2_POLL_COMMUNITY}    snmpv2_port=${SNMPV2_PORT}    snmpv2_timeout=${SNMPV2_TIMEOUT}    snmpv2_retries=${SNMPV2_RETRIES}

Test IPv4 SNMPv2 Traps
    [Documentation]  Generates a trap from the BIG-IP that is sent to the internal syslog server on the BIG-IP.
    set log level  trace
    Trigger an SNMPv2 Trap on the BIG-IP    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    snmpv2_trap_facility=${SNMPV2_TRAP_FACILITY}    snmpv2_trap_level=${SNMPV2_TRAP_LEVEL}    snmpv2_trap_message=${SNMPV2_TRAP_MESSAGE}
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    Trigger an SNMPv2 Trap on the BIG-IP    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}    snmpv2_trap_facility=${SNMPV2_TRAP_FACILITY}    snmpv2_trap_level=${SNMPV2_TRAP_LEVEL}    snmpv2_trap_message=${SNMPV2_TRAP_MESSAGE}

Test SNMPv3 Polling
    [Documentation]  Pools the "sysDescr" OID on the DUT using SNMPv3
    set log level  trace
    Get SNMPv3 IPv4 sysDescr    snmphost=${PRIMARY_MGMT_IP}    snmpv3_user=${SNMPV3_USER}    snmpv3_auth_pass=${SNMPV3_AUTH_PASS}    snmpv3_priv_pass=${SNMPV3_PRIV_PASS}    snmpv3_auth_proto=${SNMPV3_AUTH_PROTO}    snmpv3_priv_proto=${SNMPV3_PRIV_PROTO_SNMPLIB}    snmpv3_port=${SNMPV3_PORT}    snmpv3_timeout=${SNMPV3_TIMEOUT}    snmpv3_retries=${SNMPV3_RETRIES}
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    Get SNMPv3 IPv4 sysDescr    snmphost=${SECONDARY_MGMT_IP}    snmpv3_user=${SNMPV3_USER}    snmpv3_auth_pass=${SNMPV3_AUTH_PASS}    snmpv3_priv_pass=${SNMPV3_PRIV_PASS}    snmpv3_auth_proto=${SNMPV3_AUTH_PROTO}    snmpv3_priv_proto=${SNMPV3_PRIV_PROTO_SNMPLIB}    snmpv3_port=${SNMPV3_PORT}    snmpv3_timeout=${SNMPV3_TIMEOUT}    snmpv3_retries=${SNMPV3_RETRIES}

Test SNMPv3 Walking
    [Documentation]  Performs a generic SNMPv3 "walk" on the BIG-IP
    set log level  trace
    Walk SNMPv3 Host    snmphost=${PRIMARY_MGMT_IP}    snmpv3_user=${SNMPV3_USER}    snmpv3_auth_pass=${SNMPV3_AUTH_PASS}    snmpv3_priv_pass=${SNMPV3_PRIV_PASS}    snmpv3_auth_proto=${SNMPV3_AUTH_PROTO}    snmpv3_priv_proto=${SNMPV3_PRIV_PROTO_SNMPLIB}    snmpv3_port=${SNMPV3_PORT}    snmpv3_timeout=${SNMPV3_TIMEOUT}    snmpv3_retries=${SNMPV3_RETRIES}
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    Walk SNMPv3 Host    snmphost=${SECONDARY_MGMT_IP}    snmpv3_user=${SNMPV3_USER}    snmpv3_auth_pass=${SNMPV3_AUTH_PASS}    snmpv3_priv_pass=${SNMPV3_PRIV_PASS}    snmpv3_auth_proto=${SNMPV3_AUTH_PROTO}    snmpv3_priv_proto=${SNMPV3_PRIV_PROTO_SNMPLIB}    snmpv3_port=${SNMPV3_PORT}    snmpv3_timeout=${SNMPV3_TIMEOUT}    snmpv3_retries=${SNMPV3_RETRIES}
