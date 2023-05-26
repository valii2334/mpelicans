Feature: Update attributes
  I want to be able to update username, biography, image and password

  Background:
    Given I clean database

  Scenario: As a registered user I can update my username and biography
    Given I am a confirmed user
    And I log in
    And I click on link "Profile"
    And I fill input "#user_username" with "USERNAME"
    And I fill input "#user_biography" with "BIOGRAPHY"
    When I click on input "Save changes"
    Then I should see "USERNAME" in the page
    And I should see "BIOGRAPHY" in the page

  Scenario: As a registered user I can update my password
    Given I am a confirmed user
    And I log in
    And I click on link "Profile"
    And I click on link "Password"
    And I fill input "#user_password" with "NEW PASSWORD"
    And I fill input "#user_password_confirmation" with "NEW PASSWORD"
    When I click on input "Save password"
    Then I fill input "#user_email" with user email
    And I fill input "#user_password" with "NEW PASSWORD"
    And I click on input "Log in"
    Then I should be on the profile page
