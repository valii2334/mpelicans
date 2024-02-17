# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch('SUPPORT_EMAIL')
  layout 'mailer'
end
