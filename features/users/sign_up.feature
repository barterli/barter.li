Feature: Sign up
  In order to get access to all features of site
  As a user
  I want to be able to sign up with either facebook or normal sign up form

    Background:
      Given I am not logged in 

    Scenario: User signs up with valid data
      Given I sign up with valid user data
      Then I should get the current location of users 
      And I should see a successful sign up message
    
    Scenario: User signs up with invalid email
      When I sign up with an invalid email
      Then I should see an invalid email message

    Scenario: User signs up with invalid password 
      When I sign up with an invalid password
      Then I should see an invalid password  message

    Scenario: User signs up with facebook
      Given I sign up with facebook
      And I get uid from facebook

    

   