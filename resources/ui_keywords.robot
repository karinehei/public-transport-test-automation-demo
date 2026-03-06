*** Settings ***
Library    SeleniumLibrary
Library    Collections

*** Variables ***
${APP_URL}    http://localhost:3000

*** Keywords ***
Open Ticketing Application
    [Documentation]    Open the ticketing web UI
    [Arguments]    ${url}=${APP_URL}
    Open Browser    ${url}    headlesschrome    options=add_argument("--no-sandbox");add_argument("--disable-dev-shm-usage");add_argument("--disable-gpu")
    Maximize Browser Window
    Wait Until Element Is Visible    css=[data-testid="ticketing-app"]    timeout=10s

Select Travel Zone
    [Documentation]    Select a zone from the dropdown
    [Arguments]    ${zone}=AB
    Select From List By Value    css=[data-testid="zone-select"]    ${zone}

Click Buy Ticket
    [Documentation]    Click the Buy Ticket button
    Click Element    css=[data-testid="buy-ticket-btn"]
    Wait Until Element Is Visible    css=[data-testid="ticket-card"]    timeout=5s

Confirm Ticket Created
    [Documentation]    Verify ticket card is displayed with valid content
    ${ticket_id}=    Get Text    css=[data-testid="ticket-id"]
    Should Contain    ${ticket_id}    Ticket ID:
    ${zone}=    Get Text    css=[data-testid="ticket-zone"]
    Should Contain    ${zone}    Zone:
    RETURN    ${ticket_id}

Click Validate Ticket
    [Documentation]    Click the Validate Ticket button
    Click Element    css=[data-testid="validate-ticket-btn"]
    Wait Until Element Is Visible    css=[data-testid="validation-result"]    timeout=5s

Confirm Validation Success
    [Documentation]    Verify ticket was validated successfully
    ${result}=    Get Text    css=[data-testid="validation-result"]
    Should Contain    ${result}    validated successfully

Confirm Validation Already Used
    [Documentation]    Verify ticket was already used
    ${result}=    Get Text    css=[data-testid="validation-result"]
    Should Contain    ${result}    already been used
