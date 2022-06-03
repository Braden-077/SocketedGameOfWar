# frozen_string_literal: true 

class Card
  SUITS = ['C', 'H', 'D', 'S']
  RANKS = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A']

  attr_accessor :rank, :suit
  def initialize(rank, suit)
    if RANKS.include?(rank) && SUITS.include?(suit)
      @rank = rank 
      @suit = suit
    end
  end

  def value
    RANKS.index(rank)
  end

  def ==(other)
    @suit == other.suit && @rank == other.rank
  end
end 
