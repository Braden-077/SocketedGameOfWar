# frozen_string_literal: true 
class WarPlayer
  NAMES = ['William', 'Josh', 'Braden', 'Caleb', 'Jeremy']

  attr_accessor :cards, :name
  def initialize(name = NAMES.sample, cards = [])
    @name = name
    @cards = cards
  end

  def has_cards?
    !cards.empty?
  end

  def take(*new_cards)
    cards.push(*Array(new_cards))
  end

  def play
    cards.shift
  end
end 
