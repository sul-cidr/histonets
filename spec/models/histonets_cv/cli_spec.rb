# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HistonetsCv::Cli, type: :model do
  describe '#help' do
    it 'returns help text' do
      expect(subject.help)
        .to match(/Usage: histonets \[OPTIONS\] COMMAND \[ARGS\]\.\.\./)
    end
  end
  describe '#version' do
    it 'returns version number' do
      expect(subject.version).to match(/histonets, version /)
    end
  end
end
