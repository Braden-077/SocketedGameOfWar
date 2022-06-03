# frozen_string_literal: true

require 'card'
require 'war_player'
require 'game'
require 'pry'

describe Game do
    let(:player1) do
      WarPlayer.new
    end

    let(:player2) do
      WarPlayer.new
    end
  describe '#initialize' do
    subject(:game) { Game.new(players) }
    let(:players) do
      [
        WarPlayer.new([]),
        WarPlayer.new([])
      ]
    end
    
    it 'initializes without error' do
      expect { Game.new(players) }.not_to raise_error
    end
    
    it 'should not default players to empty list if none are provided' do
      game = Game.new
      expect(game.players).not_to eq []
    end
    
    it 'has a list of players' do
      game = Game.new(players)
      expect(game.players).to eq players
    end

  end
  describe '#start' do
    it 'deals all the cards when the game is started' do
      game = Game.new([player1, player2])
      game.start
      expect(game.deck.cards_left).to be_zero
      expect(game.players[0].cards.length).to eq 26
      expect(game.players[1].cards.length).to eq 26
    end
  end
  describe '#play_round' do
    it 'makes sure players don\'t have the same amount of cards as when dealt' do
      game = Game.new([WarPlayer.new([Card.new('K', 'S')], 'Josh'), WarPlayer.new([Card.new('A', 'S')], 'Braden')])
      game.play_round
      expect(game.winner.name).to eq 'Braden'
      expect(game.players.first.cards.length).to eq 2
    end
    #TODO: More test coverage - hit if loops and return if
    it 'TODO: card 2 value wins - expect first player to lose NOT player 2'
  end
  describe '#winner' do 
    it 'gives us the expected winner\'s name back' do
      game = Game.new([WarPlayer.new([Card.new('K', 'S')], 'Josh'), WarPlayer.new([Card.new('A', 'S')], 'Braden')])
      game.play_round
      expect(game.winner.name).to eq 'Braden'
    end

    it 'removes users without cards' do
      game = Game.new([WarPlayer.new([], 'Josh'), WarPlayer.new([Card.new('A', 'S')], 'Braden')])
      expect(game.winner.name).to eq 'Braden'
    end
  end
end  
