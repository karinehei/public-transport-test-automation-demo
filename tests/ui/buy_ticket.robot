*** Settings ***
Resource    ../../resources/keywords.robot
Suite Setup    Create Session    ticketing    ${API_BASE_URL}
Suite Teardown    Delete All Sessions

*** Test Cases ***
Buy Ticket UI Flow - Zone AB
    [Documentation]    Simulates UI flow: user selects zone AB, pays
    ${response}=    Create Ticket    zone=AB
    Should Be Equal As Strings    ${response.status_code}    201
    ${ticket_id}=    Set Variable    ${response.json()}[id]
    Log    Ticket purchased: ${ticket_id}
    ${get_response}=    Get Ticket    ${ticket_id}
    Ticket Should Be Valid    ${get_response}

Buy Ticket UI Flow - Zone ABC
    [Documentation]    Simulates UI flow: user selects zone ABC
    ${response}=    Create Ticket    zone=ABC
    Should Be Equal As Strings    ${response.status_code}    201
    ${ticket_id}=    Set Variable    ${response.json()}[id]
    Log    Ticket purchased: ${ticket_id}
    Should Be Equal As Strings    ${response.json()}[zone]    ABC

Buy Ticket UI Flow - Zone ABCD
    [Documentation]    Simulates UI flow: user selects zone ABCD
    ${response}=    Create Ticket    zone=ABCD
    Should Be Equal As Strings    ${response.status_code}    201
    Should Be Equal As Strings    ${response.json()}[zone]    ABCD

Verify Zones Available Before Purchase
    [Documentation]    Verify zones are loaded before ticket purchase (UI prerequisite)
    ${response}=    Get Zones
    Should Be Equal As Strings    ${response.status_code}    200
    ${zones}=    Set Variable    ${response.json()}[zones]
    Should Not Be Empty    ${zones}    Zones must be available for purchase
