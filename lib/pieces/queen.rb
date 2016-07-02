class Queen

  attr_reader :color

  def initialize(color)
    @color = color
  end

  def get_unicode
    return "\u2655" if color == "white"
    return "\u265B" if color == "black"
  end

  def possible_moves
    { 
      up_left:     lambda { |x, y, index| { x: x-index, y: y+index } },
      up_right:    lambda { |x, y, index| { x: x+index, y: y+index } },
      down_right:  lambda { |x, y, index| { x: x+index, y: y-index } },
      down_left:   lambda { |x, y, index| { x: x-index, y: y-index } },
      left:        lambda { |x, y, index| { x: x-index, y: y } },
      up:          lambda { |x, y, index| { x: x, y: y+index } },
      right:       lambda { |x, y, index| { x: x+index, y: y } },
      down:        lambda { |x, y, index| { x: x, y: y-index } }
    }


  end


end