require './aux.rb'

class Dealer
    attr_accessor :hand, :value, :dealingmachine, :status

    def initialize (dealingmachine)
        @dealingmachine = dealingmachine
        @hand = []
        @value = nil
        @status = "unfinished"   
    end
    
    # step 1: deal 2 cards to dealer, the second one is visible to players
    def deal
        @hand << @dealingmachine.deal_one_card << @dealingmachine.deal_one_card
    end
    
    # step 2: show the visible card
    def show_visible_card
        puts "*******************************************************************"
        puts "         Dealer's visible card is: " + num_to_rank(@hand[1])
        puts "*******************************************************************"
    end
    
    # step 3: play round
    def play
        self.check
        while("unfinished" == @status)
            if(@value < 17)
                @hand << @dealingmachine.deal_one_card
            end
            self.check
        end
        
        # output the dealer's hand
        i = 0
        dealerhand = "dealer's hand contains: "
        while i < @hand.length
            dealerhand += num_to_rank(@hand[i]) + " "
            i += 1
        end
        puts "*******************************************************"
        puts dealerhand
        if 50 == @value
            puts "value: BLACKJACK"
        elsif @value <= 21
            puts "value: #{@value}"
        else
            puts "value: #{@value} Busted!!"
        end
        puts "*******************************************************"
    end

    # step 4: reset and ready for a new round
    def reset
        @hand = []
        @value = nil
        @status = "unfinished"
    end

    # check whether the value is over 16 
    # if so, stand; if not, hit
    def check
        containAce = false
        i = 0
        sum = 0
        while i < @hand.length
            if 1 == num_to_value(@hand[i])
                containAce = true
            end
            sum += num_to_value(@hand[i])
            i += 1
        end

        if containAce
            if sum < 7
                @value = sum + 10
            elsif sum < 11
                @value = sum + 10
                @status = "finished"
            elsif 11 == sum
                if 2 == @hand.length 
                    @value = 50         # 50 means it's BLACKJACK
                    @status = "finished"
                else
                    @value = 21
                    @status = "finished"
                end
            elsif sum < 17
                @value = sum
            else sum <= 21
                @value = sum
                @status = "finished"
            end
        else
            if sum < 17
                @value = sum
            else
                @value = sum
                @status = "finished"
            end
        end
    end


end

