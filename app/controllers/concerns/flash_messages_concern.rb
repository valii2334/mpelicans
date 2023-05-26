# frozen_string_literal: true

module FlashMessagesConcern
  extend ActiveSupport::Concern

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
end
