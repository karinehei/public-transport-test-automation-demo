*** Settings ***
Resource    ../../resources/keywords.robot
Suite Setup    Create Session    ticketing    ${API_BASE_URL}
Suite Teardown    Delete All Sessions

*** Test Cases ***
API Health Check
    [Documentation]    Verify the ticketing API is running
    API Should Be Healthy

Create Ticket Zone AB
    [Documentation]    Create a ticket in zone AB
    ${response}=    Create Ticket    zone=AB
    Should Be Equal As Strings    ${response.status_code}    201
    Dictionary Should Contain Key    ${response.json()}    id
    Should Be Equal As Strings    ${response.json()}[zone]    AB
    Should Be Equal As Strings    ${response.json()}[valid]    True

Create Ticket Zone ABC
    [Documentation]    Create a ticket for zone ABC
    ${response}=    Create Ticket    zone=ABC
    Should Be Equal As Strings    ${response.status_code}    201
    Should Be Equal As Strings    ${response.json()}[zone]    ABC

Get Ticket By ID
    [Documentation]    Verify ticket can be retrieved after creation
    ${create_response}=    Create Ticket    zone=AB
    ${ticket_id}=    Set Variable    ${create_response.json()}[id]
    ${get_response}=    Get Ticket    ${ticket_id}
    Should Be Equal As Strings    ${get_response.status_code}    200
    Should Be Equal As Strings    ${get_response.json()}[id]    ${ticket_id}

Get Non-Existent Ticket Returns 404
    [Documentation]    Verify 404 for unknown ticket
    ${response}=    GET    ${API_BASE_URL}/tickets/non-existent-id-12345
    Should Be Equal As Strings    ${response.status_code}    404

Validate Ticket
    [Documentation]    Validate a ticket and verify it becomes invalid
    ${create_response}=    Create Ticket    zone=AB
    ${ticket_id}=    Set Variable    ${create_response.json()}[id]
    ${validate_response}=    Validate Ticket    ${ticket_id}
    Should Be Equal As Strings    ${validate_response.status_code}    200
    Should Be Equal As Strings    ${validate_response.json()}[valid]    True
    Should Be Equal As Strings    ${validate_response.json()}[status]    validated
    ${get_response}=    Get Ticket    ${ticket_id}
    Should Be Equal As Strings    ${get_response.json()}[valid]    False

Double Validation Fails
    [Documentation]    Verify ticket cannot be validated twice
    ${create_response}=    Create Ticket    zone=AB
    ${ticket_id}=    Set Variable    ${create_response.json()}[id]
    Validate Ticket    ${ticket_id}
    ${second_validate}=    Validate Ticket    ${ticket_id}
    Should Be Equal As Strings    ${second_validate.json()}[valid]    False
    Should Be Equal As Strings    ${second_validate.json()}[status]    already_used

Get Zones
    [Documentation]    Verify zones endpoint returns correct data
    ${response}=    Get Zones
    Should Be Equal As Strings    ${response.status_code}    200
    Dictionary Should Contain Key    ${response.json()}    zones
    ${zones}=    Set Variable    ${response.json()}[zones]
    Length Should Be    ${zones}    5
    ${zone_ids}=    Create List    AB    ABC    ABCD    BC    CD
    FOR    ${zone}    IN    @{zones}
        List Should Contain Value    ${zone_ids}    ${zone}[id]
    END
