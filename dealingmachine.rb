require './deck.rb'

class DealingMachine
    attr_accessor :current_deck

    def initialize
        # put a new deck of card into the dealing machine and shuffle it
        @current_deck = Deck.new
        @current_deck.shuffle
    end

    def deal_one_card
        if 0 == @current_deck.available_cards_num
            # the current deck is used out, we need a new deck of cards
            @current_deck = Deck.new
            @current_deck.shuffle
            @current_deck.deal_one_card
        else
            @current_deck.deal_one_card
        end
    end
end




