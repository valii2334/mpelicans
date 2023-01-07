import { Given, Then, When } from '@badeball/cypress-cucumber-preprocessor';

import '../shared_steps';

Given(/^I fill in user informations/, () => {
  cy.get('#user_email').fill(Cypress.env('userEmail'));
  cy.get('#user_password').fill(Cypress.env('userPassword'));
  cy.get('#user_password_confirmation').fill(Cypress.env('userPassword'));
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
