Feature: Admin Setting Status And Moderating
  As a admin user
  I can disable users
  I can moderate reviews

    Background:
      Given I am logged in as admin

    Scenario: Admin disable users
      Given I am in user listing page
      when I  disable users
      Then A user can't be able to login
  
    
    Scenario: Admin moderetes item reviews
      Given I am in items page
      Then I see options for moderating review
      And I can disable a review
      Then users cant see it


    Scenario: Admin moderetes users reviews
      Given I am in users page
      Then I see options for moderating review
      And I can disable a review
      Then users cant see it