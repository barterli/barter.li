Feature: Sign up
  In order to get access to all features of site
  As a user
  I want to be able to sign up with either facebook or normal sign up form

    Background:
      Given I am not logged in 

    Scenario: User signs up with valid data
      Given I sign up with valid user data
      When I submit
      Then I should get the current location of users 
      And I should see a successful sign up message
    
    Scenario: User signs up with invalid data
      When I sign up with an invalid data
      Then I should see an invalid  message

    Scenario: User signs up with facebook
      Given I sign up with facebook
      When I get uid from facebook
      Then I should get the current location of users 
      And I should see a successful sign up message

    

   