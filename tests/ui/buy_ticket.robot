*** Settings ***
Resource    ../../resources/keywords.robot
Suite Setup    Create Session    ticketing    ${API_BASE_URL}
Suite Teardown    Delete All Sessions

*** Test Cases ***
Buy Ticket UI Flow - Single Zone AB
    [Documentation]    Simulates UI flow: user selects single ticket, zone AB, pays
    ${response}=    Create Ticket    ticket_type=single    zone=AB    passenger_type=adult
    Should Be Equal As Strings    ${response.status_code}    201
    ${ticket_id}=    Set Variable    ${response.json()}[id]
    Log    Ticket purchased: ${ticket_id}
    ${get_response}=    Get Ticket    ${ticket_id}
    Ticket Should Be Valid    ${get_response}

Buy Ticket UI Flow - Day Ticket Zone ABC
    [Documentation]    Simulates UI flow: user selects day ticket for zone ABC
    ${response}=    Create Ticket    ticket_type=day    zone=ABC    passenger_type=adult
    Should Be Equal As Strings    ${response.status_code}    201
    ${ticket_id}=    Set Variable    ${response.json()}[id]
    Log    Day ticket purchased: ${ticket_id}
    Should Be Equal As Strings    ${response.json()}[zone]    ABC

Buy Ticket UI Flow - Child Zone AB
    [Documentation]    Simulates UI flow: user selects child ticket
    ${response}=    Create Ticket    ticket_type=single    zone=AB    passenger_type=child
    Should Be Equal As Strings    ${response.status_code}    201
    Should Be Equal As Strings    ${response.json()}[passenger_type]    child

Verify Zones Available Before Purchase
    [Documentation]    Verify zones are loaded before ticket purchase (UI prerequisite)
    ${response}=    Get Zones
    Should Be Equal As Strings    ${response.status_code}    200
    ${zones}=    Set Variable    ${response.json()}[zones]
    Should Not Be Empty    ${zones}    Zones must be available for purchase
