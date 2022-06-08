# frozen_string_literal: true 

require 'socket'
require 'pry'
require_relative 'game'
require_relative 'war_player'
require_relative 'game_runner'

class WarSocketServer
  attr_accessor :clients, :games, :player_names
  def initialize
    @clients = []
    @games = []
    @player_names = []
  end

  def port_number
    3336
  end

  def start
    @server = TCPServer.new(port_number)
  end

  def accept_new_client
    client = @server.accept_nonblock
    clients.push(client)
    client.puts "You've connected!"
    client.puts 'Please enter your name:'

  rescue IO::WaitReadable, Errno::EINTR
    "No client to accept"
  end

  def create_game_if_possible
    if clients.count >= 2
      games.push(GameRunner.new(Game.new([WarPlayer.new(player_names[0]), WarPlayer.new(player_names[1])])))
      2.times {clients.shift}
    end
  end
  
  def ask_players_ready
    if clients.count >= 2
      clients.each {|client| client.puts 'Players, Ready?' } 
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

  def ask_for_player_name(client, player_name = false)
    if !player_name
      client.puts 'Please enter your name:' 
      capture_input(client)
      puts 'Got name'
    else 
      player_name
    end
  end
  
  def get_player_name
    clients.each_with_index do |client, index|
      next if player_names[index]
      begin
        player_names[index] = client.read_nonblock(1000).strip
      rescue IO::WaitReadable
      end
    end
  end

  def stop
    @server.close if @server
  end
end
