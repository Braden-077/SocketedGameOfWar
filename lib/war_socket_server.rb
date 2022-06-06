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
    client.puts "You've connected, #{player_name}!"
  rescue IO::WaitReadable, Errno::EINTR
    "No client to accept"
  end

  def create_game_if_possible
    if clients.count >= 2
      games.push(Game.new(clients))
    end
  end
  
  def ask_players_ready
    if clients.count >= 2
      clients.each {|client| client.puts 'Players, Ready?'} 
    end
  end

  def capture_input(client)
    input = false
    until input != false
      begin
        input = client.read_nonblock(1000)
      rescue IO::WaitReadable
      end
    end
    input.chomp
  end

  def stop
    @server.close if @server
  end
end
