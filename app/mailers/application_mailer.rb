# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'support@migrating-pelicans.com'
  layout 'mailer'
end
