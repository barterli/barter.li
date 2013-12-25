Feature: Admin Report Abuse Notices
  As a admin user
  I get notifications of report abuses by user
  
    Background:
      Given I am logged in as admin

    Scenario: User report abuses
      Given I am user report abuses page
      Then I see users reported as abuses
      And I can disable a user
      Then user cant login

    Scenario: User report abuses
      Given I am user report abuses page
      Then I see users reported as abuses
      And I can reject the abuse report
      Then the report gets deleted
  
    