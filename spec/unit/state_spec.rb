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

    it 'does not overwrite an existing value with XX' do
      expect(state.set("abc", "123", "XX")).to eq(nil)
      state.set("abc", "123")
      expect(state.set("abc", "456", "XX")).to eq(:ok)
      expect(state.get("abc")).to eq("456")
    end
  end


end