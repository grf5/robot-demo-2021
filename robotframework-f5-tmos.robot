*** Settings ***
Documentation    Resource file for F5's iControl REST API
Library    BuiltIn
Library    Collections
Library    RequestsLibrary
Library    String
Library    SnmpLibrary
Library    SSHLibrary  30 seconds

*** Keywords ***

#####################
# Third-party Tools
#####################

Retrieve BIG-IP Login Page
    [Documentation]    Tests connectivity and availability of the BIG-IP web UI login page
    [Arguments]    ${bigip_host}
    RequestsLibrary.Create Session    webui    https://${bigip_host}
    ${api_response}    get request    webui    /tmui/login.jsp
    Should Be Equal As Strings    ${api_response.status_code}    200
    Log    Web UI HTTP RESPONSE: ${api_response.text}
    should contain    ${api_response.text}    <meta name="description" content="BIG-IP&reg; Configuration Utility" />
    [Teardown]    Delete All Sessions
    [Return]    ${api_response}

Query DNS Record
    [Documentation]    Executes the dig command on a BIG-IP
    [Arguments]    ${query}    ${ns_address}=4.2.2.1    ${query_type}=A
    [Return]

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

##################
## net interface
##################

Reset Interface Stats
    [Documentation]    Resets interface counters on a particular interface (https://support.f5.com/csp/article/K3628)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${name}
    ${api_payload}    Create Dictionary    command=reset-stats    name=${name}
    ${api_uri}    set variable    /mgmt/tm/net/interface
    ${api_response}    BIG-IP iControl BasicAuth POST    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Reset All Interface Stats
    [Documentation]    Resets interface counters on all interfaces (https://support.f5.com/csp/article/K3628)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}
    ${api_payload}    Create Dictionary    command=reset-stats
    ${api_uri}    set variable    /mgmt/tm/net/interface
    ${api_response}    BIG-IP iControl BasicAuth POST    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Enable a BIG-IP physical interface
    [Documentation]    Enables a particular BIG-IP physical interface (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/tmos-routing-administration-13-1-0/3.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${interface_name}
    ${api_payload}    create dictionary    kind=tm:net:interface:interfacestate    name=${interface_name}    enabled=${True}
    ${api_uri}    set variable    /mgmt/tm/net/interface/${interface_name}
    ${api_response}    BIG-IP iControl BasicAuth PATCH    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    ${api_response_dict}    to json    ${api_response.content}
    dictionary should contain item  ${api_response_dict}    enabled    True
    [Return]    ${api_response}

Verify enabled state of BIG-IP physical interface
    [Documentation]    Verifies that a BIG-IP interface is enabled (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/tmos-routing-administration-13-1-0/3.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${interface_name}
    ${api_uri}    set variable    /mgmt/tm/net/interface/${interface_name}
    ${api_response}    BIG-IP iControl BasicAuth GET    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}
    should be equal as strings    ${api_response.status_code}    200
    ${api_response_dict}    to json    ${api_response.content}
    dictionary should contain item  ${api_response_dict}    enabled    True
    [Return]    ${api_response}

Verify up state of BIG-IP physical interface
    [Documentation]    Verifies that a physical interface is UP (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/tmos-routing-administration-13-1-0/3.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${interface_name}
    ${api_uri}    set variable    /mgmt/tm/net/interface/stats
    ${api_response}    BIG-IP iControl BasicAuth GET    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}
    Should Be Equal As Strings    ${api_response.status_code}    200
    ${api_response_dict}    to json    ${api_response.content}
    ${interface_stats_entries}    get from dictionary   ${api_response_dict}    entries
    ${interface_stats_dict}    get from dictionary   ${interface_stats_entries}   https://localhost/mgmt/tm/net/interface/${interface_name}/stats
    ${interface_stats_dict}    get from dictionary   ${interface_stats_dict}    nestedStats
    ${interface_stats_dict}    get from dictionary   ${interface_stats_dict}    entries
    ${interface_status_dict}    get from dictionary   ${interface_stats_dict}    status
    ${interface_status}    get from dictionary   ${interface_status_dict}    description
    ${interface_tmname}    get from dictionary   ${interface_stats_dict}    tmName
    ${interface_tmname}    get from dictionary   ${interface_tmname}    description
    should be equal as strings    ${interface_status}   enabled
    [Return]    ${api_response}

Disable a BIG-IP physical interface
    [Documentation]    Disables a BIG-IP physical interface (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/tmos-routing-administration-13-1-0/3.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${interface_name}
    ${api_payload}    create dictionary    kind=tm:net:interface:interfacestate    name=${interface_name}    disabled=${True}
    ${api_uri}    set variable    /mgmt/tm/net/interface/${interface_name}
    ${api_response}    BIG-IP iControl BasicAuth PATCH    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    ${api_response_dict}    to json    ${api_response.content}
    dictionary should contain item    ${api_response_dict}    disabled    True
    [Return]    ${api_response}

Verify disabled state of BIG-IP physical interface
    [Documentation]    Verifies that a BIG-IP interface is disabled (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/tmos-routing-administration-13-1-0/3.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${interface_name}
    ${api_uri}    set variable    /mgmt/tm/net/interface/${interface_name}
    ${api_response}    BIG-IP iControl BasicAuth GET    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}
    should be equal as strings    ${api_response.status_code}    200
    ${api_response_dict}    to json    ${api_response.content}
    dictionary should contain item  ${api_response_dict}    disabled    True
    [Return]    ${api_response}

Verify down state of BIG-IP physical interface
    [Documentation]    Verifies that a BIG-IP interface is DOWN (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/tmos-routing-administration-13-1-0/3.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${interface_name}
    ${api_uri}    set variable    /mgmt/tm/net/interface/stats
    ${api_response}    BIG-IP iControl BasicAuth GET    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}
    Should Be Equal As Strings    ${api_response.status_code}    200
    ${api_response_dict}    to json    ${api_response.content}
    ${interface_stats_entries}    get from dictionary  ${api_response_dict}    entries
    ${interface_stats_dict}    get from dictionary  ${interface_stats_entries}    https://localhost/mgmt/tm/net/interface/${interface_name}/stats
    ${interface_stats_dict}    get from dictionary  ${interface_stats_dict}    nestedStats
    ${interface_stats_dict}    get from dictionary  ${interface_stats_dict}    entries
    ${interface_status_dict}    get from dictionary  ${interface_stats_dict}    status
    ${interface_status}    get from dictionary  ${interface_status_dict}    description
    ${interface_tmname}    get from dictionary  ${interface_stats_dict}    tmName
    ${interface_tmname}    get from dictionary  ${interface_tmname}    description
    should be equal as strings    ${interface_status}  disabled
    [Return]    ${api_response}

Configure BIG-IP Interface Description
    [Documentation]    Configures the description on a BIG-IP interface (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/tmos-routing-administration-13-1-0/3.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${interface_name}    ${interface_description}
    ${api_uri}    set variable    /mgmt/tm/net/interface/${interface_name}
    ${api_payload}    create dictionary    description=${interface_description}
    ${api_response}    BIG-IP iControl BasicAuth PATCH    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Set BIG-IP Interface LLDP to Transmit Only
    [Documentation]    Changes the LLDP mode on a single BIG-IP interface (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/tmos-implementations-13-0-0/5.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${interface_name}
    ${api_uri}    set variable    /mgmt/tm/net/interface/${interface_name}
    ${api_payload}    create dictionary    lldpAdmin=txonly
    ${api_response}    BIG-IP iControl BasicAuth PATCH    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Set BIG-IP Interface LLDP to Receive Only
    [Documentation]    Changes the LLDP mode on a single BIG-IP interface (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/tmos-implementations-13-0-0/5.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${interface_name}
    ${api_uri}    set variable    /mgmt/tm/net/interface/${interface_name}
    ${api_payload}    create dictionary    lldpAdmin=rxonly
    ${api_response}    BIG-IP iControl BasicAuth PATCH    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Set BIG-IP Interface LLDP to Transmit and Receive
    [Documentation]    Changes the LLDP mode on a single BIG-IP interface (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/tmos-implementations-13-0-0/5.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${interface_name}
    ${api_uri}    set variable    /mgmt/tm/net/interface/${interface_name}
    ${api_payload}    create dictionary    lldpAdmin=txrx
    ${api_response}    BIG-IP iControl BasicAuth PATCH    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Disable BIG-IP LLDP on Interface
    [Documentation]    Changes the LLDP mode on a single BIG-IP interface (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/tmos-implementations-13-0-0/5.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${interface_name}
    ${api_uri}    set variable    /mgmt/tm/net/interface/${interface_name}
    ${api_payload}    create dictionary    lldpAdmin=disable
    ${api_response}    BIG-IP iControl BasicAuth PATCH    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

List all BIG-IP Interfaces
    [Documentation]    Retrieves a list of all BIG-IP interfaces (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/tmos-routing-administration-13-1-0/3.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}
    ${api_uri}    set variable    /mgmt/tm/net/interface
    ${api_response}    BIG-IP iControl BasicAuth GET    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}
    Should Be Equal As Strings    ${api_response.status_code}    200
    ${api_response_dict}    to json    ${api_response.content}
    ${interface_list}    get from dictionary    ${api_response_dict}    items
    [Return]    ${interface_list}

Verify Interface Drop Counters on the BIG-IP
    [Documentation]    Verifies that interface drops are below a certain threshold (defaults to 1000) (https://support.f5.com/csp/article/K10191) Note that frames marked with a dot1q VLAN tag that is not configured on the BIG-IP will result in this counter incrementing with the "vlan unknown" status. See https://support.f5.com/csp/article/K10191.
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${interface_drops_threshold}=0.01
    ${api_uri}    set variable    /mgmt/tm/net/interface/stats
    ${api_response}    BIG-IP iControl BasicAuth GET    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}
    Should Be Equal As Strings    ${api_response.status_code}    200
    ${api_response_dict}    to json    ${api_response.content}
    ${interface_stats_entries}    get from dictionary    ${api_response_dict}    entries
    FOR    ${current_interface}    IN  @{interface_stats_entries}
       ${interface_stats_dict}    get from dictionary    ${interface_stats_entries}    ${current_interface}
       ${interface_stats_dict}    get from dictionary    ${interface_stats_dict}    nestedStats
       ${interface_stats_dict}    get from dictionary    ${interface_stats_dict}    entries
       ${counters_drops_dict}    get from dictionary    ${interface_stats_dict}    counters.dropsAll
       ${counters_drops_count}    get from dictionary    ${counters_drops_dict}    value
       ${counters_pkts_in_dict}    get from dictionary    ${interface_stats_dict}    counters.pktsIn
       ${counters_pkts_in_count}    get from dictionary    ${counters_pkts_in_dict}    value
       ${interface_tmname}    get from dictionary    ${interface_stats_dict}    tmName
       ${interface_tmname}    get from dictionary    ${interface_tmname}    description
       continue for loop if    '${counters_pkts_in_count}' == '0'
       continue for loop if    '${counters_drops_count}' == '0'
       log    Interface drops found on ${interface_tmname} - Drops: ${counters_drops_count}
       should be true    (${counters_drops_count}/${counters_pkts_in_count})*100 < ${interface_drops_threshold}
    END
    [Return]    ${api_response}

Verify Interface Error Counters on the BIG-IP
    [Documentation]    Verifies that interface errors are below a certain threshold (defaults to 1000) (https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/tmos-routing-administration-13-1-0/3.html)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${interface_errors_threshold}=0.01
    ${api_uri}    set variable    /mgmt/tm/net/interface/stats
    ${api_response}    BIG-IP iControl BasicAuth GET    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}
    Should Be Equal As Strings    ${api_response.status_code}    200
    ${api_response_dict}    to json    ${api_response.content}
    ${interface_stats_entries}    get from dictionary    ${api_response_dict}    entries
    FOR    ${current_interface}    IN  @{interface_stats_entries}
       ${interface_stats_dict}    get from dictionary    ${interface_stats_entries}    ${current_interface}
       ${interface_stats_dict}    get from dictionary    ${interface_stats_dict}    nestedStats
       ${interface_stats_dict}    get from dictionary    ${interface_stats_dict}    entries
       ${counters_errors_dict}    get from dictionary    ${interface_stats_dict}    counters.errorsAll
       ${counters_errors_count}    get from dictionary    ${counters_errors_dict}    value
       ${counters_pkts_in_dict}    get from dictionary    ${interface_stats_dict}    counters.pktsIn
       ${counters_pkts_in_count}    get from dictionary    ${counters_pkts_in_dict}    value
       continue for loop if    '${counters_pkts_in_count}' == '0'
       continue for loop if    '${counters_errors_count}' == '0'
       ${interface_tmname}    get from dictionary    ${interface_stats_dict}    tmName
       ${interface_tmname}    get from dictionary    ${interface_tmname}    description
       log    Interface ${interface_tmname} - Errors: ${counters_errors_count}
       should be true    (${counters_errors_count}/${counters_pkts_in_count})*100 < ${interface_errors_threshold}
    END
    [Return]    ${api_response}

Retrieve BIG-IP Interface Media Capabilities
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${interface}=all
    ${tmsh_command}    set variable    tmsh list net interface ${interface} media-capabilities
    Wait until Keyword Succeeds    3x    5 seconds    Open Connection    ${bigip_host}
    Log In    ${bigip_username}    ${bigip_password}
    ${tmsh_result}    Execute Command    ${tmsh_command}
    Close All Connections
    [Return]    ${tmsh_result}
    
Retrieve BIG-IP Interface Configuration via TMSH
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${interface}=all
    ${tmsh_command}    set variable    tmsh list net interface ${interface} all-properties
    Wait until Keyword Succeeds    3x    5 seconds    Open Connection    ${bigip_host}
    Log In    ${bigip_username}    ${bigip_password}
    ${tmsh_result}    Execute Command    ${tmsh_command}
    Close All Connections
    [Return]    ${tmsh_result}

########################
## sys global-settings
########################

Configure BIG-IP Hostname
    [Documentation]    Sets the hostname on the BIG-IP, must include a domain in hostname.domain format (https://support.f5.com/csp/article/K13369)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${hostname}
    ${api_payload}    create dictionary    hostname    ${hostname}
    ${api_uri}    set variable    /mgmt/tm/sys/global-settings
    ${api_response}    BIG-IP iControl BasicAuth PATCH    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Retrieve BIG-IP Hostname
    [Documentation]    Retrieves the hostname on the BIG-IP (https://support.f5.com/csp/article/K13369)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}
    ${api_uri}    set variable    /mgmt/tm/sys/global-settings
    ${api_response}    BIG-IP iControl BasicAuth GET    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}
    Should Be Equal As Strings    ${api_response.status_code}    200
    ${api_response_dict}    to json    ${api_response.text}
    ${configured_hostname}    get from dictionary    ${api_response_dict}    hostname
    [Return]    ${configured_hostname}

Disable BIG-IP GUI Setup Wizard
    [Documentation]    Disables the Setup Wizard in the UI (https://support.f5.com/csp/article/K13369)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}
    ${api_payload}    create dictionary    guiSetup    disabled
    ${api_uri}    set variable    /mgmt/tm/sys/global-settings
    ${api_response}    BIG-IP iControl BasicAuth PATCH    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Enable BIG-IP GUI Setup Wizard
    [Documentation]    Enables the Setup Wizard in the UI (https://support.f5.com/csp/article/K13369)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}
    ${api_payload}    create dictionary    guiSetup    enabled
    ${api_uri}    set variable    /mgmt/tm/sys/global-settings
    ${api_response}    BIG-IP iControl BasicAuth PATCH    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Disable Console Inactivity Timeout on BIG-IP
    [Documentation]    Disables the console port timeout on the BIG-IP (https://support.f5.com/csp/article/K13369)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}
    ${api_payload}    create dictionary    consoleInactivityTimeout    ${0}
    ${api_uri}    set variable    /mgmt/tm/sys/global-settings
    ${api_response}    BIG-IP iControl BasicAuth PATCH    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Configure Console Inactivity Timeout on BIG-IP
    [Documentation]    Sets the console port timeout on the BIG-IP (https://support.f5.com/csp/article/K13369)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${console_timeout}
    ${api_payload}    create dictionary    consoleInactivityTimeout    ${console_timeout}
    ${api_uri}    set variable    /mgmt/tm/sys/global-settings
    ${api_response}    BIG-IP iControl BasicAuth PATCH    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

############
## sys ntp
############

Configure NTP Server List
    [Documentation]    Declaratively sets the list of NTP servers on a BIG-IP (https://support.f5.com/csp/article/K13380)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${ntp_server_list}
    ${ntp_server_list_payload}    to json    ${ntp_server_list}
    ${api_payload}    create dictionary    servers    ${ntp_server_list_payload}
    ${api_uri}    set variable    /mgmt/tm/sys/ntp
    ${api_response}    BIG-IP iControl BasicAuth PATCH  bigip_host=${bigip_host}    bigip_username=${bigip_username}   bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Query NTP Server List
    [Documentation]    Retrieves a list of configured NTP servers on the BIG-IP (https://support.f5.com/csp/article/K13380)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}
    ${api_uri}    set variable    /mgmt/tm/sys/ntp
    ${api_response}    BIG-IP iControl BasicAuth GET   bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}
    Should Be Equal As Strings    ${api_response.status_code}    200
    ${api_response_json}    To Json    ${api_response.content}
    ${ntp_servers_configured}    Get from Dictionary    ${api_response_json}    servers
    ${ntp_servers_configured}    Convert to List    ${ntp_servers_configured}
    List Should Not Contain Duplicates    ${ntp_servers_configured}
    [Return]    ${ntp_servers_configured}

Verify NTP Server Associations
    [Documentation]    Verifies that all configured NTP servers are synced (https://support.f5.com/csp/article/K13380)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}
    ${api_payload}    Create Dictionary    command    run    utilCmdArgs    -c \'ntpq -pn\'
    ${api_uri}    set variable    /mgmt/tm/util/bash
    ${api_response}    BIG-IP iControl BasicAuth POST    bigip_host=${bigip_host}  bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    ${api_response_json}    To Json    ${api_response.content}
    ${ntpq_output}    Get from Dictionary    ${api_response_json}    commandResult
    ${ntpq_output_start}    Set Variable    ${ntpq_output.find("===\n")}
    ${ntpq_output_clean}    Set Variable    ${ntpq_output[${ntpq_output_start}+4:]}
    ${ntpq_output_values_list}    Split String    ${ntpq_output_clean}
    ${ntpq_output_length}    get length    ${ntpq_output_values_list}
    ${ntpq_output_server_count}    evaluate    ${ntpq_output_length} / 10 + 1
    FOR    ${current_ntp_server}  IN RANGE    1   ${ntpq_output_server_count}
       ${ntp_server_ip}    remove from list    ${ntpq_output_values_list}  0
       ${ntp_server_reference}    remove from list    ${ntpq_output_values_list}  0
       ${ntp_server_stratum}    remove from list    ${ntpq_output_values_list}  0
       ${ntp_server_type}    remove from list    ${ntpq_output_values_list}  0
       ${ntp_server_when}    remove from list    ${ntpq_output_values_list}  0
       ${ntp_server_poll}    remove from list    ${ntpq_output_values_list}  0
       ${ntp_server_reach}    remove from list    ${ntpq_output_values_list}  0
       ${ntp_server_delay}    remove from list    ${ntpq_output_values_list}  0
       ${ntp_server_offset}    remove from list    ${ntpq_output_values_list}  0
       ${ntp_server_jitter}    remove from list    ${ntpq_output_values_list}  0
       log    NTP server status: IP: ${ntp_server_ip} Reference IP: ${ntp_server_reference} Stratum: ${ntp_server_stratum} Type: ${ntp_server_type} Last Poll: ${ntp_server_when} Poll Interval: ${ntp_server_poll} Successes: ${ntp_server_reach} Delay: ${ntp_server_delay} Offset: ${ntp_server_offset} Jitter: ${ntp_server_jitter}
    END
    should not be equal as integers    ${ntp_server_reach}    0
    should not be equal as strings    ${ntp_server_when}    -
    should not be equal as strings    ${ntp_server_reference}    .STEP.
    should not be equal as strings    ${ntp_server_reference}    .LOCL.
    [Return]    ${api_response}

Delete NTP Server Configuration
    [Documentation]    Deletes all NTP servers from a BIG-IP (https://support.f5.com/csp/article/K13380)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}
    ${empty_list}    Create List
    ${api_payload}    Create Dictionary    servers=${empty_list}
    ${api_uri}    set variable    /mgmt/tm/sys/ntp
    ${api_response}    BIG-IP iControl BasicAuth PATCH    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

##################
## sys provision
##################

Provision Module on the BIG-IP
    [Documentation]    Sets the provisioning level of a software module on the BIG-IP (https://support.f5.com/csp/article/K12111)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${module}    ${provisioning_level}
    ${api_payload}    create dictionary    level=${provisioning_level}
    ${api_uri}    set variable    /mgmt/tm/sys/provision/afm
    ${api_response}    BIG-IP iControl BasicAuth PATCH    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    should be equal as strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Verify Module is Provisioned
    [Documentation]    Verifies the provisioning level of a software module on the BIG-IP (https://support.f5.com/csp/article/K12111)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${module}
    ${api_uri}    set variable    /mgmt/tm/sys/provision/afm
    ${api_response}    BIG-IP iControl BasicAuth GET    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}
    should be equal as strings    ${api_response.status_code}    200
    should not contain    ${api_response.text}    "level":"none"
    [Return]    ${api_response}

##############
## sys ready  
##############

Verify All BIG-IP Ready States
    [Documentation]    Verifies that the BIG-IP is ready in configuration, license and provisioning state - used by bigip_wait in Ansible (https://clouddocs.f5.com/products/orchestration/ansible/devel/modules/bigip_wait_module.html)    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}
    ${api_uri}    set variable    /mgmt/tm/sys/ready    
    ${api_response}    BIG-IP iControl BasicAuth GET    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}
    Should Be Equal As Strings    ${api_response.status_code}    200
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
    Should Be Equal As Strings    ${api_response.status_code}    200
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
    Should Be Equal As Strings    ${api_response.status_code}    200
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
    Should Be Equal As Strings    ${api_response.status_code}    200
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

################
## sys service
################

Check for BIG-IP Services Waiting to Restart
    [Documentation]    Checks the daemons on the BIG-IP to see if any are awaiting tmm to release a running semaphore (https://support.f5.com/csp/article/K05645522)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}
    ${api_uri}    set variable    /mgmt/tm/sys/service/stats
    ${api_response}    BIG-IP iControl BasicAuth GET    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}
    Should Be Equal As Strings    ${api_response.status_code}    200
    Should Not Contain    ${api_response.text}    waiting for tmm to release running semaphore
    [Return]    ${api_response}

############
## sys ssh
############

Retrieve Current SSH Allow ACL
    [Documentation]    View the current SSH allow ACL on the BIG-IP (https://support.f5.com/csp/article/K5380)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}
    ${api_uri}    set variable    /mgmt/tm/sys/sshd
    ${api_response}    BIG-IP iControl BasicAuth GET    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}
    Should Be Equal As Strings    ${api_response.status_code}    200
    ${api_response_dict}    to json    ${api_response.content}
    ${initial_sshd_allow_acl}    get from dictionary    ${api_response_dict}    allow
    log    Initial SSH Allow ACL: ${initial_sshd_allow_acl}
    set test variable    ${initial_sshd_allow_acl}
    [Return]    ${api_response}

Add Host to SSH Allow ACL
    [Documentation]    Add a host to the current SSH allow ACL on the BIG-IP (https://support.f5.com/csp/article/K5380)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${new_ssh_host}
    Get Current SSH Allow ACL    ${bigip_host}    ${bigip_username}    ${bigip_password}
    list should not contain value   ${initial_sshd_allow_acl}    ${new_ssh_host}
    ${new_sshd_allow_acl}    set variable    ${initial_sshd_allow_acl}
    append to list    ${new_sshd_allow_acl}    ${new_ssh_host}
    log    Updated SSH Allow ACL: ${new_sshd_allow_acl}
    ${api_payload}    create dictionary    allow    ${new_sshd_allow_acl}
    ${api_uri}    set variable    /mgmt/tm/sys/sshd
    ${api_response}    BIG-IP iControl BasicAuth PATCH    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Remove Host from SSH Allow ACL
    [Documentation]    Remove a host from the current SSH allow ACL on the BIG-IP (https://support.f5.com/csp/article/K5380)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${ssh_host}
    Get Current SSH Allow ACL    ${bigip_host}    ${bigip_username}    ${bigip_password}
    list should contain value    ${initial_sshd_allow_acl}    ${ssh_host}
    ${new_sshd_allow_acl}    set variable    ${initial_sshd_allow_acl}
    remove values from list    ${new_sshd_allow_acl}    ${ssh_host}
    log    Updated SSH Allow ACL: ${new_sshd_allow_acl}
    ${api_payload}    create dictionary    allow    ${new_sshd_allow_acl}
    ${api_uri}    set variable    /mgmt/tm/sys/sshd
    ${api_response}    BIG-IP iControl BasicAuth PATCH    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Remove All Hosts from SSH Allow ACL
    [Documentation]    Remove all hosts from the current SSH allow ACL on the BIG-IP (https://support.f5.com/csp/article/K5380)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}
    ${new_sshd_allow_acl}    Create List
    ${api_payload}    create dictionary    allow    ${new_sshd_allow_acl}
    ${api_uri}    set variable    /mgmt/tm/sys/sshd
    ${api_response}    BIG-IP iControl BasicAuth PATCH    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Reset BIG-IP SSH Allow ACL to Allow All Hosts
    [Documentation]    Resets the  SSH allow ACL on the BIG-IP to the default value to allow all hosts (https://support.f5.com/csp/article/K5380)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}
    ${all_ssh_list}    create list    ALL
    ${api_payload}    create dictionary    allow=${all_ssh_list}
    ${api_uri}    set variable    /mgmt/tm/sys/sshd
    ${api_response}    BIG-IP iControl BasicAuth PATCH    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Verify SSH Allow ACL
    [Documentation]    Verify that a host exists in the current SSH allow ACL on the BIG-IP (https://support.f5.com/csp/article/K5380)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}    ${verify_ssh_host}
    ${api_uri}    set variable    /mgmt/tm/sys/sshd
    ${api_response}    BIG-IP iControl BasicAuth GET    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}
    Should Be Equal As Strings    ${api_response.status_code}    200
    ${api_response_dict}    to json    ${api_response.content}
    ${sshd_allow_acl}    get from dictionary    ${api_response_dict}    allow
    list should contain value    ${sshd_allow_acl}    ${verify_ssh_host}
    [Return]    ${api_response}

Run BASH Echo Test
    [Documentation]    Issues a BASH command and looks for the proper response inside of an existing SSH session
    ${BASH_ECHO_RESPONSE}    Execute Command    bash -c echo\\ 'BASH TEST'
    Should Be Equal    ${BASH_ECHO_RESPONSE}    BASH TEST
    [Return]    ${BASH_ECHO_RESPONSE}

############
## sys ucs
############

Save a UCS on the BIG-IP
    [Documentation]    Saves a configuration backup on a BIG-IP (https://support.f5.com/csp/article/K4423)
    [Arguments]    ${bigip_host}   ${bigip_username}    ${bigip_password}    ${ucs_filename}
    ${api_payload}    create dictionary    command=save    name=${ucs_filename}
    ${api_uri}    set variable    /mgmt/tm/sys/ucs
    ${api_response}    BIG-IP iControl BasicAuth POST    bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    Should Be Equal As Strings    ${api_response.status_code}    200
    [Return]    ${api_response}

Load a UCS on the BIG-IP
    [Documentation]    Loads a configuration backup to a BIG-IP (https://support.f5.com/csp/article/K4423)
    [Arguments]    ${bigip_host}   ${bigip_username}    ${bigip_password}    ${ucs_filename}
    ${api_payload}    create dictionary    command=load    name=${ucs_filename}
    ${api_uri}    set variable    /mgmt/tm/sys/ucs
    ${api_response}    BIG-IP iControl BasicAuth POST without Verification     bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}    api_payload=${api_payload}
    [Return]    ${api_response}

################
## sys version
################

Retrieve BIG-IP Version
    [Documentation]    Shows the current version of software running on the BIG-IP (https://support.f5.com/csp/article/K8759)
    [Arguments]    ${bigip_host}   ${bigip_username}   ${bigip_password}
    ${api_auth}    create list    ${bigip_username}    ${bigip_password}
    ${api_uri}    set variable    /mgmt/tm/sys/version
    ${api_response}    BIG-IP iControl BasicAuth GET   bigip_host=${bigip_host}    bigip_username=${bigip_username}    bigip_password=${bigip_password}    api_uri=${api_uri}
    should be equal as strings    ${api_response.status_code}    200
    Log    API RESPONSE: ${api_response.content}
    [Return]    ${api_response}

Retrieve BIG-IP Version using Token Authentication
    [Documentation]    Shows the current version of software running on the BIG-IP (https://support.f5.com/csp/article/K8759)
    [Arguments]    ${bigip_host}    ${bigip_username}    ${bigip_password}
    ${api_token}    Generate Token    ${bigip_host}    ${bigip_username}   ${bigip_password}
    ${api_uri}    set variable    /mgmt/tm/sys/version
    ${api_response}    BIG-IP iControl TokenAuth GET    bigip_host=${bigip_host}    api_token=${api_token}    api_uri=${api_uri}
    Should Be Equal As Strings    ${api_response.status_code}    200
    ${verification_text}    set variable  "kind":"tm:sys:version:versionstats"
    should contain    ${api_response.text}    ${verification_text}
    [Teardown]    Run Keywords    Delete Token    bigip_host=${bigip_host}    api_token=${api_token}    AND    Delete All Sessions
    [Return]    ${api_response}
