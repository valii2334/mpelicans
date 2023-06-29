# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Retrievers::User do
  let!(:user_0) { create :user, username: 'VALENTINLAZAR' }
  let!(:user_1) { create :user, username: 'LAZARVALENTIN' }
  let!(:user_2) { create :user, username: 'ANDREEA' }

  describe '#fetch' do
    subject do
      described_class.new(query_string:).fetch
    end

    context 'query_string is empty' do
      let(:query_string) { nil }

      it 'returns all users' do
        expect(subject).to match_array([user_0, user_1, user_2])
      end
    end

    context 'query_string is not empty' do
      let(:query_string) { 'lazar' }

      it 'returns matching users' do
        expect(subject).to match_array([user_0, user_1])
      end
    end
  end
end