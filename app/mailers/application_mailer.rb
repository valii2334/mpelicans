# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: SUPPORT_EMAIL
  layout 'mailer'
end
