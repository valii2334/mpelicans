Feature: Resend confirmation
  I should be receive another confirmation email

  Background:
    Given I clean database

  Scenario: As a customer I want to be able to receive a second confirmation email
    Given I am an unconfirmed user
    And I go to home page
    And I go to log in page
    And I click on link "Didn't receive confirmation instructions?"
    And I fill input "#user_email" with user email
    When I click on input "Resend confirmation instructions"
    Then "2" emails should have been delivered
    And I click on confirmation link
    And I enter my email and password
    When I click on input "Log in"
    Then I should be on the home page
