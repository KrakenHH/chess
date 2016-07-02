class Knight

  attr_reader :color

  def initialize(color)
    @color = color
  end

  def get_unicode
    return "\u2658" if color == "white"
    return "\u265E" if color == "black"
  end

  def possible_moves
    { 
      up_left_wide:       lambda { |x, y, index| { x: x-2, y: y+1, breaker: index > 1 ? true : false } },
      up_left_skinny:     lambda { |x, y, index| { x: x-1, y: y+2, breaker: index > 1 ? true : false } },
      up_right_skinny:    lambda { |x, y, index| { x: x+1, y: y+2, breaker: index > 1 ? true : false } },
      up_right_wide:      lambda { |x, y, index| { x: x+2, y: y+1, breaker: index > 1 ? true : false } },
      down_right_wide:    lambda { |x, y, index| { x: x+2, y: y-1, breaker: index > 1 ? true : false } },
      down_right_skinny:  lambda { |x, y, index| { x: x+1, y: y-2, breaker: index > 1 ? true : false } },
      down_left_skinny:   lambda { |x, y, index| { x: x-1, y: y-2, breaker: index > 1 ? true : false } },
      down_left_wide:     lambda { |x, y, index| { x: x-2, y: y-1, breaker: index > 1 ? true : false } }
    }
  end


end