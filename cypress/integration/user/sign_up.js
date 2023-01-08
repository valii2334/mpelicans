import { Given, Then, When } from '@badeball/cypress-cucumber-preprocessor';

import '../shared_steps';

Given(/^I fill in user informations/, (datatable) => {
  const table = datatable.hashes();

  cy.get('#user_email').fill(table[0].email);
  cy.get('#user_username').fill(table[0].username);
  cy.get('#user_password').fill(table[0].password);
  cy.get('#user_password_confirmation').fill(table[0].password_confirmation);
});
