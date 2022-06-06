# frozen_string_literal: true

require 'card'
require 'war_player'
require 'game'
require 'pry'

describe Game do
  describe '#initialize' do
    
    it 'initializes without error' do
      expect { Game.new }.not_to raise_error
    end
    
    it 'should not default players to empty list if none are provided' do
      game = Game.new
      expect(game.players).not_to eq []
    end
  end

  describe '#start' do
    it 'deals all the cards when the game is started' do
      game = Game.new
      game.start
      expect(game.deck.cards_left).to be_zero
      expect(game.players[0].cards.length).to eq 26
      expect(game.players[1].cards.length).to eq 26
    end
  end

  describe '#play_round' do
    it 'makes sure players don\'t have the same amount of cards as when dealt' do
      game = Game.new([WarPlayer.new('Josh', [Card.new('K', 'S')]), WarPlayer.new('Braden', [Card.new('A', 'S')])])
      game.play_round
      expect(game.winner.name).to eq 'Braden'
      expect(game.winner.cards.length).to eq 2
    end
  end

  describe '#winner' do 
    it 'gives us the expected winner\'s name back' do
      game = Game.new([WarPlayer.new('Josh', [Card.new('K', 'S')]), WarPlayer.new('Braden', [Card.new('A', 'S')])])
      game.play_round
      expect(game.winner.name).to eq 'Braden'
    end

    it 'gives player 2 their cards back if player 1 has no more cards left' do
      game = Game.new([WarPlayer.new('Josh', []), WarPlayer.new('Braden', [Card.new('A', 'S')])])
      game.play_round
      expect(game.winner.name).to eq 'Braden'
      expect(game.winner.cards.count).to eq 1
    end

    it 'gives player 1 their cards back if player 2 has no more cards left' do
      game = Game.new([WarPlayer.new('Josh',[Card.new('A', 'S')]), WarPlayer.new('Braden', [])])
      game.play_round
      expect(game.winner.name).to eq 'Josh'
      expect(game.winner.cards.count).to eq 1
    end
  end
end  
