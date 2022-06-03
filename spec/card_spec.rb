# frozen_string_literal: true

require 'card'

describe Card do
  describe 'valid cases' do
    it 'initializes without error' do
      expect { Card.new('J', 'D') }.not_to raise_error
    end

    it 'has a suit' do
      card = Card.new('J', 'D')
      expect(card.suit).to eq 'D'
    end
    
    it 'has a rank' do
      card = Card.new('J', 'D')
      expect(card.rank).to eq 'J'
    end
    
    it 'has a value' do
      card = Card.new('J', 'D')
      # 2 => 0, 3 => 1, ... , K => 11, A => 12
      expect(card.value).to eq 9
    end
  end
    
  describe 'invalid cases' do
    
    it 'does not allow for an invalid suit' do
      card = Card.new('J', 'INVALID')
      expect(card.suit).to eq nil
    end
    
    it 'does not allow for an invalid rank' do
      card = Card.new('INVALID', 'S')
      expect(card.rank).to eq nil
    end
  end
end
