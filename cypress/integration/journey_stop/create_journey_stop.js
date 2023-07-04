import { Given, Then, When } from '@badeball/cypress-cucumber-preprocessor';

import '../shared_steps';
import '../journey/create_journey';

Given(/^I fill in journey stop information with/, (datatable) => {
  const table = datatable.hashes();

  cy.get('#journey_stop_title').fill(table[0].title);
  cy.get('#journey_stop_description').fill(table[0].description);

  const imagesArray       = table[0].journey_stop_images.split(',');
  const imagesPathsArrays = [];

  imagesArray.forEach(element => imagesPathsArrays.push('./cypress/support/' + element));

  cy.get('#journey_stop_images').selectFile(imagesPathsArrays);
});

Then(/^journey stop information should be/, (datatable) => {
  const table = datatable.hashes();

  cy.get('#journey-stop-title').contains(table[0].title);
  cy.get('#journey-stop-description').contains(table[0].description);
  cy.get('#journey-stop-image-0').should('have.attr', 'src').should('include', table[0].journey_stop_image);
});

Then(/^journey stop card should contain/, (datatable) => {
  const table = datatable.hashes();

  cy.get('.title.journey-stop-0').contains(table[0].title);
  cy.get('.image.journey-stop-0').should('have.attr', 'src').should('include', table[0].journey_stop_image);
});
