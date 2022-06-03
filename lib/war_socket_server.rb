require 'socket'
require 'game'

class WarSocketServer
  attr_accessor :clients, :games
  def initialize
    @clients = []
    @games = []
  end

  def port_number
    3336
  end

  def start
    @server = TCPServer.new(port_number)
  end

  def accept_new_client(player_name = "Random Player")
    client = @server.accept_nonblock
    clients.push(client)
  rescue IO::WaitReadable, Errno::EINTR
    "No client to accept"
  end

  def create_game_if_possible
    if clients.count >= 2
      games.push(Game.new)
    else 
      'Not enough players. Minimum of two required.'
    end
  end

  def stop
    @server.close if @server
  end
end
