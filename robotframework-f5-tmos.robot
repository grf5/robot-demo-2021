*** Settings ***
Documentation    Resource file for F5's iControl REST API
Library    BuiltIn
Library    Collections
Library    RequestsLibrary
Library    String
Library    SnmpLibrary
Library    SSHLibrary  30 seconds

*** Keywords ***

######################################
## iControl HTTP Operations Keywords
######################################

Generate Token    
    [Documentation]    Generates an API Auth token using username/password (See pages 20-21 of https://cdn.f5.com/websites/devcentral.f5.com/downloads/icontrol-rest-api-user-guide-13-1-0-a.pdf.zip)
    [Arguments]    ${bigip_host}   ${bigip_username}    ${bigip_password}
    ${api_uri}    set variable    /mgmt/shared/authn/login
    ${api_payload}    Create Dictionary    username=${bigip_username}    password=${bigip_password}    loginProviderName=tmos
    ${api_response}    BIG-IP iControl BasicAuth POST    bigip_host=${bigip_host}    bigip_username=${bigip_username}
    ...    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    ${api_response_json}    To Json    ${api_response.content}
    ${api_token}    Get From Dictionary    ${api_response_json}    token
    ${api_token}    Get From Dictionary    ${api_token}    token
    [Teardown]    Delete All Sessions
    [Return]    ${api_token}

Extend Token    
    [Documentation]    Extends the timeout on an existing auth token (See pages 20-21 of https://cdn.f5.com/websites/devcentral.f5.com/downloads/icontrol-rest-api-user-guide-13-1-0-a.pdf.zip)
    [Arguments]    ${bigip_host}   ${api_token}   ${timeout}=${36000}
    ${api_token}    Generate Token    ${bigip_host}
    ${api_payload}    Create Dictionary    timeout=${timeout}
    ${api_uri}    set variable    /mgmt/shared/authz/tokens/${api_token}
    ${api_response}    BIG-IP iControl TokenAuth PATCH    bigip_host=${bigip_host}    api_token=${api_token}    api_uri=${api_uri}
    ...    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    ${api_token_status}    to json    ${api_response.content}
    dictionary should contain item    ${api_token_status}    timeout    36000
    [Teardown]    Delete All Sessions
    [Return]    ${api_token_status}

Delete Token    
    [Documentation]    Deletes an auth token (See pages 20-21 of https://cdn.f5.com/websites/devcentral.f5.com/downloads/icontrol-rest-api-user-guide-13-1-0-a.pdf.zip)
    [Arguments]    ${bigip_host}    ${api_token}
    ${api_uri}    set variable    /mgmt/shared/authz/tokens/${api_token}
    log    DELETE TOKEN URI: https://${bigip_host}${api_uri}
    ${api_response}    BIG-IP iControl TokenAuth DELETE    bigip_host=${bigip_host}    api_token=${api_token}    api_uri=${api_uri}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Teardown]    Delete All Sessions

BIG-IP iControl TokenAuth GET    
    [Documentation]    Performs an iControl REST API GET call using a pre-generated token (See pages 20-21 of https://cdn.f5.com/websites/devcentral.f5.com/downloads/icontrol-rest-api-user-guide-13-1-0-a.pdf.zip)
    [Arguments]    ${bigip_host}    ${api_token}    ${api_uri}
    log    iControl GET Variables: HOST: ${bigip_host} URI: ${api_uri} AUTH-TOKEN: ${api_token}
    RequestsLibrary.Create Session    bigip-icontrol-get-tokenauth    https://${bigip_host}
    &{api_headers}    Create Dictionary    Content-type=application/json    X-F5-Auth-Token=${api_token}
    ${api_response}    get request    bigip-icontrol-get-tokenauth   ${api_uri}    headers=${api_headers}
    log    HTTP Response Code: ${api_response}
    ${api_response.json}    to json    ${api_response.content}
    log    ${api_response.json}    formatter=repr
    [Teardown]    Delete All Sessions
    [Return]    ${api_response}

BIG-IP iControl TokenAuth POST    
    [Documentation]    Performs an iControl REST API POST call using a pre-generated token (See pages 20-21 of https://cdn.f5.com/websites/devcentral.f5.com/downloads/icontrol-rest-api-user-guide-13-1-0-a.pdf.zip)
    [Arguments]    ${bigip_host}    ${api_token}    ${api_uri}    ${api_payload}
    log    iControl POST Variables: HOST: ${bigip_host} URI: ${api_uri} PAYLOAD: ${api_payload} AUTH-TOKEN: ${api_token}
    RequestsLibrary.Create Session    bigip-icontrol-post-tokenauth    https://${bigip_host}
    &{api_headers}    Create Dictionary    Content-type=application/json    X-F5-Auth-Token=${api_token}
    ${api_response}    post request    bigip-icontrol-post-tokenauth   ${api_uri}    headers=${api_headers}    json=${api_payload}
    log    HTTP Response Code: ${api_response}
    ${api_response.json}    to json    ${api_response.content}
    log    ${api_response.json}    formatter=repr
    [Teardown]    Delete All Sessions
    [Return]    ${api_response}

BIG-IP iControl TokenAuth PUT    
    [Documentation]    Performs an iControl REST API PUT call using a pre-generated token (See pages 20-21 of https://cdn.f5.com/websites/devcentral.f5.com/downloads/icontrol-rest-api-user-guide-13-1-0-a.pdf.zip)
    [Arguments]    ${bigip_host}    ${api_token}    ${api_uri}    ${api_payload}
    log    iControl PUT Variables: HOST: ${bigip_host} URI: ${api_uri} PAYLOAD: ${api_payload} AUTH-TOKEN: ${api_token}
    RequestsLibrary.Create Session    bigip-icontrol-put-tokenauth    https://${bigip_host}
    &{api_headers}    Create Dictionary    Content-type=application/json    X-F5-Auth-Token=${api_token}
    ${api_response}    put request    bigip-icontrol-put-tokenauth   ${api_uri}    headers=${api_headers}    json=${api_payload}
    log    HTTP Response Code: ${api_response}
    ${api_response.json}    to json    ${api_response.content}
    log    ${api_response.json}    formatter=repr
    [Teardown]    Delete All Sessions
    [Return]    ${api_response}

BIG-IP iControl TokenAuth PATCH    
    [Documentation]    Performs an iControl REST API PATCH call using a pre-generated token (See pages 20-21 of https://cdn.f5.com/websites/devcentral.f5.com/downloads/icontrol-rest-api-user-guide-13-1-0-a.pdf.zip)
    [Arguments]    ${bigip_host}    ${api_token}    ${api_uri}    ${api_payload}
    log    iControl PATCH Variables: HOST: ${bigip_host} URI: ${api_uri} PAYLOAD: ${api_payload} AUTH-TOKEN: ${api_token}
    RequestsLibrary.Create Session    bigip-icontrol-patch-tokenauth    https://${bigip_host}
    &{api_headers}    Create Dictionary    Content-type=application/json    X-F5-Auth-Token=${api_token}
    ${api_response}    patch request    bigip-icontrol-patch-tokenauth   ${api_uri}    headers=${api_headers}    json=${api_payload}
    log    HTTP Response Code: ${api_response}
    ${api_response.json}    to json    ${api_response.content}
    log    ${api_response.json}    formatter=repr
    [Teardown]    Delete All Sessions
    [Return]    ${api_response}

BIG-IP iControl TokenAuth DELETE    
    [Documentation]    Performs an iControl REST API DELETE call using a pre-generated token (See pages 20-21 of https://cdn.f5.com/websites/devcentral.f5.com/downloads/icontrol-rest-api-user-guide-13-1-0-a.pdf.zip)
    [Arguments]    ${bigip_host}    ${api_token}    ${api_uri}
    log    iControl DELETE Variables: HOST: ${bigip_host} URI: ${api_uri} AUTH-TOKEN: ${api_token}
    RequestsLibrary.Create Session    bigip-icontrol-delete-tokenauth    https://${bigip_host}
    &{api_headers}    Create Dictionary    Content-type=application/json    X-F5-Auth-Token=${api_token}
    ${api_response}    delete request    bigip-icontrol-delete-tokenauth   ${api_uri}    headers=${api_headers}
    log    HTTP Response Code: ${api_response}
    log    API Response (should be null for successful delete operations): ${api_response.content}
    [Teardown]    Delete All Sessions
    [Return]    ${api_response}

BIG-IP iControl BasicAuth GET    
    [Documentation]    Performs an iControl REST API GET call using basic auth (See pages 25-38 of https://cdn.f5.com/websites/devcentral.f5.com/downloads/icontrol-rest-api-user-guide-13-1-0-a.pdf.zip)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${api_uri}
    ${api_auth}    Create List    ${bigip_username}   ${bigip_password}
    log    iControl GET Variables: HOST: ${bigip_host} URI: ${api_uri}
    RequestsLibrary.Create Session    bigip-icontrol-get-basicauth    https://${bigip_host}    auth=${api_auth}
    &{api_headers}    Create Dictionary    Content-type=application/json
    ${api_response}    get request    bigip-icontrol-get-basicauth   ${api_uri}    headers=${api_headers}
    log    HTTP Response Code: ${api_response}
    ${api_response.json}    to json    ${api_response.content}
    log    ${api_response.json}    formatter=repr
    [Teardown]    Delete All Sessions
    [Return]    ${api_response}

BIG-IP iControl BasicAuth POST    
    [Documentation]    Performs an iControl REST API POST call using basic auth (See pages 39-44 of https://cdn.f5.com/websites/devcentral.f5.com/downloads/icontrol-rest-api-user-guide-13-1-0-a.pdf.zip)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${api_uri}    ${api_payload}
    ${api_auth}    Create List    ${bigip_username}   ${bigip_password}
    log    iControl POST Variables: HOST: ${bigip_host} URI: ${api_uri} PAYLOAD: ${api_payload}
    RequestsLibrary.Create Session    bigip-icontrol-post-basicauth    https://${bigip_host}		auth=${api_auth}
    &{api_headers}    Create Dictionary    Content-type=application/json
    ${api_response}    post request    bigip-icontrol-post-basicauth   ${api_uri}    headers=${api_headers}    json=${api_payload}
    log    HTTP Response Code: ${api_response}
    ${api_response.json}    to json    ${api_response.content}
    log    ${api_response.json}    formatter=repr
    [Teardown]    Delete All Sessions
    [Return]    ${api_response}

BIG-IP iControl BasicAuth POST without Verification
    [Documentation]    Performs an iControl REST API POST call using basic auth and doesn't check the response (See pages 39-44 of https://cdn.f5.com/websites/devcentral.f5.com/downloads/icontrol-rest-api-user-guide-13-1-0-a.pdf.zip)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${api_uri}    ${api_payload}
    ${api_auth}    Create List    ${bigip_username}   ${bigip_password}
    log    iControl POST Variables: HOST: ${bigip_host} URI: ${api_uri} PAYLOAD: ${api_payload}
    RequestsLibrary.Create Session    bigip-icontrol-post-basicauth    https://${bigip_host}		auth=${api_auth}
    &{api_headers}    Create Dictionary    Content-type=application/json
    ${api_response}    post request    bigip-icontrol-post-basicauth   ${api_uri}    headers=${api_headers}    json=${api_payload}
    [Teardown]    Delete All Sessions
    [Return]

BIG-IP iControl BasicAuth PUT    
    [Documentation]    Performs an iControl REST API PUT call using basic auth (See pages 39-44 of https://cdn.f5.com/websites/devcentral.f5.com/downloads/icontrol-rest-api-user-guide-13-1-0-a.pdf.zip)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${api_uri}    ${api_payload}
    ${api_auth}    Create List    ${bigip_username}   ${bigip_password}
    log    iControl PUT Variables: HOST: ${bigip_host} URI: ${api_uri} PAYLOAD: ${api_payload}
    RequestsLibrary.Create Session    bigip-icontrol-put-basicauth    https://${bigip_host}		auth=${api_auth}
    &{api_headers}    Create Dictionary    Content-type=application/json
    ${api_response}    put request    bigip-icontrol-put-basicauth   ${api_uri}    headers=${api_headers}    json=${api_payload}
    log    HTTP Response Code: ${api_response}
    ${api_response.json}    to json    ${api_response.content}
    log    ${api_response.json}    formatter=repr
    [Teardown]    Delete All Sessions
    [Return]    ${api_response}

BIG-IP iControl BasicAuth PATCH    
    [Documentation]    Performs an iControl REST API PATCH call using basic auth (See pages 39-44 of https://cdn.f5.com/websites/devcentral.f5.com/downloads/icontrol-rest-api-user-guide-13-1-0-a.pdf.zip)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${api_uri}    ${api_payload}
    ${api_auth}    Create List    ${bigip_username}   ${bigip_password}
    log    iControl PATCH Variables: HOST: ${bigip_host} URI: ${api_uri} PAYLOAD: ${api_payload}
    RequestsLibrary.Create Session    bigip-icontrol-patch-basicauth    https://${bigip_host}		auth=${api_auth}
    &{api_headers}    Create Dictionary    Content-type=application/json
    ${api_response}    patch request    bigip-icontrol-patch-basicauth   ${api_uri}    headers=${api_headers}    json=${api_payload}
    log    HTTP Response Code: ${api_response}
    ${api_response.json}    to json    ${api_response.content}
    log    ${api_response.json}    formatter=repr
    [Teardown]    Delete All Sessions
    [Return]    ${api_response}

BIG-IP iControl BasicAuth DELETE    
    [Documentation]    Performs an iControl REST API DELETE call using basic auth (See pages 13 of https://cdn.f5.com/websites/devcentral.f5.com/downloads/icontrol-rest-api-user-guide-13-1-0-a.pdf.zip)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${api_uri}
    ${api_auth}    Create List    ${bigip_username}   ${bigip_password}
    log    iControl DELETE Variables: HOST: ${bigip_host} URI: ${api_uri}
    RequestsLibrary.Create Session    bigip-icontrol-delete-basicauth    https://${bigip_host}		auth=${api_auth}
    &{api_headers}    Create Dictionary    Content-type=application/json
    ${api_response}    delete request    bigip-icontrol-delete-basicauth   ${api_uri}    headers=${api_headers}
    log    HTTP Response Code: ${api_response}
    log    API Response (should be null for successful delete operations): ${api_response.content}
    [Teardown]    Delete All Sessions
    [Return]    ${api_response}

BIG-IP iControl NoAuth GET    
    [Documentation]    Performs an iControl REST API GET call without authentication (See pages 25-38 of https://cdn.f5.com/websites/devcentral.f5.com/downloads/icontrol-rest-api-user-guide-13-1-0-a.pdf.zip)
    [Arguments]    ${bigip_host}    ${api_uri}    ${api_payload}
    log    iControl GET Variables: HOST: ${bigip_host} URI: ${api_uri}
    return from keyword if    "${bigip_host}" == "${EMPTY}"
    return from keyword if    "${api_uri}" == "${EMPTY}"
    RequestsLibrary.Create Session    bigip-icontrol-get-noauth    https://${bigip_host}
    &{api_headers}    Create Dictionary    Content-type=application/json
    ${api_response}    get request    bigip-icontrol-get-noauth   ${api_uri}    headers=${api_headers}
    log    HTTP Response Code: ${api_response}
    ${api_response.json}    to json    ${api_response.content}
    log    ${api_response.json}    formatter=repr
    [Teardown]    Delete All Sessions
    [Return]    ${api_response}

BIG-IP iControl NoAuth POST    
    [Documentation]    Performs an iControl REST API POST call without authentication (See pages 39-44 of https://cdn.f5.com/websites/devcentral.f5.com/downloads/icontrol-rest-api-user-guide-13-1-0-a.pdf.zip)
    [Arguments]    ${bigip_host}    ${api_uri}    ${api_payload}
    log    iControl POST Variables: HOST: ${bigip_host} URI: ${api_uri} PAYLOAD: ${api_payload}
    return from keyword if    "${bigip_host}" == "${EMPTY}"
    return from keyword if    "${api_uri}" == "${EMPTY}"
    ${payload_length}    get length  ${api_payload}
    return from keyword if    ${payload_length} == 0
    RequestsLibrary.Create Session    bigip-icontrol-post-noauth    https://${bigip_host}
    &{api_headers}    Create Dictionary    Content-type=application/json
    ${api_response}    post request    bigip-icontrol-post-noauth   ${api_uri}    headers=${api_headers}    json=${api_payload}
    log    HTTP Response Code: ${api_response}
    ${api_response.json}    to json    ${api_response.content}
    log    ${api_response.json}    formatter=repr
    [Teardown]    Delete All Sessions
    [Return]    ${api_response}

BIG-IP iControl NoAuth PUT    
    [Documentation]    Performs an iControl REST API PUT call without authentication (See pages 39-44 of https://cdn.f5.com/websites/devcentral.f5.com/downloads/icontrol-rest-api-user-guide-13-1-0-a.pdf.zip)
    [Arguments]    ${bigip_host}    ${api_uri}    ${api_payload}
    log    iControl PUT Variables: HOST: ${bigip_host} URI: ${api_uri} PAYLOAD: ${api_payload}
    return from keyword if    "${bigip_host}" == "${EMPTY}"
    return from keyword if    "${api_uri}" == "${EMPTY}"
    ${payload_length}    get length  ${api_payload}
    return from keyword if    ${payload_length} == 0
    RequestsLibrary.Create Session    bigip-icontrol-put-noauth    https://${bigip_host}
    &{api_headers}    Create Dictionary    Content-type=application/json
    ${api_response}    put request    bigip-icontrol-put-noauth   ${api_uri}    headers=${api_headers}    json=${api_payload}
    log    HTTP Response Code: ${api_response}
    ${api_response.json}    to json    ${api_response.content}
    log    ${api_response.json}    formatter=repr
    [Teardown]    Delete All Sessions
    [Return]    ${api_response}

BIG-IP iControl NoAuth PATCH    
    [Documentation]    Performs an iControl REST API PATCH call without authentication (See pages 39-44 of https://cdn.f5.com/websites/devcentral.f5.com/downloads/icontrol-rest-api-user-guide-13-1-0-a.pdf.zip)
    [Arguments]    ${bigip_host}    ${api_uri}    ${api_payload}
    log    iControl PATCH Variables: HOST: ${bigip_host} URI: ${api_uri} PAYLOAD: ${api_payload}
    RequestsLibrary.Create Session    bigip-icontrol-patch-noauth    https://${bigip_host}
    &{api_headers}    Create Dictionary    Content-type=application/json
    ${api_response}    patch request    bigip-icontrol-patch-noauth   ${api_uri}    headers=${api_headers}    json=${api_payload}
    log    HTTP Response Code: ${api_response}
    ${api_response.json}    to json    ${api_response.content}
    log    ${api_response.json}    formatter=repr
    [Teardown]    Delete All Sessions
    [Return]    ${api_response}

BIG-IP iControl NoAuth DELETE    
    [Documentation]    Performs an iControl REST API DELETE call without authentication (See pages 13 of https://cdn.f5.com/websites/devcentral.f5.com/downloads/icontrol-rest-api-user-guide-13-1-0-a.pdf.zip)
    [Arguments]    ${bigip_host}   ${api_uri}
    log    iControl DELETE Variables: HOST: ${bigip_host} URI: ${api_uri}
    RequestsLibrary.Create Session    bigip-icontrol-delete-noauth    https://${bigip_host}
    ${api_headers}    Create Dictionary    Content-type=application/json
    ${api_response}    delete request    bigip-icontrol-delete-noauth   ${api_uri}    headers=${api_headers}
    log    HTTP Response Code: ${api_response}
    log    API Response (should be null for successful delete operations): ${api_response.content}
    [Teardown]    Delete All Sessions
    [Return]    ${api_response}

##############
## sys ready  
##############

Verify All BIG-IP Ready States
    [Documentation]    Verifies that the BIG-IP is ready in configuration, license and provisioning state - used by bigip_wait in Ansible (https://clouddocs.f5.com/products/orchestration/ansible/devel/modules/bigip_wait_module.html)    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}
    ${api_uri}    set variable    /mgmt/tm/sys/ready    
    ${api_response}    BIG-IP iControl BasicAuth GET    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}
    Should Be Equal As Strings    ${api_response.status_code}    ${HTTP_RESPONSE_OK}
    ${api_response_dict}    To Json    ${api_response.content}
    ${ready_states}    get from dictionary    ${api_response_dict}    entries
    ${ready_states}    get from dictionary    ${ready_states}    https://localhost/mgmt/tm/sys/ready/0
    ${ready_states}    get from dictionary    ${ready_states}    nestedStats
    ${ready_states}    get from dictionary    ${ready_states}    entries
    ${config_ready_state}    get from dictionary    ${ready_states}    configReady
    ${config_ready_state}    get from dictionary    ${config_ready_state}    description
    ${license_ready_state}    get from dictionary    ${ready_states}    licenseReady
    ${license_ready_state}    get from dictionary    ${license_ready_state}    description
    ${provision_ready_state}    get from dictionary    ${ready_states}    provisionReady
    ${provision_ready_state}    get from dictionary    ${provision_ready_state}    description
    ${ready_state_value}    set variable    yes
    should be equal as strings    ${ready_state_value}    ${config_ready_state}
    should be equal as strings    ${ready_state_value}    ${license_ready_state}
    should be equal as strings    ${ready_state_value}    ${provision_ready_state}
    [Return]    ${ready_states}
    
Verify BIG-IP Configuration Ready State
    [Documentation]    Verifies that the BIG-IP is in a "configuration loaded" state - used by bigip_wait in Ansible (https://clouddocs.f5.com/products/orchestration/ansible/devel/modules/bigip_wait_module.html)    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}
    ${api_uri}    set variable    /mgmt/tm/sys/ready    
    ${api_response}    BIG-IP iControl BasicAuth GET    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}
    Should Be Equal As Strings    ${api_response.status_code}    ${HTTP_RESPONSE_OK}
    ${api_response_dict}    To Json    ${api_response.content}
    ${config_ready_state}    get from dictionary    ${api_response_dict}    entries
    ${config_ready_state}    get from dictionary    ${config_ready_state}    https://localhost/mgmt/tm/sys/ready/0
    ${config_ready_state}    get from dictionary    ${config_ready_state}    nestedStats
    ${config_ready_state}    get from dictionary    ${config_ready_state}    entries
    ${config_ready_state}    get from dictionary    ${config_ready_state}    configReady
    ${config_ready_state}    get from dictionary    ${config_ready_state}    description
    ${ready_state_value}    set variable    yes
    should be equal as strings    ${ready_state_value}    ${config_ready_state}
    [Return]    ${config_ready_state}

Verify BIG-IP License Ready State
    [Documentation]    Verifies that the BIG-IP is in a licensed state - used by bigip_wait in Ansible (https://clouddocs.f5.com/products/orchestration/ansible/devel/modules/bigip_wait_module.html)    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}
    ${api_uri}    set variable    /mgmt/tm/sys/ready    
    ${api_response}    BIG-IP iControl BasicAuth GET    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}
    Should Be Equal As Strings    ${api_response.status_code}    ${HTTP_RESPONSE_OK}
    ${api_response_dict}    To Json    ${api_response.content}
    ${license_ready_state}    get from dictionary    ${api_response_dict}    entries
    ${license_ready_state}    get from dictionary    ${license_ready_state}    https://localhost/mgmt/tm/sys/ready/0
    ${license_ready_state}    get from dictionary    ${license_ready_state}    nestedStats
    ${license_ready_state}    get from dictionary    ${license_ready_state}    entries
    ${license_ready_state}    get from dictionary    ${license_ready_state}    licenseReady
    ${license_ready_state}    get from dictionary    ${license_ready_state}    description
    ${ready_state_value}    set variable    yes
    should be equal as strings    ${ready_state_value}    ${license_ready_state}
    [Return]    ${license_ready_state}

Verify BIG-IP Provision Ready State
    [Documentation]    Verifies that the BIG-IP is in a state where any provisioning tasks are complete - used by bigip_wait in Ansible (https://clouddocs.f5.com/products/orchestration/ansible/devel/modules/bigip_wait_module.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}
    ${api_uri}    set variable    /mgmt/tm/sys/ready    
    ${api_response}    BIG-IP iControl BasicAuth GET    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}
    Should Be Equal As Strings    ${api_response.status_code}    ${HTTP_RESPONSE_OK}
    ${api_response_dict}    To Json    ${api_response.content}
    ${provision_ready_state}    get from dictionary    ${api_response_dict}    entries
    ${provision_ready_state}    get from dictionary    ${provision_ready_state}    https://localhost/mgmt/tm/sys/ready/0
    ${provision_ready_state}    get from dictionary    ${provision_ready_state}    nestedStats
    ${provision_ready_state}    get from dictionary    ${provision_ready_state}    entries
    ${provision_ready_state}    get from dictionary    ${provision_ready_state}    provisionReady
    ${provision_ready_state}    get from dictionary    ${provision_ready_state}    description
    ${ready_state_value}    set variable    yes
    should be equal as strings    ${ready_state_value}    ${provision_ready_state}
    [Return]    ${provision_ready_state}
