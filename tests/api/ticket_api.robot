*** Settings ***
Library    RequestsLibrary
Library    Collections
Suite Teardown    Delete All Sessions

*** Variables ***
${API_BASE_URL}    http://api:8000

*** Test Cases ***
Get Zones
    [Documentation]    Retrieve available travel zones and validate response
    Create Session    ticketing    ${API_BASE_URL}
    ${response}=    GET On Session    ticketing    /zones
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
    Create Session    ticketing    ${API_BASE_URL}
    ${payload}=    Create Dictionary    zone=AB
    ${response}=    POST On Session    ticketing    /tickets    json=${payload}
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
    Create Session    ticketing    ${API_BASE_URL}
    ${payload}=    Create Dictionary    zone=ABC
    ${create_response}=    POST On Session    ticketing    /tickets    json=${payload}
    Should Be Equal As Strings    ${create_response.status_code}    201
    ${ticket_id}=    Set Variable    ${create_response.json()}[id]
    ${response}=    GET On Session    ticketing    /tickets/${ticket_id}
    Should Be Equal As Strings    ${response.status_code}    200
    ${json}=    Set Variable    ${response.json()}
    Should Be Equal As Strings    ${json}[id]    ${ticket_id}
    Should Be Equal As Strings    ${json}[zone]    ABC
    Dictionary Should Contain Key    ${json}    created_at
    Dictionary Should Contain Key    ${json}    valid
    Should Be Equal As Strings    ${json}[valid]    True

Validate Ticket
    [Documentation]    Purchase ticket, validate it, and verify status
    Create Session    ticketing    ${API_BASE_URL}
    ${payload}=    Create Dictionary    zone=AB
    ${create_response}=    POST On Session    ticketing    /tickets    json=${payload}
    Should Be Equal As Strings    ${create_response.status_code}    201
    ${ticket_id}=    Set Variable    ${create_response.json()}[id]
    ${validate_payload}=    Create Dictionary    ticket_id=${ticket_id}
    ${response}=    POST On Session    ticketing    /validate    json=${validate_payload}
    Should Be Equal As Strings    ${response.status_code}    200
    ${json}=    Set Variable    ${response.json()}
    Should Be Equal As Strings    ${json}[ticket_id]    ${ticket_id}
    Should Be Equal As Strings    ${json}[valid]    True
    Should Be Equal As Strings    ${json}[status]    validated
    Dictionary Should Contain Key    ${json}    validated
    ${get_response}=    GET On Session    ticketing    /tickets/${ticket_id}
    Should Be Equal As Strings    ${get_response.json()}[valid]    False
