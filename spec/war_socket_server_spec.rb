# frozen_string_literal: true 

require 'socket'
require 'war_socket_server'
require 'pry'

class MockWarSocketClient
  attr_reader :socket, :output

  def initialize(port)
    @socket = TCPSocket.new('localhost', port)
    sleep(0.01)
  end

  def provide_input(text)
    @socket.puts(text)
    sleep(0.01)
  end

  def capture_output(delay=0.1)
    sleep(delay)
    @output = @socket.read_nonblock(1000) # not gets which blocks
  rescue IO::WaitReadable
    @output = ""
  end

  def close
    @socket.close if @socket
  end
end

describe WarSocketServer do
  before(:each) do
    @clients = []
    @server = WarSocketServer.new
  end

  after(:each) do
    @server.stop
    @clients.each do |client|
      client.close
    end
  end

  it "is not listening on a port before it is started"  do
    expect {MockWarSocketClient.new(@server.port_number)}.to raise_error(Errno::ECONNREFUSED)
  end

  it "accepts new clients and starts a game if possible" do
    @server.start
    client1 = MockWarSocketClient.new(@server.port_number)
    @clients.push(client1)
    @server.accept_new_client
    @server.create_game_if_possible
    expect(@server.games.count).to be 0
    client2 = MockWarSocketClient.new(@server.port_number)
    @clients.push(client2)
    @server.accept_new_client
    @server.create_game_if_possible
    expect(@server.games.count).to be 1
  end

  it 'sends a message from the server to the client when a successful connection has occured'  do
    @server.start 
    client1 = MockWarSocketClient.new(@server.port_number)
    @clients.push(client1)
    @server.accept_new_client
    client1.capture_output
    expect(client1.output.chomp).to include "You've connected!"
  end

  it 'tests for capturing player input' do
    @server.start 
    client1 = MockWarSocketClient.new(@server.port_number)
    @clients.push(client1)
    @server.accept_new_client
    client1.provide_input('What I give it')
    message = @server.capture_input(@server.clients.first)
    expect(message).to eq 'What I give it'
  end


  it 'prompts a player for their name and associates it with the client' do
    @server.start
    client1 = MockWarSocketClient.new(@server.port_number)
    # @clients.push(client1)
    @server.accept_new_client
    # client1.capture_output
    expect(client1.capture_output.strip).to end_with 'Please enter your name:'
    client1.provide_input('Braden')
    @server.get_player_name
    expect(@server.player_names.first).to eq 'Braden'
  end

  it 'allows for the second user to input their name and still be refered to by name' do
    @server.start
    client1, client2 = MockWarSocketClient.new(@server.port_number), MockWarSocketClient.new(@server.port_number)
    @server.accept_new_client
    @server.accept_new_client
    client2.provide_input('Caleb')
    @server.get_player_name
    client1.provide_input('Braden')
    @server.get_player_name
    expect(@server.player_names.first).to eq 'Braden'
    expect(@server.player_names.last).to eq 'Caleb'
  end

  it 'allows for the second user to input their name and still be refered to by name', :focus do
    @server.start
    client1, client2 = MockWarSocketClient.new(@server.port_number), MockWarSocketClient.new(@server.port_number)
    @server.accept_new_client
    @server.accept_new_client
    client2.provide_input('Caleb')
    @server.get_player_name
    client1.provide_input('Braden')
    @server.get_player_name
    expect(@server.player_names.first).to eq 'Braden'
    expect(@server.player_names.last).to eq 'Caleb'
  end

  it 'takes the provided names and creates a game using them' do
    @server.start
    client1, client2 = MockWarSocketClient.new(@server.port_number), MockWarSocketClient.new(@server.port_number)
    @server.accept_new_client
    @server.accept_new_client
    client2.provide_input('Caleb')
    @server.get_player_name
    client1.provide_input('Braden')
    @server.get_player_name
    @server.create_game_if_possible
    expect(@server.games.first.game.players.count).to eq 2
    expect(@server.games.first.game.players.first.name).to eq 'Braden'
    expect(@server.games.first.game.players.last.name).to eq 'Caleb'
  end


  # Add more tests to make sure the game is being played
  # Unique connection messages 
  # For example:
  #   make sure the mock client gets appropriate output
  #   make sure the next round isn't played until both clients say they are ready to play
  #   ...
end
