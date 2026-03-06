*** Settings ***
Library    RequestsLibrary
Library    Collections
Resource    ../../resources/keywords.robot
Suite Setup    Create API Session
Suite Teardown    Delete All Sessions

*** Variables ***
${API_BASE_URL}    http://api:8000

*** Test Cases ***
Get Zones
    [Documentation]    Retrieve available travel zones and validate response
    ${response}=    Get Zones
    Should Be Equal As Strings    ${response.status_code}    200
    Dictionary Should Contain Key    ${response.json()}    zones
    ${zones}=    Set Variable    ${response.json()}[zones]
    Should Not Be Empty    ${zones}
    ${zone_ids}=    Create List    AB    ABC    ABCD    BC    CD
    FOR    ${zone}    IN    @{zones}
        Dictionary Should Contain Key    ${zone}    id
        Dictionary Should Contain Key    ${zone}    name
        List Should Contain Value    ${zone_ids}    ${zone}[id]
    END
    Log    Zones: ${zones}

Purchase Ticket
    [Documentation]    Create a ticket (purchase) and validate response
    ${response}=    Buy Ticket    zone=AB
    Should Be Equal As Strings    ${response.status_code}    201
    ${json}=    Set Variable    ${response.json()}
    Dictionary Should Contain Key    ${json}    id
    Dictionary Should Contain Key    ${json}    zone
    Dictionary Should Contain Key    ${json}    created_at
    Dictionary Should Contain Key    ${json}    valid
    Should Be Equal As Strings    ${json}[zone]    AB
    Should Be Equal As Strings    ${json}[valid]    True
    Log    Ticket purchased: ${json}[id]

Fetch Ticket
    [Documentation]    Purchase a ticket then fetch it by ID and validate
    ${create_response}=    Buy Ticket    zone=ABC
    Should Be Equal As Strings    ${create_response.status_code}    201
    ${ticket_id}=    Set Variable    ${create_response.json()}[id]
    ${response}=    Get Ticket    ${ticket_id}
    Should Be Equal As Strings    ${response.status_code}    200
    ${json}=    Set Variable    ${response.json()}
    Should Be Equal As Strings    ${json}[id]    ${ticket_id}
    Should Be Equal As Strings    ${json}[zone]    ABC
    Dictionary Should Contain Key    ${json}    created_at
    Dictionary Should Contain Key    ${json}    valid
    Should Be Equal As Strings    ${json}[valid]    True

Validate Ticket
    [Documentation]    Purchase ticket, validate it, and verify status
    ${create_response}=    Buy Ticket    zone=AB
    Should Be Equal As Strings    ${create_response.status_code}    201
    ${ticket_id}=    Set Variable    ${create_response.json()}[id]
    ${response}=    Validate Ticket    ${ticket_id}
    Should Be Equal As Strings    ${response.status_code}    200
    ${json}=    Set Variable    ${response.json()}
    Should Be Equal As Strings    ${json}[ticket_id]    ${ticket_id}
    Should Be Equal As Strings    ${json}[valid]    True
    Should Be Equal As Strings    ${json}[status]    validated
    Dictionary Should Contain Key    ${json}    validated
    ${get_response}=    Get Ticket    ${ticket_id}
    Should Be Equal As Strings    ${get_response.json()}[valid]    False
