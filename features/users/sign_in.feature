Feature: Sign in
  In order use the features of the site 
  A user
  Should be able to sign in

    Scenario: User is not signed up or enters wrong details
      Given I do not exist as a user or entered wrong details
      When I sign in with valid credentials
      Then I should be redirected to login page
      And I should see invalid login message

    Scenario: User signs in successfully
      Given I exist as a user
      And I am not logged in
      When I sign in with valid credentials
      Then I should be redirected to serach items page
      And I should be signed in
      



      