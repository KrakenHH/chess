class Bishop

  attr_reader :color

  def initialize(color)
    @color = color
  end

  def get_unicode
    return "\u2657" if color == "white"
    return "\u265D" if color == "black"
  end

  def possible_moves
    { 
      up_left:     lambda { |x, y, index| { x: x-index, y: y+index } },
      up_right:    lambda { |x, y, index| { x: x+index, y: y+index } },
      down_right:  lambda { |x, y, index| { x: x+index, y: y-index } },
      down_left:   lambda { |x, y, index| { x: x-index, y: y-index } } 
    }
  end



end