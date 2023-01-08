import { Given, Then, When } from '@badeball/cypress-cucumber-preprocessor';

import './create_journey';
import '../shared_steps';

Then(/^I should see journey private link in the page/, () => {
  cy.appScenario('journey_access_code').then(($accessCode) => {
    cy.get('.private_link').should('have.attr', 'href', Cypress.config().baseUrl + '/watch_journeys/' + $accessCode)
  });
});