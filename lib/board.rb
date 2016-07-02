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
    print "  A B C D E F G H\n\n"
  end

  def set_board_coord(x, y, value)
    machine_coords = convert_human_coord_to_machine(x, y)
    board[machine_coords[:x]][machine_coords[:y]] = value
  end

  def new_king
    p = King.new("white")
  end

  #uses duck type
  def get_possible_moves(x, y)
    piece = get_board_coord(x, y)
    lambs = piece.possible_moves.values
    arr = []
    lambs.each do |lamb|
      index = 1
      loop do
        new_arr = []
        new_arr << lamb.call(x, y, index)[:x]
        new_arr << lamb.call(x, y, index)[:y]
        break if new_arr.any? { |ele| ele < 0 } || lamb.call(x, y, index)[:breaker] || get_board_coord(new_arr[0], new_arr[1]) != ' '
        arr << new_arr
        index += 1
      end
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
    #board[6].fill { |x| Pawn.new('white') }
    board
  end

end

b = Board.new

puts b.display_board
puts b.get_possible_moves(0,0).inspect

