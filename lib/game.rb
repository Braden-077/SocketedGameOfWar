# frozen_string_literal: true

require_relative 'deck'
require_relative 'war_player'
require 'pry'

class Game
  attr_reader :players, :deck
  def initialize(players=[WarPlayer.new, WarPlayer.new], deck = Deck.new)
    @players = players
    @deck = deck
  end

  def start 
    deck.shuffle!
    until deck.cards_left == 0
      players.each do |player|
        player.cards.push(deck.deal)
      end
    end
  end

  def winner
    players.delete_if {|player| player.cards.length == 0} 
    players.length == 1 ? (players.first) : nil 
  end

  def round_message(winner, winning_card, loser, losing_card)
    "#{winner.name} played #{winning_card.rank} and beat #{loser.name} who played #{losing_card.rank}. #{players.first.cards.count}/#{players.last.cards.count}"
  end

  def give_winnings(player, card1, card2, tied_winnings=[], loser)
    player.take(*tied_winnings.push(card1, card2).shuffle!)
    round_message(player, card1, loser, card2)
  end

  def play_round(tied_winnings = [])
    card1, card2 = players.first.play, players.last.play
    return if card1.nil? || card2.nil?
    if card1.value > card2.value
      give_winnings(players.first, card1, card2, tied_winnings, players.last)
    elsif card1.value < card2.value
      give_winnings(players.last, card1, card2, tied_winnings, players.last)
    else 
      (tied_winnings.push(card1, card2) ; play_round(tied_winnings))
    end
  end
end
