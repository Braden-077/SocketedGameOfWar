require 'socket'
require 'war_socket_server'
require 'pry'

class MockWarSocketClient
  attr_reader :socket, :output

  def initialize(port)
    @socket = TCPSocket.new('localhost', port)
    sleep(0.00000001)
  end

  def provide_input(text)
    @socket.puts(text)
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
    @server.accept_new_client("Player 1")
    @server.create_game_if_possible
    expect(@server.games.count).to be 0
    client2 = MockWarSocketClient.new(@server.port_number)
    @clients.push(client2)
    @server.accept_new_client("Player 2")
    @server.create_game_if_possible
    expect(@server.games.count).to be 1
  end

  it 'sends a message from the server to the client when a successful connection has occured' do
    @server.start 
    client1 = MockWarSocketClient.new(@server.port_number)
    @clients.push(client1)
    @server.accept_new_client('Player 1')
    client1.capture_output
    expect(client1.output.chomp).to eq "You've connected, Player 1!"
  end

  it 'Sends a message to clients to ask if they are ready' do
    @server.start
    client1, client2 = MockWarSocketClient.new(@server.port_number), MockWarSocketClient.new(@server.port_number)
    @clients.push(client1, client2)
    @server.accept_new_client('Player 1')
    @server.accept_new_client('Player 2')
    @server.create_game_if_possible
    @server.ask_players_ready
    expect(client1.capture_output.strip).to end_with 'Players, Ready?'
    expect(client2.capture_output.strip).to end_with 'Players, Ready?'
  end

  it 'tests for capturing player input' do
    @server.start 
    client1 = MockWarSocketClient.new(@server.port_number)
    @clients.push(client1)
    @server.accept_new_client('Player 1')
    client1.provide_input('What I give it')
    message = @server.capture_input(@server.clients.first)
    expect(message).to eq 'What I give it'
  end





  # Add more tests to make sure the game is being played
  # Unique connection messages 
  # For example:
  #   make sure the mock client gets appropriate output
  #   make sure the next round isn't played until both clients say they are ready to play
  #   ...
end
