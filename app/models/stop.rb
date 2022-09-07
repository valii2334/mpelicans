class Stop < ApplicationRecord
  belongs_to :journey

  validates :title, :description, :plus_code, presence: true
end
