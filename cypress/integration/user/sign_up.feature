Feature: Sign up
  I should be able to create an account

  Scenario: As a customer I want to be able to sign up
  Given I go to home page
  And I click on link "Sign up"
  And I fill in user informations
  When I click on input "Sign up"
  Then I click on confirmation link
  And I enter my email and password
  And I click on input "Log in"
  Then I should be on the home page
