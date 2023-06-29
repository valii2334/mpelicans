import { Given, Then, When } from '@badeball/cypress-cucumber-preprocessor';

Given(/^I clean database/, () => {
  cy.app('clean');
});

Given(/^I am a confirmed user/, () => {
  cy.appScenario('create_user');
  cy.appScenario('confirm_last_user');
});

Given(/^I go to log in page/, () => {
  cy.get('.main_pelican').click()
  cy.get('a').contains('Log in').click();
});

Given(/^I go to sign up page/, () => {
  cy.get('.main_pelican').click()
  cy.get('a').contains('Sign up').click();
});

Given(/^I log in with "([^"]*)"/, (loginAttribute) => {
  cy.visit('/');

  cy.get('.main_pelican').click()
  cy.get('a').contains('Log in').click();

  // Fill informations
  if(loginAttribute == "email") {
    cy.get('#user_login').fill(Cypress.env('userEmail'));
  } else {
    cy.get('#user_login').fill(Cypress.env('userUsername'));
  }
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

Given(/^I fill input "([^"]*)" with user email/, (inputName) => {
  cy.get(inputName).fill(Cypress.env('userEmail'));
});

Given(/^I go to home page/, () => {
  cy.visit('/');
});

Then(/^I should be on the home page/, () => {
  cy.get('h1').contains('Latest journeys');
});

Then(/^I should be on the profile page/, () => {
  cy.get('h1').contains('Profile');
});

Then(/^I click on confirmation link/, () => {
  cy.appEval("ActionMailer::Base.deliveries.last.body.raw_source.lines[4].split('\"')[1]").then(($confirmationLink) => {
    cy.visit($confirmationLink);
  });
});

Then(/^I should see "([^"]*)" in the page/, (text) => {
  cy.contains(text);
});

Then(/^I should not see "([^"]*)" in the page/, (text) => {
  cy.contains(text).should('not.exist');
});

When(/^I visit "([^"]*)"/, (route) => {
  cy.visit(route);
});

Then(/^I should be on "([^"]*)" profile page/, (username) => {
  cy.get('#pelican-name').contains(username);
});

Given(/^I stub current location/, () => {
  const latitude = '46.772952';
  const longitude = '23.625674';

  cy.appScenario('stub_google_api', { latitude: latitude, longitude: longitude });

  cy.on('window:before:load', (win) => {
    cy.stub(win.navigator.geolocation, "getCurrentPosition").callsFake((cb, err) => {
      if (latitude && longitude) {
        return cb({ coords: { latitude, longitude } });
      }
      throw err({ code: 1 });
    });
  });
});