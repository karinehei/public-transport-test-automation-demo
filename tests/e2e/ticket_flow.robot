*** Settings ***
Resource    ../../resources/keywords.robot
Suite Setup    Create Session    ticketing    ${API_BASE_URL}
Suite Teardown    Delete All Sessions

*** Test Cases ***
Complete Ticket Purchase And Validation Flow
    [Documentation]    E2E: Purchase ticket -> validate on board -> verify invalid
    [Tags]    e2e    smoke    critical

    # Step 1: Check API is available
    API Should Be Healthy

    # Step 2: Get available zones (user selects zone)
    ${zones_response}=    Get Zones
    Should Be Equal As Strings    ${zones_response.status_code}    200

    # Step 3: Purchase ticket (user completes payment)
    ${purchase_response}=    Create Ticket    zone=AB
    Should Be Equal As Strings    ${purchase_response.status_code}    201
    ${ticket_id}=    Set Variable    ${purchase_response.json()}[id]
    Log    Purchased ticket: ${ticket_id}

    # Step 4: Verify ticket is retrievable (user views ticket)
    ${get_response}=    Get Ticket    ${ticket_id}
    Should Be Equal As Strings    ${get_response.status_code}    200
    Ticket Should Be Valid    ${get_response}

    # Step 5: Validate ticket (simulates validator scan on board)
    ${validate_response}=    Validate Ticket    ${ticket_id}
    Should Be Equal As Strings    ${validate_response.status_code}    200
    Should Be Equal As Strings    ${validate_response.json()}[valid]    True
    Should Be Equal As Strings    ${validate_response.json()}[status]    validated

    # Step 6: Verify ticket is now invalid (cannot be reused)
    ${after_validate}=    Get Ticket    ${ticket_id}
    Ticket Should Be Invalid    ${after_validate}

Zone ABCD Ticket Flow
    [Documentation]    E2E: Purchase ticket for zone ABCD
    [Tags]    e2e

    ${response}=    Create Ticket    zone=ABCD
    Should Be Equal As Strings    ${response.status_code}    201
    Should Be Equal As Strings    ${response.json()}[zone]    ABCD
    ${ticket_id}=    Set Variable    ${response.json()}[id]
    ${get_response}=    Get Ticket    ${ticket_id}
    Should Be Equal As Strings    ${get_response.status_code}    200
