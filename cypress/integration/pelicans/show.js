import { Given, Then, When } from '@badeball/cypress-cucumber-preprocessor';

import '../shared_steps';

Given(/^a random user with "([^"]*)" username has multiple journeys/, (username, datatable) => {
  const journeys = datatable.hashes();

  cy.appScenario('random_user_with_journeys', { username: username, journeys: journeys })
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

Given(/^I stub stripe stripe to return a "([^"]*)" for first "([^"]*)" and journey "([^"]*)"/, (stripeResponse, userName, journeyTitle) => {
  cy.appScenario('stub_stripe', { stripe_response: stripeResponse, user_name: userName, journey_title: journeyTitle })
});
