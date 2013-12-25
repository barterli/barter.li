Feature: Barter Items
  As a user
  I can barter my items with others

    Scenario: User barter items without login
      When I am not logged in
      Given I am in items page
      When I click barter button
      Then I am asked to login
      And I type some message
      And click submit
      Then the item owner should get a notification about it
      
    Scenario: User barter items when login
      When I am logged in
      Given I am in items page
      When I click barter button
      Then I am redirected to barter page
      And I type some message
      And click submit
      Then the item owner should get a notification about it
    
    Scenario: User barter notifications
      Given seeing notifications alert
      When I click on it
      Then I should see users interested in bartering my item
      And I can post a reply to him 
      Then I can select locations with foresquare api to meet
      And interested user should get a Notification of it
      