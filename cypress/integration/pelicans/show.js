import { Given, Then, When } from '@badeball/cypress-cucumber-preprocessor';

import '../shared_steps';

Given(/^I have multiple journeys/, (datatable) => {
  const journeys = datatable.hashes();

  journeys.forEach(journey => {
    cy.appScenario('create_journey', { title: journey.title, access_type: journey.access_type })
  })
});

Given(/^I visit last users show page/, () => {
  cy.appEval('User.last.username').then(($userName) => {
    cy.visit('/pelicans/' + $userName);
  });
});

Then(/^I should see "([^"]*)" details/, (journeyTitle) => {
  cy.appScenario('journey_attributes', { journey_title: journeyTitle }).then(($journeyAttributes) => {
    cy.get('#journey-title').contains($journeyAttributes.title);
    cy.get('#journey-description').contains($journeyAttributes.description);
  });
});
