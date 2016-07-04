class Game
  require_relative "./pieces/piece_helper.rb"
  require_relative "player.rb"
  require_relative "board.rb"

  attr_reader :white_player, :black_player, :board


  def initialize
    @white_player = create_white_player
    @black_player = create_black_player
    @board = Board.new
  end

  def play
    loop do
      player_turn(white_player)
      break if board.checkmate?(black_player.color)
      player_turn(black_player)
      break if board.checkmate?(white_player.color)
    end

  end

  def player_turn(player)
    show_board
    if board.check?(player.color)
      puts "you are in check"
      player_move_piece(player)
    else
      player_move_piece(player)
    end
  end

  def show_board
    board.display_board
  end



  def move_into_check_response
    puts "You are in check if you move here. Try again."
  end


  def player_move_piece(player)
    move_piece_xy = player_select_move_piece(player) #coordinates [x,y]
    destination_xy = player_select_valid_piece_destination #coordinates [x,y]
    move_piece = board.get_board_coord(move_piece_xy[0], move_piece_xy[1]) #move piece
    destination_piece = board.get_board_coord(destination_xy[0], destination_xy[1]) #destinaton piece of blank

    possible_moves = board.get_possible_moves(move_piece_xy[0], move_piece_xy[1])

    if possible_moves.include?(destination_xy)
      board.set_board_coord(destination_xy[0], destination_xy[1], move_piece)
      board.set_board_coord(move_piece_xy[0], move_piece_xy[1], ' ')
    else
      puts "this is not a valid move for that piece."
      player_move_piece(player)
    end
    if board.check?(player.color)
      board.set_board_coord(destination_xy[0], destination_xy[1], destination_piece)
      board.set_board_coord(move_piece_xy[0], move_piece_xy[1], move_piece)
      show_board
      move_into_check_response
      player_move_piece(player)
    end
  end

  #returms [x, y] of player's selected move piece
  def player_select_move_piece(player)
    puts "#{player.name}, select which piece you would like to move, in the form of A1, B3, etc"
    response_coords = player_select_coordinates
    move_piece = board.get_board_coord(response_coords[0], response_coords[1])
    if !move_piece.respond_to?(:color) || move_piece.color != player.color
      puts "#{player.name}, that's not a piece of yours. Please select another"
      response_coords = player_select_move_piece(player)
    end
    response_coords
  end

  #give [x, y] of where player would like to move piece
  def player_select_valid_piece_destination
    puts "Where would you like to move this piece?"
    response = player_select_coordinates
  end


  #returns arr with [x, y]
  def player_select_coordinates
    parse_response(get_a_valid_destination)
  end

  def get_a_valid_destination
    response = gets.chomp
    if !(146..160).include?(response.sum)
      puts 'please select a valid coordinate'
      response = get_a_valid_destination
    end
    response
  end

  def parse_response(response)
    x = convert_letter_to_coordinate(response[0].downcase)
    y = response[-1].to_i - 1
    [x, y] 
  end

  def convert_letter_to_coordinate(x)  
    x.ord - 97
  end

  def create_white_player
    Player.new(get_player_name('White'), 'white')
  end

  def create_black_player
    Player.new(get_player_name('Black'), 'black')

  end

  def get_player_name(color)
    puts "#{color} player, what is your name?"
    gets.chomp
  end


end

g = Game.new

g.play




