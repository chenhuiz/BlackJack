class Deck
    # @cards is an array of size 52, representing one deck of cards(without jokers) 
    # @available_cards_num is the number of cards left in this deck(minus by one every time after dealing a card)
    attr_accessor :cards, :available_cards_num
         
    def initialize
        # initialize @cards to be 0 to 51
        # a card's value is 1 + (the number mod 13) 
        # a card's suit is the number divided by 13
        # we set the rule as: 0 is clubs; 1 is diamonds; 2 is hearts; 3 is spades 
         
        @cards = Array.new(52)
        i=0
        while i < @cards.length
            @cards[i] = i
            i += 1
        end

        @available_cards_num = 52
    end


    # shuffle the available cards of the deck in a random way
    # swap each position's card with a random position's card
    def shuffle
        i=0
        while i < @available_cards_num
            j = rand(@available_cards_num)
            temp = @cards[i]
            @cards[i] = @cards[j]
            @cards[j] = temp
            i += 1
        end
    end

    # each time dealing one card, the available cards number decrease by 1
    def deal_one_card
        @available_cards_num -= 1
        @cards[@available_cards_num]
    end


end



