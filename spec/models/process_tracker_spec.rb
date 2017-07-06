# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProcessTracker do
  let(:collection_template) { create(:collection_template) }
  subject do
    create(
      :process_tracker,
      trackable_id: collection_template.id,
      trackable_type: 'CollectionTemplate'
    )
  end

  describe 'validations' do
    it do
      expect { subject.update!(status: 'bad') }
        .to raise_error ActiveRecord::RecordInvalid
    end
    it do
      [
        described_class::STATUS_ENQUEUED,
        described_class::STATUS_STARTED,
        described_class::STATUS_COMPLETED
      ].each do |status|
        expect(subject.update!(status: status)).to eq true
      end
    end
  end
  describe 'getters/setters' do
    it do
      subject.enqueued!
      expect(subject.enqueued?).to be true
    end
    it do
      subject.started!
      expect(subject.started?).to be true
    end
    it do
      subject.completed!
      expect(subject.completed?).to be true
    end
  end
end
