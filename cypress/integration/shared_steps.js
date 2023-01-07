import { Given, Then, When } from '@badeball/cypress-cucumber-preprocessor';

Given(/^I am a confirmed user/, () => {
  cy.appScenario('create_user');
  cy.appScenario('confirm_last_user');
});

Given(/^I log in/, () => {
  cy.visit('/');

  // Fill informations
  cy.get('#user_email').fill(Cypress.env('userEmail'));
  cy.get('#user_password').fill(Cypress.env('userPassword'));

  // Click on Send me reset password instructions
  cy.get('input').contains('Log in').click();
});

Given(/^I click on link "([^"]*)"/, (textLink) => {
  cy.get('a').contains(textLink).click();
});

When(/^I click on input "([^"]*)"/, (textLink) => {
  cy.get('input').contains(textLink).click();
});

Given(/^I fill input "([^"]*)" with user email/, (inputName) => {
  cy.get(inputName).fill(Cypress.env('userEmail'));
});

Given(/^I go to home page/, () => {
  cy.visit('/');
});

Then(/^I should be on the home page/, () => {
  cy.get('h1').contains('My Journeys');
});
