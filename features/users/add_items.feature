Feature: Add Items
  As a user
  I can add my items so that i can barter my items with other

    Background:
      Given I am a logged in user 

    Scenario: User adds item with valid data
      Given I selected a category 
      And clicked on add item
      Then I can add  item with multiple images and auto suggest
      When I filled the form with valid details 
      And clicked submit button
      Then I should see item successfully added message

    
    Scenario: User adds item with valid data
      Given I selected a category 
      And clicked on add item
      Then I should get see a form for adding item with multiple items
      When I filled the form with invalid details 
      And clicked submit button
      Then I should see an error message



