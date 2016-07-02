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
      up:          lambda { |x, y, index| { x: x, y: y+1, breaker: index > 1 ? true : false } },
      double_up:   lambda { |x, y, index| { x: x, y: y+2, breaker: index > 1 || y != 1 ? true : false } }
    }
  end


  def get_black_possible_moves
    {
      down:          lambda { |x, y, index| { x: x, y: y-1, breaker: index > 1 ? true : false } },
      double_down:   lambda { |x, y, index| { x: x, y: y-2, breaker: index > 1 || y != 6 ? true : false } }
    }
  end

end