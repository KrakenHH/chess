 class Board

  attr_accessor :board

  require_relative "./pieces/piece_helper.rb"

  def initialize
    @board = create_board
  end

  def get_board_coord(x, y)
    machine_coords = convert_human_coord_to_machine(x, y)
    board[machine_coords[:x]][machine_coords[:y]]
  end

  def display_board
    board.each_with_index do |row, index|
      print "#{7-index}"
      row.each { |ele| print "|#{ele == ' ' ? ele : ele.get_unicode }" }
      print "|\n"
    end
    print "  0 1 2 3 4 5 6 7\n\n"
  end

  def set_board_coord(x, y, value)
    machine_coords = convert_human_coord_to_machine(x, y)
    board[machine_coords[:x]][machine_coords[:y]] = value
  end

  def new_king
    p = King.new("white")
  end

  #return array of possible human (x, y) coordinates a specific position can move to
  def get_possible_moves(x, y)
    piece = get_board_coord(x, y)
    return get_pawn_possible_moves(x, y) if piece.is_a?(Pawn)
    lambs = piece.possible_moves.values
    arr = []
    lambs.each do |lamb|
      index = 1
      loop do
        new_coord_hash = lamb.call(x, y, index)
        new_arr = [new_coord_hash[:x], new_coord_hash[:y]]
        arr << new_arr if !new_arr.any? { |ele| ele < 0 || ele > 7 }  && get_board_coord(new_arr[0], new_arr[1]).respond_to?(:color) && get_board_coord(new_coord_hash[:x], new_coord_hash[:y]).color != piece.color
        break if !(0..7).include?(new_arr[0]) || !(0..7).include?(new_arr[1]) || lamb.call(x, y, index)[:breaker] || get_board_coord(new_coord_hash[:x], new_coord_hash[:y]) != ' '
        arr << new_arr
        index += 1
      end
    end
    arr
  end

  #special case for pawn
  def get_pawn_possible_moves(x, y)
    pos_move_hash = get_board_coord(x, y).possible_moves
    arr = []
    index = 0
    pos_move_hash.each do |key, value|
      case index
      when 0
        arr << [value.call(x,y)[:x], value.call(x,y)[:y]] if get_board_coord(value.call(x,y)[:x],value.call(x, y)[:y]) == ' '
      when 1 
        arr << [value.call(x,y)[:x], value.call(x,y)[:y]] unless value.call(x,y)[:no_put] || arr.empty?
      when 2,3
        arr << [value.call(x,y)[:x], value.call(x,y)[:y]] if get_board_coord(value.call(x,y)[:x],value.call(x,y)[:y]).respond_to?(:color) && get_board_coord(value.call(x,y)[:x],value.call(x,y)[:y]).color != get_board_coord(x,y).color
      end
      index += 1  
    end
    arr 
  end

  
  private

  def convert_human_coord_to_machine(x, y)
    { x: 7-y, y: x }
  end


  def create_board  
    board = Array.new(8) { Array.new(8) { ' ' } }
    #setus up black pieces
    board[0][0] = Rook.new('black')
    board[0][1] = Knight.new('black')
    board[0][2] = Bishop.new('black')
    board[0][3] = Queen.new('black')
    board[0][4] = King.new('black')
    board[0][5] = Bishop.new('black')
    board[0][6] = Knight.new('black')
    board[0][7] = Rook.new('black')
    board[1].fill { |x| Pawn.new('black') }
    #sets up white pieces
    board[7][0] = Rook.new('white')
    board[7][1] = Knight.new('white')
    board[7][2] = Bishop.new('white')
    board[7][3] = Queen.new('white')
    board[7][4] = King.new('white')
    board[7][5] = Bishop.new('white')
    board[7][6] = Knight.new('white')
    board[7][7] = Rook.new('white')
    board[6].fill { |x| Pawn.new('white') }
    board
  end

end

b = Board.new

puts b.display_board
