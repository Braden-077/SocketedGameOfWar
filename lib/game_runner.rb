# frozen_string_literal: true 

require_relative 'game'
require 'pry'
class GameRunner
  attr_accessor :game, :ready
  def initialize(game = Game.new)
    @game = game
    @ready = {}
      # clients.each {|client| ready[client] = false }
      game.players.each {|client| ready[client = false]}
  end

  def start_game
    game.start 
  end

  def play_a_round
    if game.winner puts "Winner: #{game.winner.name}"
    elsif ready?
      game.play_round
    end
  end

  # def ready_up
  #   game.clients.each do |client|
  #     next if ready[client]
  #     input = client.read_nonblock(1000)
  #     ready[client] = true 
  #   end
  # end

  # def ready?
  #   ready_up
  #   ready.all?{|_, is_ready| is_ready}
  # end
end
  