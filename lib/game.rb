class Game
  require_relative "./pieces/piece_helper.rb"
  require_relative "player.rb"

  attr_reader :white_player, :black_player


  def initialize
    @white_player = create_white_player
    @black_player = create_black_player
  end



  private

  def create_white_player
    Player.new(get_player_name)
  end

  def create_black_player
    Player.new(get_player_name)

  end

  def get_player_name
    puts "White player, what is your name?"
    gets.chomp
  end


end

g = Game.new
