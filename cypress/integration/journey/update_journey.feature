Feature: Update Journey
  I want to update a journey

  Background:
    Given I am a confirmed user
    And I log in
    And I click on link "Start a New Journey"
    Given I fill in journey information with
      | title            | description              | start_plus_code     | journey_image |
      | Going to Munchen | My first trip to Germany | QJ24+HG Cluj-Napoca | madrid.jpg    |
    When I click on input "Create"
    Then journey information should be
      | title            | description              | start_plus_code       | journey_image |
      | Going to Munchen | My first trip to Germany | QJ24%2BHG+Cluj-Napoca | madrid.jpg    |
    And link "Going to Munchen" is active in the sidebar

  Scenario: A user can change a journey from private to protected and back
    Given I go to home page
    And I click on link "Going to Munchen"
    When I click on link "Make your journey protected"
    Then I should see journey private link in the page
