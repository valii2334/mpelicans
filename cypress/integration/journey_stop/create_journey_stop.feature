Feature: Create Journey Stop
  I want to create a journey stop

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

  Scenario: If a users enters correct journey stop information then we can create a journey stop
    Given I fill in journey stop information with
      | title               | description               | journey_stop_images |
      | My first stop title | My first stop description | madrid.jpg          |
    When I click on button "Create"
    Then I should see "My first stop title" in the page
    And I should see "My first stop description" in the page

  Scenario: A user can not submit a journey stop with more than 5 images
    Given I fill in journey stop information with
      | title               | description               | journey_stop_images                                                    |
      | My first stop title | My first stop description | madrid.jpg,madrid1.png,madrid2.png,madrid3.png,madrid4.png,madrid5.png |
    When I click on button "Create"
    Then I should see "can't post more than 5" in the page
