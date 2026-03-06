*** Settings ***
Resource    ../../resources/ui_keywords.robot
Suite Teardown    Close Browser

*** Variables ***
${APP_URL}    http://localhost:3000

*** Test Cases ***
Complete Ticket Purchase And Validation UI Flow
    [Documentation]    E2E UI: Open app, select zone, buy ticket, confirm, validate, confirm result
    [Tags]    ui    e2e    smoke

    # Step 1: Open the application
    Open Ticketing Application    url=${APP_URL}

    # Step 2: Select a travel zone
    Select Travel Zone    zone=AB

    # Step 3: Buy a ticket
    Click Buy Ticket

    # Step 4: Confirm ticket was created
    Confirm Ticket Created

    # Step 5: Validate the ticket
    Click Validate Ticket

    # Step 6: Confirm ticket validation result
    Confirm Validation Success
