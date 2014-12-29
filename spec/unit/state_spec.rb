require 'spec_helper'
require 'rudis/state'

describe Rudis::State, :unit do
  let(:state) { described_class.new }

  describe '#set' do
    it 'sets a value' do
      expect(state.set("abc", "123")).to eq(:ok)
      expect(state.get("abc")).to eq("123")
    end

    it 'does not overwrite an existing value with NX' do
      expect(state.set("abc", "123", "NX")).to eq(:ok)
      expect(state.set("abc", "456", "NX")).to eq(nil)
      expect(state.get("abc")).to eq("123")
    end
  end


end