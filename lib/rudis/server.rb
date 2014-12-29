require "socket"

module Rudis
  class Server

    def initialize(port)
      @port = port
    end

    def listen
      readable = []
      server = TCPServer.new(port)
      readable << server
      loop do
        ready_to_read, _ = IO.select(readable)

        ready_to_read.each do |socket|
          case socket
            when server
              readable << socket.accept
            else
              handle_client socket
          end

        end
      end
    ensure
      readable.each do |socket|
        socket.close
      end
    end

    def handle_client(client)
      header = client.gets.to_s

      return unless header[0] == '*'

      num_args = header[1..-1].to_i

      cmd = num_args.times.map do
        len = client.gets[1..-1].to_i
        client.read(len + 2).chomp
      end

      response = case cmd[0].downcase
                   when 'ping' then "+PONG\r\n"
                   when 'echo' then "$#{cmd[1].length}\r\n#{cmd[1]}\r\n"
                 end

      client.write response
    end

    private

    attr_reader :port

  end
end