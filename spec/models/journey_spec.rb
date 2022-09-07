require 'rails_helper'

RSpec.describe Journey, type: :model do
  let(:journey) { build(:journey) }
  subject { journey }

  ##################################
  # Attribute existence
  ##################################

  it { should have_attribute :title }
  it { should have_attribute :description }
  it { should have_attribute :start_plus_code }
  it { should have_attribute :status }
  it { should have_attribute :access_type }
  it { should have_attribute :accepts_recommendations }
  it { should have_attribute :user_id }
  it { should have_attribute :access_code }

  ##################################
  # Validations
  ##################################

  it { should validate_presence_of :title }
  it { should validate_presence_of :description }
  it { should validate_presence_of :start_plus_code }

  ##################################
  # Associations
  ##################################

  it { should belong_to(:user) }

  ##################################
  # Callbacks
  ##################################

  context '#add_access_code' do
    it 'adds an access code' do
      user = create(:user)
      journey = Journey.create(title: 'Journey', description: 'First Journey', start_plus_code: '123456', user: user)

      expect(journey.access_code).to_not be_nil
    end
  end
end
