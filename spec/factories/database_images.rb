# frozen_string_literal: true

FactoryBot.define do
  factory :database_image do
    data           { File.binread('spec/fixtures/files/lasvegas.jpg') }
    file_extension { '.jpg' }
  end
end
