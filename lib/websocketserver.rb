require 'drb/drb'
require 'em-websocket'


class WebSocketServer

  attr_accessor :clients

  def initialize(ip="0.0.0.0",port=8080)
    @clients=[]

    Thread.new do
      EventMachine.run do
        EventMachine::WebSocket.start(:host => ip, :port => port) do |ws|
          ws.onopen {
            @clients << ws
          }

          ws.onclose {
            @clients.delete(ws)
          }

        end
      end
    end

  end


  def send_message(message)
    @clients.each do |ws|
      ws.send "message"
    end
  end

end

FRONT_OBJECT=WebSocketServer.new

$SAFE=1

Drb.start_service("druby://localhost/8787", FRONT_OBJECT)
Drb.thread.join