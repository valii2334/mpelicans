Feature: Create Journey Stop
  I want to create a journey stop

  Background:
    Given I am a confirmed user
    And I log in
    And I click on link "Start a New Journey"
    And I fill in journey information with
      | title            | description              | start_plus_code     | journey_image |
      | Going to Munchen | My first trip to Germany | QJ24+HG Cluj-Napoca | madrid.jpg    |
    When I click on input "Create"
    Then journey information should be
      | title            | description              | start_plus_code       | journey_image |
      | Going to Munchen | My first trip to Germany | QJ24%2BHG+Cluj-Napoca | madrid.jpg    |
    And link "Going to Munchen" is active in the sidebar

  Scenario: If a users enters correct journey stop information then we can create a journey stop
    Given I click on link "Make a Stop"
