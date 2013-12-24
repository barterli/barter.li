Feature: Searching Items
  As a user
  I can serach for items by name, category, location
  
    Background:
      Given I am logged in 
      
    Scenario Outline: Searching Items
      When I Entered title with <Title>
      Then I Entered category with <Category>
      And I Entered location with <Location>
      Then I shold get related results

    Examples:
      | Title | Category | Location  |
      | rails | book     | bangalore |
      |       | book     | bangalore |
      | rails |          | bangalore |
      | rails | book     |           |
    
    