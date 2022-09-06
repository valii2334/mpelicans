class ApplicationMailer < ActionMailer::Base
  default from: "support@mpelicans.com"
  host "meplicans.com"
  layout "mailer"
end
