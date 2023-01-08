Feature: View travelers
  I want to be able to view travelers journeys

  Scenario: As an unregistered user I can view only public and monetized journeys
    Given I am a confirmed user
    And I have multiple journeys
      | title     | access_type       |
      | Journey 1 | private_journey   |
      | Journey 2 | protected_journey |
      | Journey 3 | public_journey    |
      | Journey 4 | monetized_journey |
    When I visit last users show page
    Then I should see "Journey 3" in the page
    And I should see "Journey 4" in the page
    And I should not see "Journey 1" in the page
    And I should not see "Journey 2" in the page

  Scenario: As an unregistered user I can view a public journey
    Given I am a confirmed user
    And I have multiple journeys
      | title     | access_type       |
      | Journey 1 | public_journey    |
    When I visit last users show page
    Then I should see "Journey 1" in the page
    When I click on link "View Journey"
    Then I should see "Journey 1" details
