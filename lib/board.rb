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
      print "#{8-index}"
      row.each { |ele| print "|#{ele == ' ' ? ele : ele.get_unicode }" }
      print "|\n"
    end
    print "  a b c d e f g h\n\n"
  end

  def set_board_coord(x, y, value)
    machine_coords = convert_human_coord_to_machine(x, y)
    board[machine_coords[:x]][machine_coords[:y]] = value
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

  def checkmate?(color)
    king_coords = find_king_coords(color)
    enemy_pos_move_coords = get_enemy_possible_moves(color)
    times_includes = 0
    enemy_pos_move_coords.each { |coord| times_includes += 1 if coord == king_coords }
    return true if times_includes > 1
    false
  end

  #returns true if a king of a specific color is in check
  def check?(color)
    king_coords = find_king_coords(color)
    enemy_pos_move_coords = get_enemy_possible_moves(color)
    enemy_pos_move_coords.include?(king_coords)  
  end

  #returns array of possible enemy moves [x, y]
  def get_enemy_possible_moves(color)
    enemy_piece_coords = get_enemy_piece_positions(color)
    enemy_possible_move_coords = []
    enemy_piece_coords.each { |coord| get_possible_moves(coord[0],coord[1]).each { |pos_move| enemy_possible_move_coords << pos_move } }
    enemy_possible_move_coords
  end

  #returns an array of [x, y] arays enemy piece positions
  def get_enemy_piece_positions(color)
    x = 0
    y = 0
    pieces_coords = []
    until y == 8
      pieces_coords << [x, y] if get_board_coord(x, y).respond_to?(:color) && get_board_coord(x, y).color != color
      x+=1
      if x == 8
        x = 0
        y +=1
      end
      
    end
    pieces_coords     
  end

  #returns [x, y] of a specific king color
  def find_king_coords(color)
    x = 0
    y = 0
    until get_board_coord(x, y).is_a?(King) && get_board_coord(x, y).color == color
      x += 1
      if x == 8
        x = 0
        y += 1
      end
    end
    [x, y]
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


