Feature: Follow
  I want to be able to follow another user

  Background:
    Given I clean database

  Scenario: As a registered user I can follow another user
    Given I am a confirmed user
    And I log in
    And a random user with "MP02" username has multiple journeys
      | title     | access_type          |
      | Journey 1 | monetized_journey    |
    And I visit "pelicans"
    And I fill input "#pelicans_query_string" with "MP"
    And I click on input "Search"
    When I click on link "Follow"
    Then I should be on "MP02" profile page
    And I should see "You are now following MP02 across the world!" in the page
