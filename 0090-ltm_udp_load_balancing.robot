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
export UDP_ROUND_ROBIN_VIP_NAME='udp_dns_round_robin_vs'
export UDP_ROUND_ROBIN_VIP_PARTITION='Common'
export UDP_ROUND_ROBIN_VIP_ADDRESS='198.19.160.2'
export UDP_ROUND_ROBIN_VIP_MASK='255.255.255.255'
export UDP_ROUND_ROBIN_VIP_PORT='53'
export UDP_ROUND_ROBIN_VIP_PROTOCOL='udp'
export UDP_ROUND_ROBIN_VIP_SNAT_TYPE='automap'
export UDP_ROUND_ROBIN_POOL_NAME='udp_dns_round_robin_pool'
export UDP_ROUND_ROBIN_POOL_MEMBERS='[{"address":"198.19.208.21","port":"53"},{"address":"198.19.208.22","port":"53"},{"address":"198.19.208.23","port":"53"},{"address":"198.19.208.24","port":"53"},{"address":"198.19.208.25","port":"53"},{"address":"198.19.208.26","port":"53"},{"address":"198.19.208.27","port":"53"},{"address":"198.19.208.28","port":"53"},{"address":"198.19.208.29","port":"53"},{"address":"198.19.208.30","port":"53"}]'
export UDP_ROUND_ROBIN_POOL_MONITOR='/Common/gateway_icmp'

*** Test Cases ***
