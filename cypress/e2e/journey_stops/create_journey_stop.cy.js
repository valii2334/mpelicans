describe('User can create journey', function() {
  beforeEach(() => {
    cy.app('clean')
  })

  it('can reset password', function() {
    // Create user
    cy.appFactories([
      ['create', 'user', { password: 'password' }]
    ]).then((records) => {
      // Create a journey
      cy.appFactories([
        ['create', 'journey', { user_id: records[0].id }]
      ])
    })

    // Confirm user
    cy.appEval("User.last.confirm");

    cy.visit('/');

    cy.appEval("User.last.email").then(($userEmail) => {
      // Fill informations
      cy.get('#user_email').fill($userEmail);
      cy.get('#user_password').fill('password');

      // Click on Send me reset password instructions
      cy.get('input').contains('Log in').click();

      // Click on View Journey
      cy.get('a').contains('View Journey').click();

      // Click on Make a Stop
      cy.get('a').contains('Make a Stop').click();

      // Check if journey is selected in the sidebar
      cy.appEval("User.last.journeys.last.title").then(($journeyTitle) => {
        cy.get('li.sidebar-item.active').contains($journeyTitle);
      })

      let stopTitle = 'My first stop title';
      let stopDescription = 'My first stop description';
      let stopPlusCode = 'QJ24+HG Cluj-Napoca';
      let stopPicture = 'madrid.jpg';

      // Complete all journey stop info
      cy.get('#journey_stop_title').fill(stopTitle);
      cy.get('#journey_stop_description').fill(stopDescription);
      cy.get('#journey_stop_plus_code').fill(stopPlusCode);
      cy.get('#journey_stop_images').selectFile('./cypress/support/' + stopPicture);

      // Submit the journey stop
      cy.get('input').contains('Create').click();

      cy.get('.title.journey-stop-0').contains(stopTitle);
      cy.get('.description.journey-stop-0').contains(stopDescription);
      cy.get('.location.journey-stop-0').should('have.attr', 'href').should('include', stopPlusCode);
      cy.get('.image.journey-stop-0').should('have.attr', 'src').should('include', stopPicture);
    })
  })
})
