Feature: Calendars
  In order to meet up with her friends more easily
  Susan maintains an aggregate calendar on DayMash.
  
  Scenario: view my calendars
    Given I am signed in as Susan
    When I go to the home page
    When I follow "My Calendars"
    Then I should be on my calendars page

  Scenario: add a calendar
    Given I am signed in as Susan
    And I am on my calendars page
    When I follow "Add Calendar"
    And I fill in "URL" with "http://caledars.example.org/me"
    And I fill in "Title" with "My Example Calendar"
    And I press "Feed Me"
    Then I should be on my calendars page
    And I should see "My Example Calendar"