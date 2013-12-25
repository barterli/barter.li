Feature: Review Feature
  As a user
  I can review other users and rate them
  

    Background:
      Given I am logged in 
      And I am in user display page

    Scenario: Adding review
      When I filled in my review in review textbox
      And I clicked Add button
      Then I should see my added review top of it

    Scenario: Adding rating to users
      Then i can rate the user
    
    
 

    