require_relative '../lib/board.rb'

describe Board do

  let(:board) { Board.new }

  describe "#set_board_coord(x, y, value)" do

    it "sets the given coordinate to the correct value" do
      board.set_board_coord(3, 7, 'd')
      expect(board.get_board_coord(3,7)).to eql('d')
      board.set_board_coord(4, 2, 'z')
      expect(board.get_board_coord(4,2)).to eql('z')
    end

  end




end