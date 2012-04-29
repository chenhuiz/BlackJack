require './game.rb'


game = Game.new
game.set_players
while !game.gameover
    game.start_round
    game.resolve_round
    game.end_round
    game.gameover?
end


