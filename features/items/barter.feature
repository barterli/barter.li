Feature: Barter Items
  As a user
  I can barter my items with others

    Background:
      Given I am logged in 
      

    Scenario: User barter items
      Given I am in items page
      When I click barter button
      Then I am redirected to barter page
      When I entered my barter item and a message
      And click submit
      Then the item owner should get a notification about it
    
    Scenario: User barter notifications
      Given seeing notifications alert
      When I click on it
      Then I should see users interested in bartering my item
      And I can post a reply to him 
      Then interested user should get a Notification of it
      