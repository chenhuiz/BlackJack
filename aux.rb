# the following are some auxiliary functions

# test whether a string is a valid integer
def is_int? (input)
    Integer(input)
    rescue 
        false
    else
        true
end


# parse a number ranging from 0 to 51 to a valid card value
# we set the rule as: 0 is clubs; 1 is diamonds; 2 is hearts; 3 is spades
# this method is for human reading
def num_to_rank (num)
    value = 1 + num % 13
    suit = num / 13
    case suit
    when 0
        "club#{value}"
    when 1
        "diamond#{value}"
    when 2
        "heart#{value}"
    when 3
       "spade#{value}"
    end
end
    
# convert a number ranging from 0 to 51 to 1 to 10 in blackjack
# Ace is represented as 1
def num_to_value (num)
    temp = 1 + num % 13
    if temp > 10
        10
    else
        temp
    end
end
