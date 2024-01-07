import { Given, Then, When } from '@badeball/cypress-cucumber-preprocessor';

import '../shared_steps';

Given(/^I fill in journey information with/, (datatable) => {
  const table = datatable.hashes();

  cy.get('#journey_title').fill(table[0].title);
  cy.get('#journey_description').fill(table[0].description);
  cy.get('#journey_images').selectFile('./cypress/support/' + table[0].journey_image);
});

Then(/^journey information should be/, (datatable) => {
  const table = datatable.hashes();

  cy.contains(table[0].title);
  cy.contains(table[0].description);
});
