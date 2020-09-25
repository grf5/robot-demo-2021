*** Settings ***
Documentation    This tests the configuration and operation of LTM UDP load balancing on the BIG-IP
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
${UDP_ROUND_ROBIN_VIP_NAME}             %{UDP_ROUND_ROBIN_VIP_NAME}    
${UDP_ROUND_ROBIN_VIP_PARTITION}        %{UDP_ROUND_ROBIN_VIP_PARTITION}    
${UDP_ROUND_ROBIN_VIP_ADDRESS}          %{UDP_ROUND_ROBIN_VIP_ADDRESS}    
${UDP_ROUND_ROBIN_VIP_MASK}             %{UDP_ROUND_ROBIN_VIP_MASK}    
${UDP_ROUND_ROBIN_VIP_PORT}             %{UDP_ROUND_ROBIN_VIP_PORT}    
${UDP_ROUND_ROBIN_VIP_PROTOCOL}         %{UDP_ROUND_ROBIN_VIP_PROTOCOL}    
${UDP_ROUND_ROBIN_VIP_SNAT_TYPE}        %{UDP_ROUND_ROBIN_VIP_SNAT_TYPE}    
${UDP_ROUND_ROBIN_POOL_NAME}            %{UDP_ROUND_ROBIN_POOL_NAME}    
${UDP_ROUND_ROBIN_POOL_MEMBERS}         %{UDP_ROUND_ROBIN_POOL_MEMBERS}    
${UDP_ROUND_ROBIN_POOL_MONITOR}         %{UDP_ROUND_ROBIN_POOL_MONITOR}    

*** Test Cases ***
Perform BIG-IP Quick Check
    [Documentation]    Verifies that key BIG-IP services are in a ready state
    set log level    trace
    Verify All BIG-IP Ready States    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}
    Check for BIG-IP Services Waiting to Restart    bigip_host=${PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}
    Return from Keyword If    '${SECONDARY_MGMT_IP}' == 'false'
    Verify All BIG-IP Ready States    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}
    Check for BIG-IP Services Waiting to Restart    bigip_host=${SECONDARY_MGMT_IP}    bigip_username=${SECONDARY_HTTP_USERNAME}    bigip_password=${SECONDARY_HTTP_PASSWORD}

