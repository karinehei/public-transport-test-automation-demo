*** Settings ***
Library    RequestsLibrary
Library    Collections

*** Variables ***
${API_BASE_URL}    http://localhost:8000    # Override with --variable API_BASE_URL:http://api:8000 in Docker/CI

*** Keywords ***
API Should Be Healthy
    [Documentation]    Verify the ticketing API is running and healthy
    ${response}=    GET    ${API_BASE_URL}/health
    Should Be Equal As Strings    ${response.status_code}    200
    Dictionary Should Contain Key    ${response.json()}    status
    Should Be Equal As Strings    ${response.json()}[status]    healthy

Create Ticket
    [Documentation]    Create a new ticket via API
    [Arguments]    ${ticket_type}=single    ${zone}=AB    ${passenger_type}=adult
    ${payload}=    Create Dictionary
    ...    ticket_type=${ticket_type}
    ...    zone=${zone}
    ...    passenger_type=${passenger_type}
    ${response}=    POST    ${API_BASE_URL}/tickets    json=${payload}
    [Return]    ${response}

Get Ticket
    [Documentation]    Retrieve a ticket by ID
    [Arguments]    ${ticket_id}
    ${response}=    GET    ${API_BASE_URL}/tickets/${ticket_id}
    [Return]    ${response}

Validate Ticket
    [Documentation]    Validate a ticket
    [Arguments]    ${ticket_id}
    ${payload}=    Create Dictionary    ticket_id=${ticket_id}
    ${response}=    POST    ${API_BASE_URL}/validate    json=${payload}
    [Return]    ${response}

Get Zones
    [Documentation]    Get available transport zones
    ${response}=    GET    ${API_BASE_URL}/zones
    [Return]    ${response}

Clear All Tickets
    [Documentation]    Clear all tickets (test cleanup)
    ${response}=    DELETE    ${API_BASE_URL}/tickets
    [Return]    ${response}

Ticket Should Be Valid
    [Documentation]    Verify ticket has valid status
    [Arguments]    ${ticket_response}
    Should Be Equal As Strings    ${ticket_response.status_code}    200
    ${json}=    Set Variable    ${ticket_response.json()}
    Dictionary Should Contain Key    ${json}    valid
    Should Be True    ${json}[valid]

Ticket Should Be Invalid
    [Documentation]    Verify ticket has been invalidated
    [Arguments]    ${ticket_response}
    Should Be Equal As Strings    ${ticket_response.status_code}    200
    ${json}=    Set Variable    ${ticket_response.json()}
    Should Not Be True    ${json}[valid]
