*** Settings ***
Library    RequestsLibrary
Library    Collections

*** Variables ***
${API_BASE_URL}    http://localhost:8000    # Override with --variable API_BASE_URL:http://api:8000 in Docker/CI
${API_SESSION}    ticketing

*** Keywords ***
Create API Session
    [Documentation]    Create a RequestsLibrary session for API calls. Call in Suite Setup.
    [Arguments]    ${base_url}=${API_BASE_URL}    ${alias}=ticketing
    Create Session    ${alias}    ${base_url}
    Set Suite Variable    ${API_SESSION}    ${alias}
    RETURN    ${alias}

Get Zones
    [Documentation]    Get available transport zones
    ${response}=    GET On Session    ${API_SESSION}    /zones
    RETURN    ${response}

Buy Ticket
    [Documentation]    Purchase a ticket for the given zone
    [Arguments]    ${zone}=AB
    ${payload}=    Create Dictionary    zone=${zone}
    ${response}=    POST On Session    ${API_SESSION}    /tickets    json=${payload}
    RETURN    ${response}

Create Ticket
    [Documentation]    Alias for Buy Ticket (backward compatibility)
    [Arguments]    ${zone}=AB
    ${response}=    Buy Ticket    zone=${zone}
    RETURN    ${response}

Get Ticket
    [Documentation]    Retrieve a ticket by ID
    [Arguments]    ${ticket_id}
    ${response}=    GET On Session    ${API_SESSION}    /tickets/${ticket_id}
    RETURN    ${response}

Validate Ticket
    [Documentation]    Validate a ticket
    [Arguments]    ${ticket_id}
    ${payload}=    Create Dictionary    ticket_id=${ticket_id}
    ${response}=    POST On Session    ${API_SESSION}    /validate    json=${payload}
    RETURN    ${response}

API Should Be Healthy
    [Documentation]    Verify the ticketing API is running and healthy
    ${response}=    GET On Session    ${API_SESSION}    /health
    Should Be Equal As Strings    ${response.status_code}    200
    Dictionary Should Contain Key    ${response.json()}    status
    Should Be Equal As Strings    ${response.json()}[status]    healthy

Clear All Tickets
    [Documentation]    Clear all tickets (test cleanup)
    ${response}=    DELETE On Session    ${API_SESSION}    /tickets
    RETURN    ${response}

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
