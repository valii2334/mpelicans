describe('User can create an account', function() {
  beforeEach(() => {
    cy.app('clean')
  })

  it('creates an account', function() {
    cy.visit('/')

    // We should be on Log in page
    cy.contains('Log in');

    // We should see the Sign up button
    cy.get('a').contains('Sign up').click();

    // Fill informations
    cy.get('#user_email').fill(Cypress.env('userEmail'));
    cy.get('#user_password').fill(Cypress.env('userPassword'));
    cy.get('#user_password_confirmation').fill(Cypress.env('userPassword'));

    // Click on Sign up
    cy.get('input').contains('Sign up').click();

    // We are redirected to Log in
    cy.contains('Log in');

    // Click on confirmation link in the email
    cy.appEval('ActionMailer::Base.deliveries.last.body.raw_source').then(($mailBody) => {
      cy.appEval('User.last.confirmation_token').then(($confirmationToken) => {
        expect($mailBody).to.contain(
          'http://localhost:3000/users/confirmation?confirmation_token=' + $confirmationToken
        );

        cy.visit('http://localhost:3000/users/confirmation?confirmation_token=' + $confirmationToken);

        // Fill informations
        cy.get('#user_email').fill(Cypress.env('userEmail'));
        cy.get('#user_password').fill(Cypress.env('userPassword'));

        // Log in
        cy.get('input').contains('Log in').click();

        // We are on the index page
        cy.get('h1').contains('My Journeys');
      })
    })
  })
})
