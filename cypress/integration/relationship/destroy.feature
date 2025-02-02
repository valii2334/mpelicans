Feature: Unfollow
  I want to be able to unfollow a followed user

  Background:
    Given I clean database

  Scenario: As a registered user I can unfollow another user
    Given I am a confirmed user
    And I log in with "username"
    And a random user with "MP02" username has multiple journeys
      | title     | access_type          |
      | Journey 1 | monetized_journey    |
    And I visit "pelicans"
    And I fill input "#pelicans_query_string" with "MP"
    And I click on input "Search"
    When I click on link "Follow"
    Then I should be on "MP02" profile page
    And I should see "You are now following MP02 across the world!" in the page
    When I click on link "Unfollow"
    Then I should see "You are no longer following MP02." in the page
