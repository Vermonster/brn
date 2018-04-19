require 'parslet'

module Brn
  class Parser < Parslet::Parser

    rule(:space) { match('\s').repeat(1) }
    
    rule(:integer) { match('[0-9]').repeat(1) }
    rule(:float) { integer.maybe >> str('.') >> integer }
    rule(:number) { float | integer }

    rule(:word) { match('[A-Za-z0-9\-]').repeat(1) }

    rule(:drug_unit) {
      %w(
        mg/m^2
        ug/m^2
        IU/m^2
        g/m^2
        g/kg
        mg/kg
        ug/kg
        IU/kg
        AUC
        mg
        ug
        IU
        g
      ).map{|unit_name| str(unit_name) }.reduce(:|)
    }

    rule(:frequency) {
      %w(
        q12h
        q3h
        q6h
        q4h
        tid
        q2h
        qhs
        bid
        qid
        prn
        qd
        po
        pc
        qh
        ac
        x4
        x3
        x2
        x1
      ).map{|frequency_name| str(frequency_name)}.reduce(:|)
    }

    # Procarbazine 100.0 mg/m^2 po qd d1-7
    
    rule(:drug_sig) { 
      word.as(:drug_name) >> 
      space >> 
      number.as(:base_dose) >> 
      space >> 
      drug_unit.as(:base_dose_unit) 
    }

  end
end



require 'minitest/autorun'
describe Brn::Parser do

  before do
    @brn_parser = Brn::Parser.new
  end

  describe "integer" do
    it "single integer" do
      @brn_parser.integer.parse("1").wont_be_nil
    end

    it "multiple integers" do
      @brn_parser.integer.parse("123").wont_be_nil
    end

    it "non-integers" do
      lambda{ @brn_parser.integer.parse("foo") }.must_raise(Parslet::ParseFailed)
    end
  end

  describe "float" do
    it "simple float" do
      @brn_parser.float.parse("1.2").wont_be_nil
    end

    it "no-leading integer" do
      @brn_parser.float.parse(".2").wont_be_nil
    end

    it "no-trailing" do
      lambda{ @brn_parser.integer.parse("10.") }.must_raise(Parslet::ParseFailed)
    end
  end

  describe "number" do
    it "integer" do
      @brn_parser.number.parse("1").wont_be_nil
    end

    it "float" do
      @brn_parser.number.parse("1.2").wont_be_nil
    end
  end

  describe "word" do
    it "single letter" do
      @brn_parser.word.parse("a").wont_be_nil
    end

    it "multiple letters" do
      @brn_parser.word.parse("aBcD").wont_be_nil
    end

    it "numbers" do
      @brn_parser.word.parse("12").wont_be_nil
    end
    
    it "numbers and letters" do
      @brn_parser.word.parse("1AbV2").wont_be_nil
    end

    it "numbers, letters, and dashes" do
      @brn_parser.word.parse("5-Flo").wont_be_nil
    end
  end

  describe "frequency" do
    it "x2" do
      @brn_parser.frequency.parse("x2").wont_be_nil
    end
    it "q12h" do
      @brn_parser.frequency.parse("q12h").wont_be_nil
    end
    it "q13h (bad)" do
      ->{@brn_parser.frequency.parse("")}.must_raise Parslet::ParseFailed
    end
  end

  describe "drug_sig" do
    it "parses" do
      @brn_parser.drug_sig.parse("Bleomycin 10.0 IU/m^2").wont_be_nil
    end
  end

end
