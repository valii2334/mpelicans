const { defineConfig } = require('cypress');
const webpack = require('@cypress/webpack-preprocessor');
const { addCucumberPreprocessorPlugin } = require('@badeball/cypress-cucumber-preprocessor');

async function setupNodeEvents (on, config) {
  await addCucumberPreprocessorPlugin(on, config);

  on(
    'file:preprocessor',
    webpack({
      webpackOptions: {
        resolve: {
          extensions: ['.ts', '.js']
        },
        module: {
          rules: [
            {
              test: /\.ts$/,
              exclude: [/node_modules/],
              use: [
                {
                  loader: 'ts-loader'
                }
              ]
            },
            {
              test: /\.feature/,
              use: [
                {
                  loader: '@badeball/cypress-cucumber-preprocessor/webpack',
                  options: config
                }
              ]
            }
          ]
        }
      }
    })
  )

  return config;
}


module.exports = defineConfig({
  projectId: "ey2w85",
  e2e: {
    baseUrl: "http://localhost:3000",
    defaultCommandTimeout: 10000,
    supportFile: "cypress/support/index.js",
    specPattern: "cypress/integration/**/*.feature",
    video: false,
    setupNodeEvents
  },
  env: {
    userEmail: 'example@email.com',
    userPassword: 'password',
    userUsername: 'MP01'
  }
})
