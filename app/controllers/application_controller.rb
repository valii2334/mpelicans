# frozen_string_literal: true

# ApplicationController
class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  before_action do
    ActiveStorage::Current.url_options = { host: 'localhost:3000' } if Rails.env.test?
  end

  def current_ability
    @current_ability ||= Ability.new(current_user, params)
  end

  def success_message(message:)
    flash_message(message:, message_type: 'success')
  end

  def alert_message(message: 'There was a problem while processing your request.')
    flash_message(message:, message_type: 'danger')
  end

  private

  def flash_message(message:, message_type:)
    flash[:message] = message
    flash[:message_type] = message_type
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
  end
end
