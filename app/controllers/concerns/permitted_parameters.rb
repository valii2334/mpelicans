# frozen_string_literal: true

module PermittedParameters
  extend ActiveSupport::Concern

  def permitted_parameters(model:, permitted_parameters:)
    parameters = params.require(model).permit(
      permitted_parameters
    )
    parameters.merge(
      image_processing_status: :waiting,
      passed_images_count: (params[model][:images] || []).size
    )
  end
end
