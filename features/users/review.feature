Feature: Sign up
  As a user
  I can review items, others
  And also upvote and downvote other users review
  I can also report abuse reviews and users

    Background:
      Given I am logged in 
      And I am in item display page

    Scenario: Adding review
      When I filled in my review in review textbox
      And I clicked Add button
      Then I should see my added review top of it
    
    Scenario: Up vote
      When I click on up button in displayed reviews
      Then I should see an increase in count in upvote
      And should not be able to upvote again

    Scenario: Down vote
      When I click on down button in displayed reviews
      Then I should see a decrease in count in downvote
      And should not be able to down vote again

    