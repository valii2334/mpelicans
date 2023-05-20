# frozen_string_literal: true

require 'set'

RSpec.shared_examples 'missing parameter' do |model, attribute|
  it 'renders new' do
    expect(subject).to render_template(:new)
  end

  it "does not create a #{model.name}" do
    expect do
      subject
    end.to change { model.count }.by(0)
  end

  it "does include missing attribute message #{attribute}" do
    expect(CGI.unescapeHTML(subject.body)).to include("#{attribute} can't be blank")
  end
end

RSpec.shared_examples 'can view page' do
  it 'status code 200' do
    subject

    expect(response.status).to eq(200)
  end
end

RSpec.shared_examples 'can not view page' do
  it 'raises an error' do
    expect do
      subject
    end.to raise_error(CanCan::AccessDenied)
  end
end

RSpec.shared_context 'bought_journey set up' do
  let(:notification_type) { :bought_journey }

  subject do
    Notifier.new(journey_id: journey.id, notification_type:, sender_id: sender.id).notify
  end
end

RSpec.shared_context 'new_journey set up' do
  let(:notification_type) { :new_journey }

  let(:user1) { create :user }
  let(:user2) { create :user }
  let(:user3) { create :user }

  let!(:follower1) { create(:relationship, follower: user1,        followee: journey.user) }
  let!(:follower2) { create(:relationship, follower: user2,        followee: journey.user) }
  let!(:followee)  { create(:relationship, follower: journey.user, followee: user3) }

  subject do
    Notifier.new(journey_id: journey.id, notification_type:, sender_id: journey.user.id).notify
  end
end

RSpec.shared_context 'new_journey_stop set up' do
  let(:notification_type) { :new_journey_stop }

  let(:user1) { create :user }
  let(:user2) { create :user }
  let(:user3) { create :user }

  let!(:follower1) { create(:relationship, follower: user1,        followee: journey.user) }
  let!(:follower2) { create(:relationship, follower: user2,        followee: journey.user) }
  let!(:followee)  { create(:relationship, follower: journey.user, followee: user3) }

  # user3 does not follow journey.user but purchased this journey
  let!(:paid_journey) { create(:paid_journey, user: user3, journey:) }

  # last journey stop in order to be able to create the notification
  let!(:journey_stop) { create(:journey_stop, journey:) }

  subject do
    Notifier.new(journey_id: journey.id, notification_type:, sender_id: journey.user.id).notify
  end
end
