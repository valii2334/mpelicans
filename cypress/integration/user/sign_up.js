import { Given, Then, When } from '@badeball/cypress-cucumber-preprocessor';

import '../shared_steps';

Given(/^I fill in user informations/, () => {
  cy.get('#user_email').fill(Cypress.env('userEmail'));
  cy.get('#user_username').fill(Cypress.env('userUsername'));
  cy.get('#user_password').fill(Cypress.env('userPassword'));
  cy.get('#user_password_confirmation').fill(Cypress.env('userPassword'));
});
