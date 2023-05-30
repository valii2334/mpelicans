// CypressOnRails: dont remove these command
Cypress.Commands.add('appCommands', function (body) {
  Object.keys(body).forEach(key => body[key] === undefined ? delete body[key] : {});
  const log = Cypress.log({ name: 'APP', message: body, autoEnd: false });
  return cy.request({
    method: 'POST',
    url: '/__cypress__/command',
    body: JSON.stringify(body),
    log: false,
    failOnStatusCode: false
  }).then((response) => {
    log.end();
    if (response.status !== 201) {
      expect(response.body.message).to.equal('');
      expect(response.status).to.be.equal(201);
    }
    return response.body;
  });
});

Cypress.Commands.add('app', function (name, command_options) {
  return cy.appCommands({ name: name, options: command_options }).then((body) => {
    return body[0];
  });
});

Cypress.Commands.add('appScenario', function (name, options = {}) {
  return cy.app('scenarios/' + name, options);
});

Cypress.Commands.add('appEval', function (code) {
  return cy.app('eval', code);
});

Cypress.Commands.add('appFactories', function (options) {
  return cy.app('factory_bot', options);
});

Cypress.Commands.add('appFixtures', function (options) {
  cy.app('activerecord_fixtures', options);
});
// CypressOnRails: end

Cypress.on('uncaught:exception', (err, runnable) => {
  return false;
});

beforeEach(() => {
  cy.appScenario('stub_google_api');

  cy.on('window:before:load', (win) => {
    cy.stub(win.navigator.geolocation, "getCurrentPosition").callsFake((cb, err) => {
      if (latitude && longitude) {
        return cb({ coords: { latitude, longitude } });
      }
      throw err({ code: 1 });
    });
  });
})

// comment this out if you do not want to attempt to log additional info on test fail
Cypress.on('fail', (err, runnable) => {
  // allow app to generate additional logging data
  Cypress.$.ajax({
    url: '/__cypress__/command',
    data: JSON.stringify({ name: 'log_fail', options: { error_message: err.message, runnable_full_title: runnable.fullTitle() } }),
    async: false,
    method: 'POST'
  });

  throw err;
});
