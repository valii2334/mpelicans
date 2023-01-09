# frozen_string_literal: true

FactoryBot.define do
  factory :relationship do
    follower { create(:user) }
    followee { create(:user) }
  end
end
