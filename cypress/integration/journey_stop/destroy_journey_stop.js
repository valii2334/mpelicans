import { Given, Then, When } from '@badeball/cypress-cucumber-preprocessor';

import '../shared_steps';
import './create_journey_stop';

Then(/^I should not have a journey stop card/, () => {
  cy.get('.journey-stop-card').should('not.exist');
});

Then(/^I should have a journey stop card/, () => {
  cy.get('.journey-stop-card').should('exist');
});
