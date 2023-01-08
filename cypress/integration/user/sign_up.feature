Feature: Sign up
  I should be able to create an account

  Scenario: As a customer I want to be able to sign up
    Given I go to home page
    And I click on link "Sign up"
    And I fill in user informations
      | email             | username | password | password_confirmation |
      | example@email.com | MP01     | password | password              |
    When I click on input "Sign up"
    Then I click on confirmation link
    And I enter my email and password
    And I click on input "Log in"
    Then I should be on the home page

  Scenario: As a customer I will see an error if I enter a username containing white spaces
  Given I go to home page
  And I click on link "Sign up"
  And I fill in user informations
    | email             | username | password | password_confirmation |
    | example@email.com | MP 01    | password | password              |
  When I click on input "Sign up"
  Then I should see "Username can not contain white spaces" in the page
