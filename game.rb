require './dealingmachine.rb'
require './player.rb'
require './dealer.rb'

class Game
    attr_accessor :dealingmachine, :players, :dealer, :gameover

    def initialize 
        @dealingmachine = DealingMachine.new
        @dealer = Dealer.new(@dealingmachine)
        @players = []
        @gameover = false  
    end

    # step 1: initialize all the players
    def set_players
        puts "How many players?(8 at most)\nPlease input an INTEGER"
        get_input = gets.chomp
        while(!is_int?(get_input))||((is_int?(get_input))&&!((1..8)===Integer(get_input)))
            puts "Invalid input. Re-input please"
            get_input = gets.chomp
        end
        num = Integer(get_input)
        i = 0
        while i < num
            @players << Player.new(@dealingmachine)
            i += 1
        end
    end
    
    # step 2: let each player bet and set
    def start_round
        @dealer.deal
        @dealer.show_visible_card
        i = 0
        while i < @players.length
            if "in" == @players[i].player_status
                puts "Hello Player ##{i+1}"
                @players[i].bet
                @players[i].init_deal
                @players[i].play
            end
            i += 1
        end
        @dealer.play
    end

    # step 3: resolve a round
    def resolve_round
        i = 0
        puts "<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>"
        while i < @players.length
            if "in" == @players[i].player_status
                j = 0
                netwin = 0
                while j < @players[i].values.length
                    playervalue = @players[i].values[j]
                    dealervalue = @dealer.value
                    if 50 == playervalue                                # player is a blackjack
                        if 50 == dealervalue                            # a blackjack push
                            @players[i].balance += 1 * @players[i].bets[j]
                        else
                            @players[i].balance += 2.5 * @players[i].bets[j] # 3:2 blackjack
                            netwin += 1.5 * @players[i].bets[j]
                        end
                    elsif playervalue > 21      # player bust first
                        netwin -= @players[i].bets[j]
                    else                        # player does not bust
                        if 50 == dealervalue
                            netwin -= @players[i].bets[j]
                        elsif dealervalue > 21
                            @players[i].balance += 2 * @players[i].bets[j]
                            netwin += @players[i].bets[j]
                        elsif dealervalue > playervalue
                            netwin -= @players[i].bets[j]
                        elsif dealervalue == playervalue
                            @players[i].balance += 1 * @players[i].bets[j]
                        else
                            @players[i].balance += 2 * @players[i].bets[j]
                            netwin += @players[i].bets[j]
                        end
                    end
                    j += 1
                end
                
                # print out each player's balance after each round
                if netwin >= 0
                    puts "Player ##{i+1} win: #{netwin} balance: #{@players[i].balance}"
                else
                    puts "Player ##{i+1} lost: #{-netwin} balance: #{@players[i].balance}"
                end
                # kick out the broke player
                if 0 == @players[i].balance
                    @players[i].player_status = "out"
                end

            end
            i += 1
        end
        puts "<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>"
    end

    # step 4: end and reset 
    def end_round
        i = 0
        while i < @players.length
            if "in" == @players[i].player_status
                puts "Hello Player ##{i+1}"
                @players[i].sit_or_quit
                if "out" == @players[i].player_status
                    puts "See you Player ##{i+1}"
                else
                    @players[i].reset
                end
            end
            i += 1
        end
        @dealer.reset
    end

    # step 5: game over?
    def gameover?
        i = 0
        @gameover = true
        while i < @players.length
            if "in" == @players[i].player_status
                @gameover = false
            end
            i += 1
        end
        if @gameover
            puts "GAME OVER!!"
        end
    end
end

