require 'spec_helper'
require 'rudis/server'

describe 'Rudis', :acceptance do

  it 'respond to ping' do
    with_server do
      c = client
      c.without_reconnect do
        expect(c.ping).to eq("PONG")
        expect(c.ping).to eq("PONG")
      end
    end
  end

  it 'supports multiple clients simultaneously' do
    with_server do
      expect(client.echo("hello\nthere")).to eq("hello\nthere")
      expect(client.echo("hello\nthere")).to eq("hello\nthere")
    end
  end

  it 'echos messages' do
    with_server do
      expect(client.echo("hello\nthere")).to eq("hello\nthere")
    end
  end

  it 'gets and sets values' do
    with_server do
      expect(client.get("abc")).to eq(nil)
      expect(client.set("abc", "123")).to eq("OK")
      expect(client.get("abc")).to eq("123")
    end
  end

end