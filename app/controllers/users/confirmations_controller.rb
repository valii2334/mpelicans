# frozen_string_literal: true

module Users
  class ConfirmationsController < Devise::ConfirmationsController
    include FlashMessagesConcern

    # GET /resource/confirmation/new
    # def new
    #   super
    # end

    # POST /resource/confirmation
    def create
      self.resource = resource_class.send_confirmation_instructions(resource_params)
      yield resource if block_given?

      if successfully_sent?(resource)
        success_message(
          message: I18n.t('devise.confirmations.send_paranoid_instructions')
        )

        respond_with({}, location: after_resending_confirmation_instructions_path_for(resource_name))
      else
        respond_with(resource)
      end
    end

    # GET /resource/confirmation?confirmation_token=abcdef
    def show
      super do
        sign_in(resource) if resource.errors.empty?
      end
    end

    # protected

    # The path used after resending confirmation instructions.
    # def after_resending_confirmation_instructions_path_for(resource_name)
    #   super(resource_name)
    # end

    # The path used after confirmation.
    # def after_confirmation_path_for(resource_name, resource)
    #   super(resource_name, resource)
    # end
  end
end
