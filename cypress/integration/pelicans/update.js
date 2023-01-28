import { Given, Then, When } from '@badeball/cypress-cucumber-preprocessor';

import '../shared_steps';

Given(/^I fill input "([^"]*)" with "([^"]*)"/, (input, data) => {
  cy.get(input).fill(data);
});
