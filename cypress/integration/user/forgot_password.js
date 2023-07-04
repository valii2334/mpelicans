import { Given, Then, When } from '@badeball/cypress-cucumber-preprocessor';

import '../shared_steps';

Then(/^I click on password reset link/, () => {
  cy.appEval("ActionMailer::Base.deliveries.last.body.raw_source.lines[4].split('\"')[1]").then(($resetPasswordLink) => {
    cy.visit($resetPasswordLink);
  });
});

Then(/^I fill in password and password confirmation/, () => {
  cy.get('#user_password').fill('password1');
  cy.get('#user_password_confirmation').fill('password1');
});
