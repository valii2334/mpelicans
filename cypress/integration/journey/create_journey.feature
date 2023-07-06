Feature: Create Journey
  I want to create a journey

  Background:
    Given I clean database
    And I stub current location
    And I am a confirmed user
    And I log in with "email"
    And I click on link "+ New Journey"

  Scenario: If a users enters correct journey information then we can create a journey
    Given I fill in journey information with
      | title            | description              | journey_image |
      | Going to Munchen | My first trip to Germany | madrid.jpg    |
    When I click on input "Create"
    Then journey information should be
      | title            | description              | journey_image |
      | Going to Munchen | My first trip to Germany | .jpg          |
