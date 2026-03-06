*** Settings ***
Resource    ../../resources/keywords.robot
Suite Setup    API Should Be Healthy
Suite Teardown    Delete All Sessions

*** Test Cases ***
Complete Ticket User Journey
    [Documentation]    E2E: Full user journey - get zones, buy ticket, retrieve, validate
    [Tags]    e2e    smoke    critical

    # Step 1: Get available zones
    ${zones_response}=    Get Zones
    Should Be Equal As Strings    ${zones_response.status_code}    200
    Dictionary Should Contain Key    ${zones_response.json()}    zones
    ${zones}=    Set Variable    ${zones_response.json()}[zones]
    Should Not Be Empty    ${zones}    Zones must be available
    Log    Available zones: ${zones}

    # Step 2: Buy ticket
    ${purchase_response}=    Create Ticket    zone=AB
    Should Be Equal As Strings    ${purchase_response.status_code}    201
    ${ticket_id}=    Set Variable    ${purchase_response.json()}[id]
    Dictionary Should Contain Key    ${purchase_response.json()}    zone
    Should Be Equal As Strings    ${purchase_response.json()}[zone]    AB
    Should Be Equal As Strings    ${purchase_response.json()}[valid]    True
    Log    Ticket purchased: ${ticket_id}

    # Step 3: Retrieve ticket
    ${get_response}=    Get Ticket    ${ticket_id}
    Should Be Equal As Strings    ${get_response.status_code}    200
    Should Be Equal As Strings    ${get_response.json()}[id]    ${ticket_id}
    Ticket Should Be Valid    ${get_response}

    # Step 4: Validate ticket
    ${validate_response}=    Validate Ticket    ${ticket_id}
    Should Be Equal As Strings    ${validate_response.status_code}    200
    Should Be Equal As Strings    ${validate_response.json()}[ticket_id]    ${ticket_id}
    Should Be Equal As Strings    ${validate_response.json()}[valid]    True
    Should Be Equal As Strings    ${validate_response.json()}[status]    validated
    Dictionary Should Contain Key    ${validate_response.json()}    validated

    # Verify ticket is now invalid (cannot be reused)
    ${after_validate}=    Get Ticket    ${ticket_id}
    Should Be Equal As Strings    ${after_validate.status_code}    200
    Ticket Should Be Invalid    ${after_validate}
