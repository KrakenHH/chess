require_relative '../lib/board.rb'

describe Board do

  let(:board) { Board.new }

  describe "#initialize" do

    it "initializes a board that is set up" do
      expect(board).to respond_to(:board)
    end

    it "places the pieces in the correct places" do
      expect(board.get_board_coord(0,0)).to be_a(Rook)
      expect(board.get_board_coord(0,0).color).to eq('white')
      expect(board.get_board_coord(0,7)).to be_a(Rook)
      expect(board.get_board_coord(0,7).color).to eq('black')
    end
  end

  describe "#set_board_coord(x, y, value)" do

    it "sets the given coordinate to the correct value" do
      board.set_board_coord(3, 7, 'd')
      expect(board.get_board_coord(3,7)).to eql('d')
      board.set_board_coord(4, 2, 'z')
      expect(board.get_board_coord(4,2)).to eql('z')
    end
  end

  describe "#get_board_coord(x, y)" do
      it { expect(board.get_board_coord(0,3)).to eq(' ') }
      it { expect(board.get_board_coord(0,4)).to eq(' ') }
      it { expect(board.get_board_coord(1,1)).to be_a(Pawn) }
      it { expect(board.get_board_coord(4,0)).to be_a(King) }
  end

  describe "#get_possible_moves(x,y)" do

    context "given an x,y position on the human grid of a piece" do
      it "returns an array of [x,y] possible move coordinates" do
        expect(board.get_possible_moves(0,1)).to match_array( [[0,2],[0,3]] )
        expect(board.get_possible_moves(1,0)).to match_array( [[0,2],[2,2]] )
        expect(board.get_possible_moves(2,0)).to match_array( [] )
      end
    end

    context "pawn with an enemy diagonal" do
      it "pawn can jump this enemy" do
        board.set_board_coord(1, 2, Pawn.new('black'))
        expect(board.get_possible_moves(0,1)).to match_array( [[0,2],[0,3],[1,2]])
      end
    end

    context "pawn with enemy directly in front" do
      it "pawn can not jump in front, nor jump over enemy" do
        board.set_board_coord(0,2,Pawn.new('black'))
        expect(board.get_possible_moves(0,1)).to match_array([])
      end
    end

    context "pawn with enemy in double jump position" do
      it "pawn can only jump to space in front of it" do
        board.set_board_coord(0,3,Pawn.new('black')) 
        expect(board.get_possible_moves(0,1)).to match_array([[0,2]])
      end
    end

    context "bishop" do
      it "can move diagonally" do 
        board.set_board_coord(0,2,Bishop.new('white'))
        expect(board.get_possible_moves(0,2)).to match_array([[1,3],[2,4],[3,5],[4,6]])
      end

      it "cannot cross allied piece" do
        board.set_board_coord(0,2,Bishop.new('white'))
        board.set_board_coord(2,4,Pawn.new('white'))
        expect(board.get_possible_moves(0,2)).to match_array([[1,3]])
      end
    end
  end


  describe "#checkmate?(color)" do
    it "returns true if king is in checkmate" do
      expect(board.checkmate?('black')).to be_false
      board.set_board_coord(2,2,King.new('black'))
      board.set_board_coord(2,4,Queen.new('white'))
      expect(board.checkmate?('black')).to be_true
    end

    it "returns false if the king is only in check" do
      board.set_board_coord(6,3,Pawn.new('white'))
      expect(board.checkmate?('black')).to be_false
    end

  end

  describe "#check(color)" do
    it "returns true if the king is in check" do
      board.set_board_coord(6,3,Pawn.new('white'))
      expect(board.checkmate?('black')).to be_false
    end

  end

end