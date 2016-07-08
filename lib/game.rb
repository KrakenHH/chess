class Game
  require_relative "./pieces/piece_helper.rb"
  require_relative "player.rb"
  require_relative "board.rb"
  require 'yaml'

  attr_reader :white_player, :black_player, :board


  def initialize
    load if File.exist?('save_file.yaml') && load_game?
    @white_player = create_white_player
    @black_player = create_black_player
    @board = Board.new
  end

  def play(loaded = false)
    loop do
      player_turn(white_player)
      if board.checkmate?(black_player.color) 
        victory_response(white_player)
        break
      end
      player_turn(black_player)
      if board.checkmate?(white_player.color)
        victory_response(black_player)
        break
      end
      show_board
      break if save_game?
    end
  end

  def load_game?
    puts "Would you like to load your previously saved game? Type 'l' to load, enter anything else to start a new game"
    return true if gets.chomp == 'l'
    false
  end

  def save_game?
    puts "type 's' to save game, enter anything else to continue playing"
    if gets.chomp == 's'
      save
      return true
    end
    false
  end

  def load
    yaml_string = ''
    File.open("save_file.yaml", "r") do |f|
      yaml_string = f.read
    end
     yaml_data = YAML::load_stream(yaml_string)
     yaml_data[0].play(true)
  end

  def save
    File.open("save_file.yaml", "w") do |f|
      f.puts YAML::dump(self)
    end
  end

  def victory_response(player)
    show_board
    puts "Checkmate. #{player.name}, you win."
  end

  def player_turn(player)
    show_board
    if board.check?(player.color)
      puts "you are in check"
      player_move_piece(player)
    else
      player_move_piece(player)
    end
    board.pawns_to_queens
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

  #returns [x, y] of player's selected move piece
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



