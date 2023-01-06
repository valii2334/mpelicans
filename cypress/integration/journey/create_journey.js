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
