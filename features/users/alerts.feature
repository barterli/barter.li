Feature: Alerts
  A user can receive alerts about 
  New items beign added to near by location 
  New users signed in near by location
  A whishlist that became available

    Background:
      Given I am logged in

    Scenario: User receives alert about new items added near by - settings on
      Given user settings for alerts for items is on
      when new items are beign added near by location
      Then I should get notification about it 
      
    
    Scenario: User receives alert about new items added near by - settings off
      Given user settings for alerts for items is off
      when new items are beign added near by location
      Then I should not get notification about it


    Scenario: User receives alert about new users signed up near by - settings on
      Given user settings for alerts for users is on
      when new users sign up near by locations
      Then I should get notification about it 
      
    
    Scenario: User receives alert about new users signedup near by - settings off
      Given user settings for alerts for users is off
      when new users sign up near by location
      Then I should not get notification about it  


    Scenario: User can add whishlist and receive alerts about it
      Given user enter a whishlist for item not found
      Then user receives alert about it
      
      
 