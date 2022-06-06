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
    players.reject! {|player| player.cards.count == 0}
    return players[0] if players.length == 1
  end

  def player1
    players.first
  end

  def player2
    players.last
  end

  def round_message(winner, winning_card, loser, losing_card)
    "#{winner.name} played #{winning_card.rank} and beat #{loser.name} who played #{losing_card.rank}. #{players.first.cards.count}/#{players.last.cards.count}"
  end

  def any_nil_cards?(card1, card2, tied_winnings=[])
    if card1.nil?
      player2.take(card2, *tied_winnings)
      player2.cards.reject!{|card| card.nil?}
    elsif card2.nil? 
      player1.take(card1, *tied_winnings)
      player1.cards.reject! {|card| card.nil?}
    end
  end

  def give_winnings(player, card1, card2, tied_winnings=[], loser)
    player.take(*tied_winnings.push(card1, card2).shuffle!)
    round_message(player, card1, loser, card2)
  end

  def play_round(tied_winnings = [])
    card1, card2 = player1.play, player2.play
    return any_nil_cards?(card1, card2, tied_winnings) if card1.nil? || card2.nil?
    if card1.value > card2.value
      give_winnings(player1, card1, card2, tied_winnings, player2)
    elsif card1.value < card2.value
      give_winnings(player2, card1, card2, tied_winnings, player1)
    else 
      (tied_winnings.push(card1, card2) ; play_round(tied_winnings))
    end
  end
end
