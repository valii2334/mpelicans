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
  cy.get('h1').contains('Journeys');
});

Then(/^I should be on the profile page/, () => {
  cy.get('h1').contains('Profile');
});

Then(/^I click on confirmation link/, () => {
  cy.appEval("ActionMailer::Base.deliveries.last.body.raw_source.lines[4].split('\"')[1]").then(($confirmationLink) => {
    cy.visit($confirmationLink);
  });
});

Then(/^I enter my email and password/, () => {
  cy.get('#user_email').fill(Cypress.env('userEmail'));
  cy.get('#user_password').fill(Cypress.env('userPassword'));
});

Then(/^I should see "([^"]*)" in the page/, (text) => {
  cy.contains(text);
});

Then(/^I should not see "([^"]*)" in the page/, (text) => {
  cy.contains(text).should('not.exist');
});

When(/^I visit "([^"]*)"/, (route) => {
  cy.visit(route);
});

Then(/^I should be on "([^"]*)" profile page/, (username) => {
  cy.get('#pelican-name').contains(username);
});
