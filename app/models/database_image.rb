# frozen_string_literal: true

class DatabaseImage < ApplicationRecord
  validates :data, :file_extension, presence: true
end
