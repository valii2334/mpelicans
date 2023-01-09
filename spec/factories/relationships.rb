FactoryBot.define do
  factory :relationship do
    follower { create(:user) }
    followee { create(:user) }
  end
end
