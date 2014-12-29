require 'redis'

require 'socket'
require 'timeout'
require 'rudis/server'

TEST_PORT = 6380

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

  def client
    Redis.new(host: 'localhost', port: TEST_PORT)
  end

  def with_server
    server_thread = Thread.new do
      server = Rudis::Server.new(TEST_PORT)
      server.listen
    end

  wait_for_open_port TEST_PORT

  yield
  rescue TimeoutError
      sleep 0.01
      server_thread.value unless server_thread.alive?
      raise
    ensure
      Thread.kill(server_thread) if server_thread
  end

  def wait_for_open_port(port)
    time = Time.now
    while !check_port(port) && 1 > Time.now - time
      sleep 0.01
    end

    raise TimeoutError unless check_port(port)
  end

  def check_port(port)
    begin
      Timeout::timeout(1) do
        begin
          s = TCPSocket.new('localhost', port)
          s.close
          return true
        rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH
          return false
        end
      end
    rescue Timeout::Error
    end

    return false
  end

end