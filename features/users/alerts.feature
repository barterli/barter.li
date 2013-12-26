Feature: Alerts
  A user can receive alerts about 
  New items beign added to near by location 
  New users signed in near by location
  A whishlist that became available

    Background:
      Given I am logged in

    Scenario: User receives email about new items added near by - settings off
      Given user settings for alerts for items is off
      When new items are beign added near by location
      Then I should not get notification about it


    Scenario: User receives email about new users signedup near by - settings off
      Given user settings for alerts for users is off
      When new users sign up near by location
      Then I should not get notification about it  

    Scenario: User can add whishlist and receive alerts about it within city 
      Given user enter a whishlist for item not found
      Then user receives alert about it
      And email should be restricted to 6 per month

    Scenario Outline: User email about new users signed up near by - settings on
      Given user settings for alerts for users is on
      When new users sign up near by locations
      And settings option is <location>
      Then I should get notification about it 
      And email should be restricted to 6 per month
    
    Examples:
      | Location |
      | City     |
      | street   |

    Scenario Outline: User email about new items in added near by - settings on
      Given user settings for alerts for items is on
      When new items are beign added near by location
      And settings option is <location>
      Then I should get notification about it 
      And email should be restricted to 6 per month

    Examples:
      | Location |
      | City     |
      | street   |
      
      
 