Feature: Create Journey
  I want to create a journey

  Background:
    Given I clean database
    And I am a confirmed user
    And I log in
    And I click on link "+ New Journey"

  Scenario: If a users enters correct journey information then we can create a journey
    Given I fill in journey information with
      | title            | description              | journey_image |
      | Going to Munchen | My first trip to Germany | madrid.jpg    |
    When I click on input "Create"
    Then journey information should be
      | title            | description              | start_plus_code  | journey_image |
      | Going to Munchen | My first trip to Germany | 8GR5QJFG%2B57M   | madrid.jpg    |
    And link "All Journeys" is active in the sidebar
