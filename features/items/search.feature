Feature: Searching Items
  As a user
  I can serach for items by name, category, location
  
    Background:
      Given I am logged in 
      
    Scenario Outline: Searching Items
      When I Entered title with <Title>
      Then I Entered author with <Author>
      And I Entered location with <Location>
      Then I shold get related results

    Examples:
      | Title | Author   | Location  |
      | rails | dave     | bangalore |
      |       | dave     | bangalore |
      | rails |          | bangalore |
      | rails | dave     |           |
    
    