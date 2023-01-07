describe('User can reset password', function () {
  beforeEach(() => {
    cy.app('clean');
  });

  it('resets password', function () {
    cy.appScenario('create_user');

    cy.visit('/');

    // We should see the Forgot your password? button
    cy.get('a').contains('Forgot your password?').click();

    // Fill informations
    cy.get('#user_email').fill(Cypress.env('userEmail'));

    // Click on Send me reset password instructions
    cy.get('input').contains('Send me reset password instructions').click();

    // Click on confirmation link in the email
    cy.appEval("ActionMailer::Base.deliveries.last.body.raw_source.lines[4].split('\"')[1]").then(($resetPasswordLink) => {
      cy.visit($resetPasswordLink);

      // Add new password
      cy.get('#user_password').fill('password1');
      cy.get('#user_password_confirmation').fill('password1');

      // We should see the Sign up button
      cy.get('input').contains('Change my password').click();

      // We are on the index page
      cy.get('h1').contains('My Journeys');
    });
  });
});
