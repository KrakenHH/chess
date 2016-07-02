class King

  attr_reader :color

  def initialize(color)
    @color = color
  end

  def get_unicode
    return "\u2654" if color == "white"
    return "\u265A" if color == "black"
  end

  def possible_moves
    { 
      up_left:       lambda { |x, y, index| { x: x-1, y: y+1, breaker: index > 1 ? true : false } },
      up:            lambda { |x, y, index| { x: x, y: y+1, breaker: index > 1 ? true : false } },
      up_right:      lambda { |x, y, index| { x: x+1, y: y+1, breaker: index > 1 ? true : false } },
      down_right:    lambda { |x, y, index| { x: x+1, y: y-1, breaker: index > 1 ? true : false } },
      down:          lambda { |x, y, index| { x: x, y: y-1, breaker: index > 1 ? true : false } },
      down_left:     lambda { |x, y, index| { x: x-1, y: y-1, breaker: index > 1 ? true : false } },
    }
  end


end