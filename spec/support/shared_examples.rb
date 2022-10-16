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
