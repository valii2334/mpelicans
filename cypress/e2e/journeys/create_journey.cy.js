describe('User can create journey', function() {
  beforeEach(() => {
    cy.app('clean')
  })

  it('can reset password', function() {
    cy.appFactories([
      ['create', 'user', { password: 'password' }]
    ])
    cy.appEval("User.last.confirm");

    cy.visit('/');

    cy.appEval("User.last.email").then(($userEmail) => {
      // Fill informations
      cy.get('#user_email').fill($userEmail);
      cy.get('#user_password').fill('password');

      // Click on Send me reset password instructions
      cy.get('input').contains('Log in').click();

      // Click on Start a New Journey
      cy.get('a').contains('Start a New Journey').click();

      cy.get('#journey_title').fill('Going to Munchen');
      cy.get('#journey_description').fill('My first trip to Germany');
      cy.get('#journey_start_plus_code').fill('QJ24+HG Cluj-Napoca');
      cy.get('#journey_image').selectFile('./cypress/support/madrid.jpg');

      cy.get('input').contains('Create').click();

      // Check if we are on the journey page
      cy.contains('Going to Munchen');
      cy.contains('My first trip to Germany');

      // Check if journey is selected in the sidebar
      cy.get('li.sidebar-item.active').contains('Going to Munchen');
    })
  })
})
