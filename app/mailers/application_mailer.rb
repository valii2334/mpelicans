# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'support@mpelicans.com'
  layout 'mailer'
end
