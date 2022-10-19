describe('User can create journey', function() {
  beforeEach(() => {
    cy.app('clean')
  })

  it('creates a journey stop', function() {
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

      let journeyTitle = 'Going to Munchen'
      let journeyDescription = 'My first trip to Germany'
      let journeyStartPlusCode = 'QJ24+HG Cluj-Napoca'
      let journeyImage = './cypress/support/madrid.jpg'

      // Complete all journey info
      cy.get('#journey_title').fill(journeyTitle);
      cy.get('#journey_description').fill(journeyDescription);
      cy.get('#journey_start_plus_code').fill(journeyStartPlusCode);
      cy.get('#journey_image').selectFile(journeyImage);

      // Submit the new journey
      cy.get('input').contains('Create').click();

      // Check if we see all the info from above
      cy.contains(journeyTitle);
      cy.contains(journeyDescription);
      cy.get('#map-display').should('have.attr', 'src').should('include','QJ24%2BHG+Cluj-Napoca');
      cy.get('#first-picture').should('have.attr', 'src').should('include','madrid.jpg');

      // Check if journey is selected in the sidebar
      cy.get('li.sidebar-item.active').contains('Going to Munchen');
    })
  })
})
