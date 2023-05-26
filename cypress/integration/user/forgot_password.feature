Feature: Forgot Password
  I want to be able to reset my password

  Background:
    Given I clean database

  Scenario: As a registered user I want to reset my password
    Given I am a confirmed user
    And I go to home page
    And I click on link "Forgot your password?"
    And I fill input "#user_email" with user email
    When I click on input "Send me reset password instructions"
    Then I should receive an email with a reset link
    And I click on password reset link
    And I fill in password and password confirmation
    And I click on input "Change my password"
    Then I should be on the home page
