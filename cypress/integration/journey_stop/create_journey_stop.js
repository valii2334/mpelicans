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
