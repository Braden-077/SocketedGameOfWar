require_relative 'game'

game = Game.new
game.start
until game.winner do
  puts game.play_round
end
puts "Winner: #{game.winner.name}"
