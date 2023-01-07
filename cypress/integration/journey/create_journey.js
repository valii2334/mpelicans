import { Given, Then, When } from '@badeball/cypress-cucumber-preprocessor';

import '../shared_steps';

Given(/^I fill in journey information with/, (datatable) => {
  const table = datatable.hashes();

  cy.get('#journey_title').fill(table[0].title);
  cy.get('#journey_description').fill(table[0].description);
  cy.get('#journey_start_plus_code').fill(table[0].start_plus_code);
  cy.get('#journey_image').selectFile('./cypress/support/' + table[0].journey_image);
});

Then(/^journey information should be/, (datatable) => {
  const table = datatable.hashes();

  cy.get('#journey-title').contains(table[0].title);
  cy.get('#journey-description').contains(table[0].description);
  cy.get('#journey-map-display').should('have.attr', 'src').should('include', table[0].start_plus_code);
  cy.get('#journey-first-picture').should('have.attr', 'src').should('include', table[0].journey_image);
});

Then(/^link "([^"]*)" is active in the sidebar/, (link) => {
  cy.get('li.sidebar-item.active').contains(link);
});