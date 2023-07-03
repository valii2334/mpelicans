# frozen_string_literal: true

require 'rspec/mocks/standalone'

FactoryBot::SyntaxRunner.class_eval do
  include RSpec::Mocks::ExampleMethods
end
