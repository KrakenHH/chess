class Pawn

  attr_reader :color

  def initialize(color)
    @color = color
  end

  def get_unicode
    return "\u2659" if color == "white"
    return "\u265f" if color == "black"
  end

  def possible_moves
    if color == 'white'
      get_white_possible_moves
    else
      get_black_possible_moves
    end
  end

  private

  def get_white_possible_moves
    {
      up:          lambda { |x, y| { x: x, y: y+1 } },
      double_up:   lambda { |x, y| { x: x, y: y+2, no_put: y != 1 ? true : false } },
      up_left:     lambda { |x, y| { x: x-1, y: y+1 } },
      up_right:    lambda { |x, y| { x: x+1, y: y+1 } }
    }
  end


  def get_black_possible_moves
    {
      down:          lambda { |x, y| { x: x, y: y-1 } },
      double_down:   lambda { |x, y| { x: x, y: y-2, no_put: y != 6 ? true : false } },
      down_left:     lambda { |x, y| { x: x-1, y: y-1 } },
      down_right:    lambda { |x, y| { x: x+1, y: y-1 } }
    }
  end

end