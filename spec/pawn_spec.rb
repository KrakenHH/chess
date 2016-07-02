require_relative '../lib/pieces/pawn.rb'


describe Pawn do

  describe "#get_unicode(color)" do
    it "returns the appropriate unicode for the color" do
      expect(Pawn.new('black').get_unicode).to eql("\u265f")
      expect(Pawn.new('white').get_unicode).to eql("\u2659")
    end

  end  


end