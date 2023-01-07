import { Given, Then, When } from '@badeball/cypress-cucumber-preprocessor';

import '../shared_steps';

Given(/^I go to home page/, () => {
  cy.visit('/');
});

Then(/^I should receive an email with a reset link/, () => {
  cy.appEval("ActionMailer::Base.deliveries.last.body.raw_source.lines[4].split('\"')[1]").then(($resetPasswordLink) => {
    expect($resetPasswordLink).to.contain(Cypress.config().baseUrl);
    expect($resetPasswordLink).to.match(/\/users\/password\/edit\?reset_password_token=.*/);
  });
});

Then(/^I click on password reset link/, () => {
  cy.appEval("ActionMailer::Base.deliveries.last.body.raw_source.lines[4].split('\"')[1]").then(($resetPasswordLink) => {
    cy.visit($resetPasswordLink);
  });
});

Then(/^I fill in password and password confirmation/, () => {
  cy.get('#user_password').fill('password1');
  cy.get('#user_password_confirmation').fill('password1');
});

Then(/^I should be on the home page/, () => {
  cy.get('h1').contains('My Journeys');
});
