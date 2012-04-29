require './aux.rb'

class Player
    attr_accessor :balance, :player_status, :hands, :hands_status, :bets, :values, :cur, :dealingmachine

    def initialize (dealingmachine)
        @balance = 1000                       # player's money left
        @player_status = "in"                 # in/out of game
        @hands = []                           # an array of arrays; stores a player's all hands if splitted
        @hands_status = []                    # an array of string; finished/unfinished with a hand
        @bets = []                            # an array of ints; stores a player's bets for each of his hands
        @values = []                          # an array of ints; stores each hand's value
        @cur = 0                              # index of the current hand which the player is working on
        @dealingmachine = dealingmachine      # all players should share a same dealingmachine which is initiated in main.rb
    end
  
    # step 0: sit or quit?
    def sit_or_quit
        puts "Sit? or Quit?"
        puts "1--sit; 2--quit"
        get_input = gets.chomp
        while (!is_int?(get_input)) || ((is_int?(get_input)) && !((1..2)===Integer(get_input))) 
            puts "Invalid input. Please re-input: 1--sit;2--quit"
            get_input = gets.chomp
        end
        choice = Integer(get_input)
        case choice
        when 1
            @player_status = "in"
        when 2
            @player_status = "out"
        end
    end
    
    # step 1: betting
    def bet 
        puts "Your Balance is: #{@balance}\nPlease input an INTEGER as your bets for this round"       
        get_input = gets.chomp        
        # when input is invalid integer or it's bigger than balance, you have to re-input
        while (!is_int?(get_input)) || ((is_int?(get_input)) && (Integer(get_input) > @balance)) 
            if !is_int?(get_input)
                puts "Come on, dude! A valid INTEGER!!INTEGER!!\nPlease re-input an INTEGER, be CAREFUL!"
            else
                puts "What? You can't bet more than your balance!\nPlease re-input an INTEGER, be REASONABLE!"    
            end
            get_input = gets.chomp
        end
        @bets << Integer(get_input)
        @balance -= @bets[0]     
        puts "You bet #{@bets[0]} in this round"
    end

    # step 2: initial dealing
    def init_deal
        initialhand = []
        initialhand << @dealingmachine.deal_one_card << @dealingmachine.deal_one_card
        @hands << initialhand
        @hands_status << "unfinished"
    end

    # step 3: play round
    def play
        self.check 
        while ("unfinished" == @hands_status[@cur])
            choice = 0
            
            if 2 == @hands[@cur].length                 # handle a hand first time
                if (num_to_value(@hands[@cur][0]) == num_to_value(@hands[@cur][1])) && (@balance >= @bets[@cur])
                # can split and double
                    puts "please input INTEGER for your choice:\n1--hit; 2--stand; 3--double; 4--split"
                    get_input = gets.chomp
                    while (!is_int? get_input) || ((is_int? get_input) && !((1..4)===Integer(get_input)))
                        puts "invalid input, please re-input:\n1--hit; 2--stand; 3--double; 4--split"
                        get_input = gets.chomp
                    end
                    choice = Integer(get_input)
                elsif (@balance >= @bets[@cur])
                # can double
                    puts "please input INTEGER for your choice:\n1--hit; 2--stand; 3--double"
                    get_input = gets.chomp
                    while (!is_int? get_input) || ((is_int? get_input) && !((1..3)===Integer(get_input)))
                        puts "invalid input, please re-input:\n1--hit; 2--stand; 3--double"
                        get_input = gets.chomp
                    end
                    choice = Integer(get_input)
                else
                    puts "please input INTEGER for your choice:\n1--hit; 2--stand"
                    get_input = gets.chomp
                    while (!is_int? get_input) || ((is_int? get_input) && !((1..2)===Integer(get_input)))
                        puts "invalid input, please re-input:\n1--hit; 2--stand"
                        get_input = gets.chomp
                    end
                    choice = Integer(get_input)
                end
            else
                # can only hit or stand
                puts "please input INTEGER for your choice:\n1--hit; 2--stand"
                get_input = gets.chomp
                while (!is_int? get_input) || ((is_int? get_input) && !((1..2)===Integer(get_input)))
                    puts "invalid input, please re-input:\n1--hit; 2--stand"
                    get_input = gets.chomp
                end   
                choice = Integer(get_input)
            end

            case choice
            when 1
                self.hit
            when 2
                self.stand
            when 3
                self.double
            when 4
                self.split
            end

            self.check
          
        end
    end

    # step 4: reset and ready for a new round
    def reset
        @player_status = "in"                
        @hands = []                          
        @hands_status = []                    
        @bets = []                            
        @values = []                          
        @cur = 0  
    end
    

    # check is to calculate and output the value of current hand, then check whether it's blackjack or busted. 
    # If so, it will label the hand with finished
    def check
        curhand = "hand ##{@cur+1} contains: "
        containAce = false;
        sum = 0
        i = 0
        while i<@hands[@cur].length
            if 1 == num_to_value(@hands[@cur][i])
                containAce = true
            end
            sum += num_to_value(@hands[@cur][i])
            curhand += num_to_rank(@hands[@cur][i]) + " "
            i += 1
        end

        puts "---------------------------------------------------------"
        puts curhand

        if containAce
            if sum < 11
                puts "hand ##{@cur+1} value: #{sum}/#{sum+10}"
                @values[@cur] = sum + 10                                # store the higher value which benefits the player
            elsif 11 == sum 
                if 2 == @hands[@cur].length && 1 == @hands.length       # a blackjack!! no split and only contain two cards
                    puts "hand ##{@cur+1} value: BLACKJACK!!"
                    @hands_status[@cur] = "finished"
                    @values[@cur] = 50                                  # use 50 to represent a blackjack
                else
                    puts "hand ##{@cur+1} value: 21"
                    @values[@cur] = 21
                    @hands_status[@cur] = "finished"
                end
            elsif sum < 21
                puts "hand ##{@cur+1} value: #{sum}"
                @values[@cur] = sum
            elsif 21 == sum
                puts "hand ##{@cur+1} value: 21"
                @hands_status[@cur] = "finished"
                @values[@cur] = 21
            else
                puts "hand ##{@cur+1} value: #{sum} busted!"
                @hands_status[@cur] = "finished"
                @values[@cur] = sum                
            end
        else
            if sum < 21
                puts "hand ##{@cur+1} value: #{sum}"
                @values[@cur] = sum
            elsif 21 == sum
                puts "hand ##{@cur+1} value: 21"
                @hands_status[@cur] = "finished"
                @values[@cur] = 21
            else
                puts "hand ##{@cur+1} value: #{sum} busted!"
                @hands_status[@cur] = "finished"
                @values[@cur] = sum
            end
        end


        puts "bets for hand ##{@cur+1}: #{@bets[@cur]}"
        puts "---------------------------------------------------------"

        if "finished" == @hands_status[@cur] 
            puts "hand ##{@cur+1} finished"
            puts ""
            if @cur < @hands.length - 1
                @cur += 1 
                self.check                # this recursion is to output the information about newly splitted hand's initial status
            end
        end

    end


    # player's decisions
    def hit
        @hands[@cur] << @dealingmachine.deal_one_card
        puts "Your new card is:" + num_to_rank(@hands[@cur].last) 
    end

    def stand
        @hands_status[@cur] = "finished"        
    end

    def double
        @hands[@cur] << @dealingmachine.deal_one_card
        @hands_status[@cur] = "finished"
        @balance -= @bets[@cur]
        @bets[@cur] *= 2 
    end

    def split
        oldhand = @hands[@cur]
        newhand = []
        newhand << oldhand[1] << @dealingmachine.deal_one_card
        oldhand[1] = @dealingmachine.deal_one_card
        @hands << newhand
        @hands_status << "unfinished"
        @bets << @bets[@cur]
        @balance -= @bets[@cur]
    end
end




