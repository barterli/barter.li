Feature: Admin Setting Status And Moderating
  As a admin user
  I can see statistics of
  Total No of Users and users statistics
  Total No of Items and items statistics
  can search top browsed items
  can search items with most spent time
  can search for top searched text
  


  

    Background:
      Given I am logged in as admin

    Scenario: User statics
      I see list of all registered users
      And when I click on a user
      Then i see his barted items, browsed items, location history
      And also user searched terms


    Scenario: Item statics
      I see list of all items
      And when I click on a item
      Then i see no of views of items
      And users who browsed it
      Then also see no of reviews it has



    Scenario: Top Item Browsed 
      I can search for top items with specified numbers 
      Then I see list of items
      And when I click on a item
      Then i see no of views 
      And users who browsed it
      Then also see no of reviews it has



    Scenario: Top Item Watched
      I can search for top watched items with specified numbers 
      Then I see list of items
      And when I click on a item
      Then i see no of views 
      And users who browsed it
      Then also see no of reviews it has



    Scenario: Top serached text
      I can search for top serached text with specified numbers 
      Then I see list of searched text

