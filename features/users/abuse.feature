Feature: Sign up
  As a user
  I can report abuse on users
 
   Background:
     Given I am logged in 

   Scenario: User report abuse
     Given i am in users page
     Then I can report abuse on user 
     And admin should get notification about it

   