*** Settings ***
Documentation    This suite tests aspects of the BIG-IP device administration
Resource    robotframework-f5-tmos.robot

*** Test Cases ***

Archives / saving and restoring device configuration
  [Documentation]  Save device configuration, then change it and then restore old configuration. All recent changes should be gone.
  set log level  trace

Archives / upload
  [Documentation]  Validate successful upload of archive file to GTM
  set log level  trace

TCPDUMP
  [Documentation]  ran tcpdump  -ni 0.0 - verified output
  set log level  trace

QKView export
  [Documentation]  verify Qkview can be generated as exported
  set log level  trace

Downgrade and upgrade Code 
  [Documentation]  Validate successful downgrade and upgrade of code between current prod and new code
  set log level  trace

Radius
  [Documentation]  verified users authenticated via radius still can authenticate after upgrade
  set log level  trace

TACACS
  [Documentation]  Verify user authenticated via TACACS.
  set log level  trace
  