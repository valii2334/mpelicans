describe('User receive another confirmation link', function () {
  beforeEach(() => {
    cy.app('clean');
  });

  it('resends confirmation link', function () {
    cy.appScenario('create_unconfirmed_user');

    cy.visit('/');

    // We should see the Sign up button
    cy.get('a').contains("Didn't receive confirmation instructions?").click();

    // Fill informations
    cy.get('#user_email').fill(Cypress.env('userEmail'));

    // Click on Resend confirmation instructions
    cy.get('input').contains('Resend confirmation instructions').click();

    cy.appEval('ActionMailer::Base.deliveries.count').then(($emailCount) => {
      expect($emailCount).to.eq(2);
    });

    // Click on confirmation link in the email
    cy.appEval("ActionMailer::Base.deliveries.last.body.raw_source.lines[4].split('\"')[1]").then(($confirmationLink) => {
      cy.visit($confirmationLink);

      // Input email
      cy.get('#user_email').fill(Cypress.env('userEmail'));
      // Input password
      cy.get('#user_password').fill(Cypress.env('userPassword'));

      // We should see the Log in button
      cy.get('input').contains('Log in').click();

      // We are on the index page
      cy.get('h1').contains('My Journeys');
    });
  });
});
