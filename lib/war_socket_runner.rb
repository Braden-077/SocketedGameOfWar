# frozen_string_literal: true 

require_relative 'game_runner'
require_relative 'war_socket_server'
require 'pry'

server = WarSocketServer.new
server.start
while true do
  begin
    server.accept_new_client
    server.get_player_name
    server.create_game_if_possible
    game = server.games[0]
    if game
      runner = GameRunner.new(game)
      server.games.shift
      runner.play_a_round
    end
  rescue
    server.stop
  end
end