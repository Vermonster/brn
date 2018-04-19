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
