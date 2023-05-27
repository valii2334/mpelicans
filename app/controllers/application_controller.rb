# frozen_string_literal: true

# ApplicationController
class ApplicationController < ActionController::Base
  include FlashMessagesConcern

  before_action :configure_permitted_parameters, if: :devise_controller?

  before_action do
    ActiveStorage::Current.url_options = { host: 'localhost:3000' } if Rails.env.test?
  end

  rescue_from StandardError do |exception|
    redirect_to root_path
  end

  def current_ability
    @current_ability ||= Ability.new(current_user, params)
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
  end
end
