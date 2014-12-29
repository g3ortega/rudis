require 'spec_helper'

describe 'Rudis', :acceptance do
  it 'supports hashes' do
    with_server do
      client.hset("mihash", "abc", "123")
      client.hset("mihash", "def", "456")
      expect(client.hmget("mihash", "abc", "def")).to eq(["123", "456"])
    end

  end
end