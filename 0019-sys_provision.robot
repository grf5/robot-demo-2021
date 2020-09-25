*** Settings ***
Documentation    This test provisions software modules and verifies provisioning on the BIG-IP
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
${MODULE_PROVISIONING}                  %{MODULE_PROVISIONING}

Provision Software Modules on the BIG-IP
    [Documentation]    Sets the provisioning level on software modules in the BIG-IP
    set log level    trace
    FOR    ${current_module}    IN    ${MODULE_PROVISIONING}
        ${module}    set variable    ${current_module}
        Provision Module on the BIG-IP    bigip_host=${BIGIP_PRIMARY_MGMT_IP}    bigip_username=${PRIMARY_HTTP_USERNAME}    bigip_password=${PRIMARY_HTTP_PASSWORD}    module=${MODULE}    provisioning_level=${PROVISION_LEVEL}
    END
    Return from Keyword If    '${BIGIP_SECONDARY_MGMT_IP}' == 'false'
    FOR    ${current_module}    IN    ${MODULE_PROVISIONING}
        Provision Module on the BIG-IP    bigip_host=${BIGIP_SECONDARY_MGMT_IP}    bigip_username=${HTTP_USERNAME}    bigip_password=${HTTP_PASSWORD}    provisioning_level=${PROVISION_AFM_LEVEL}
    END

Perform BIG-IP Post-Provision Check
    [Documentation]    Verifies that key BIG-IP services are in a ready state
    set log level    trace
    Wait until Keyword Succeeds    50x    10 seconds    Verify All BIG-IP Ready States    bigip_host=${BIGIP_PRIMARY_MGMT_IP}    bigip_username=${HTTP_USERNAME}    bigip_password=${HTTP_PASSWORD}
    wait until keyword succeeds    50x    10 seconds    Check for BIG-IP Services Waiting to Restart    bigip_host=${BIGIP_PRIMARY_MGMT_IP}    bigip_username=${HTTP_USERNAME}    bigip_password=${HTTP_PASSWORD}
    Return from Keyword If    '${BIGIP_SECONDARY_MGMT_IP}' == 'false'
    Wait until Keyword Succeeds    50x    10 seconds    Verify All BIG-IP Ready States    bigip_host=${BIGIP_SECONDARY_MGMT_IP}    bigip_username=${HTTP_USERNAME}    bigip_password=${HTTP_PASSWORD}
    wait until keyword succeeds    50x    10 seconds    Check for BIG-IP Services Waiting to Restart    bigip_host=${BIGIP_SECONDARY_MGMT_IP}    bigip_username=${HTTP_USERNAME}    bigip_password=${HTTP_PASSWORD}

Verify Module Provisioning
    [Documentation]    Verifies that the software modules are provisioned as expected on the BIG-IP
    set log level    trace
    FOR    ${current_module}    IN    ${MODULE_PROVISIONING}
        Verify AFM is Provisioned    bigip_host=${BIGIP_PRIMARY_MGMT_IP}    bigip_username=${HTTP_USERNAME}    bigip_password=${HTTP_PASSWORD}
    END
    Return from Keyword If    '${BIGIP_SECONDARY_MGMT_IP}' == 'false'
    FOR    ${current_module}    IN    ${MODULE_PROVISIONING}
        Verify AFM is Provisioned    bigip_host=${BIGIP_SECONDARY_MGMT_IP}    bigip_username=${HTTP_USERNAME}    bigip_password=${HTTP_PASSWORD}
    END
