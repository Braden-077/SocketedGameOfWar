# frozen_string_literal: true

require 'pry'
require 'card'
require 'war_player'

describe WarPlayer do
  describe 'basic funtions of creation' do
    it 'initializes without error' do
      expect { WarPlayer.new([Card.new('J', 'D'), Card.new('A', 'H')]) }.not_to raise_error
    end
    
    it 'defaults cards to empty list if none are provided' do
      player = WarPlayer.new
      expect(player.cards).to eq []
    end
    
    it 'has a list of cards' do
      cards = [Card.new('J', 'D'), Card.new('A', 'H')]
      player = WarPlayer.new(cards)
      expect(player.cards).to eq cards
    end
  end

  describe '#play' do
    it 'expects a player to put out their first card' do
      cards = [Card.new('A', 'S'), Card.new('A', 'C')]
      player = WarPlayer.new(cards)
      card = player.play
      expect(player.cards.length).to eq 1
      expect(card).to eq Card.new('A', 'S')
    end

    it 'raises an error when no cards in hand' do
      player = WarPlayer.new
      expect(player.cards.length).to be_zero
      error = player.play
      expect(error).to be_nil
    end

    it 'describes the value when no card is present' do
      player = WarPlayer.new([Card.new('A', 'S')])
      expect(player.cards.length).to eq 1
      expect(player.play).to eq Card.new('A', 'S')
      player.play
      expect(player.cards.length).to eq 0
      expect(player.play).to be_nil
    end
  end

  describe '#take' do
    it 'adds the provided card to the hand' do
      cards = [Card.new('Q', 'D'), Card.new('7', 'S'), Card.new('9', 'C')]
      player = WarPlayer.new([cards[0], cards[1]])
      player.take(cards[2])
      expect(player.cards).to eq cards
    end
    
    it 'takes multiple cards' do
      cards = [Card.new('Q', 'D'), Card.new('7', 'S'), Card.new('9', 'C')]
      player = WarPlayer.new
      player.take(*cards)
      
      expect(player.cards).to match_array cards
    end
    
    it 'adds cards to the hand' do
      player = WarPlayer.new
      card = Card.new('5', 'C')
      player.take(card)
      expect(player.cards).to eq([card])
    end
  end
end
