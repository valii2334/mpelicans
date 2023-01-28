# frozen_string_literal: true

user = FactoryBot.create(:user, password: 'password', email: 'example@email.com', username: 'MP01')
user.confirmed_at = nil
user.save
