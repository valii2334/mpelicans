Feature: Destroy Journey Stop
  I want to destroy a journey stop

  Background:
    Given I clean database
    And I stub current location
    And I am a confirmed user
    And I log in with "email"
    And I click on link "+ New Journey"
    And I fill in journey information with
      | title            | description              | journey_image |
      | Going to Munchen | My first trip to Germany | madrid.jpg    |
    When I click on button "Create"
    Then journey information should be
      | title            | description              | journey_image |
      | Going to Munchen | My first trip to Germany | .webp         |
    And I click on link "+ New Stop"
    Given I fill in journey stop information with
      | title               | description               | journey_stop_images |
      | My first stop title | My first stop description | madrid.jpg          |
    When I click on button "Create"
    Then I should see "My first stop title" in the page
    And I should see "My first stop description" in the page

  Scenario: If a users enters correct journey stop information then we can create a journey stop
    Given I go to home page
    And I click on link "Mine"
    And I click on link "View"
    And I should have a journey stop card
    Given I click on link "Delete Stop"
    Then I should not have a journey stop card
