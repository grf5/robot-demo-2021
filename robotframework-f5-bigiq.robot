*** Keywords ***
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
