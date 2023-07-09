# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ImagesProcessors::Base do
  context '#run' do
    subject { described_class.new }

    before do
      allow(subject).to receive(:run_processor).and_return(true)
      allow(subject).to receive(:enque_next_steps).and_return(true)
    end

    it 'executes run_processor, enque_next_steps' do
      expect(subject).to receive(:run_processor)
      expect(subject).to receive(:enque_next_steps)

      subject.run
    end
  end
end
