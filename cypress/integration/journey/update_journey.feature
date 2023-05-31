Feature: Update Journey
  I want to update a journey

  Background:
    Given I clean database
    And I stub current location
    And I am a confirmed user
    And I log in
    And I click on link "+ New Journey"
    Given I fill in journey information with
      | title            | description              | journey_image |
      | Going to Munchen | My first trip to Germany | madrid.jpg    |
    When I click on input "Create"
    Then journey information should be
      | title            | description              | start_plus_code | journey_image |
      | Going to Munchen | My first trip to Germany | 8GR5QJFG%2B57M  | madrid.jpg    |
    And link "All Journeys" is active in the sidebar

  Scenario: A user can change a journey from private to protected and back
    Given I go to home page
    And I click on link "All Journeys"
    And I click on link "View Journey"
    When I click on link "Protected"
    Then I should see journey private link in the page
