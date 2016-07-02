class Rook

  attr_reader :color

  def initialize(color)
    @color = color
  end

  def get_unicode
    return "\u2656" if color == "white"
    return "\u265C" if color == "black"
  end

  def possible_moves
    {
      left:        lambda { |x, y, index| { x: x-index, y: y } },
      up:          lambda { |x, y, index| { x: x, y: y+index } },
      right:       lambda { |x, y, index| { x: x+index, y: y } },
      down:        lambda { |x, y, index| { x: x, y: y-index } }
    }
  end


end