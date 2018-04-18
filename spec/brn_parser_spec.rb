describe Brn::Parser do
  before do
    @brn_parser = Brn::Parser.new
  end

  describe "integer" do
    it "single integer" do
      expect(@brn_parser.integer.parse("1")).to_not be_nil
    end

    it "multiple integers" do
      expect(@brn_parser.integer.parse("123")).to_not be_nil
    end

    it "non-integers" do
      expect(lambda{ @brn_parser.integer.parse("foo") }).to raise_error(Parslet::ParseFailed)
    end
  end

  describe "float" do
    it "simple float" do
      expect(@brn_parser.float.parse("1.2")).to_not be_nil
    end

    it "no-leading integer" do
      expect(@brn_parser.float.parse(".2")).to_not be_nil
    end

    it "no-trailing" do
      expect(lambda{ @brn_parser.integer.parse("10.") }).to raise_error(Parslet::ParseFailed)
    end
  end

  describe "number" do
    it "integer" do
      expect(@brn_parser.number.parse("1")).to_not be_nil
    end

    it "float" do
      expect(@brn_parser.number.parse("1.2")).to_not be_nil
    end
  end

  describe "word" do
    it "single letter" do
      expect(@brn_parser.word.parse("a")).to_not be_nil
    end

    it "multiple letters" do
      expect(@brn_parser.word.parse("aBcD")).to_not be_nil
    end

    it "numbers" do
      expect(@brn_parser.word.parse("12")).to_not be_nil
    end

    it "numbers and letters" do
      expect(@brn_parser.word.parse("1AbV2")).to_not be_nil
    end

    it "numbers, letters, and dashes" do
      expect(@brn_parser.word.parse("5-Flo")).to_not be_nil
    end
  end

  describe "frequency" do
    it "x2" do
      expect(@brn_parser.frequency.parse("x2")).to_not be_nil
    end

    it "q12h" do
      expect(@brn_parser.frequency.parse("q12h")).to_not be_nil
    end

    it "q13h (bad)" do
      expect(->{@brn_parser.frequency.parse("")}).to raise_error(Parslet::ParseFailed)
    end
  end

  describe "drug_sig" do
    it "parses" do
      expect(@brn_parser.drug_sig.parse("Bleomycin 10.0 IU/m^2")).to_not be_nil
    end
  end
end
