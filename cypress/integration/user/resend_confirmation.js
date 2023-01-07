import { Given, Then, When } from '@badeball/cypress-cucumber-preprocessor';

import '../shared_steps';

Given(/^I am an unconfirmed user/, () => {
  cy.appScenario('create_user');
});

Then(/^"([^"]*)" emails should have been delivered/, (numberOfEamils) => {
  cy.appEval('ActionMailer::Base.deliveries.count').then(($emailCount) => {
    expect($emailCount).to.eq(parseInt(numberOfEamils));
  });
});
