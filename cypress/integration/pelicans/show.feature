Feature: View travelers
  I want to be able to view travelers journeys

  Background:
    Given I clean database
    And I stub current location

  Scenario: As an unregistered user I can view a public journey
    Given a random user with "MP02" username has multiple journeys
      | title     | access_type       |
      | Journey 1 | public_journey    |
    When I visit "pelicans/MP02"
    Then I should see "Journey 1" in the page
    When I click on link "View Journey"
    Then I should see "Journey 1" details

  Scenario: As an unregistered user I can view only public and monetized journeys
    Given a random user with "MP02" username has multiple journeys
      | title     | access_type       |
      | Journey 1 | private_journey   |
      | Journey 2 | protected_journey |
      | Journey 3 | public_journey    |
      | Journey 4 | monetized_journey |
    When I visit "pelicans/MP02"
    Then I should see "Journey 3" in the page
    And I should see "Journey 4" in the page
    And I should not see "Journey 1" in the page
    And I should not see "Journey 2" in the page

  Scenario: As an unregistered user I can not view a monetized journey before paying
    Given a random user with "MP02" username has multiple journeys
      | title     | access_type          |
      | Journey 1 | monetized_journey    |
    When I visit "pelicans/MP02"
    Then I should see "Journey 1" in the page
    And I should not see "View Journey" in the page
    And I should see "Buy" in the page
    When I click on link "Buy"
    Then I should see "Sign up to share your journeys!" in the page

  Scenario: As a registered user I can buy another users monetized journey
    Given I am a confirmed user
    And I log in with "email"
    And a random user with "MP02" username has multiple journeys
      | title     | access_type          |
      | Journey 1 | monetized_journey    |
    When I visit "pelicans/MP02"
    Then I should see "Journey 1" in the page
    And I should see "Buy" in the page
    Given I stub stripe stripe to return a "success" for first "MP01" and journey "Journey 1"
    When I click on link "Buy"
    Then I should see "Journey 1" details
    When I click on link "Bought"
    Then I should see "Journey 1" in the page

  Scenario: As a registered user I can not buy another users monetized journey if my card is declined
    Given I am a confirmed user
    And I log in with "username"
    And a random user with "MP02" username has multiple journeys
      | title     | access_type          |
      | Journey 1 | monetized_journey    |
    When I visit "pelicans/MP02"
    Then I should see "Journey 1" in the page
    And I should see "Buy" in the page
    Given I stub stripe stripe to return a "error" for first "MP01" and journey "Journey 1"
    When I click on link "Buy"
    Then I should be on the home page