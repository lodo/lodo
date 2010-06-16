# Trekktabellene har fem kolonner. De inneholder:
# Kolonne 1 (A)   Tabellnummer  4 posisjoner  -- "table_name"
#
# Kolonne 2 (B)                               -- "period_length"
#
# Trekkperiode:
# 1: måned
# 2: 14 dager
# 3: uke
# 4: 4 dager
# 5: 3 dager
# 6: 2 dager
# 7: 1 dag
#
#   1 posisjon
#
#   Kolonne 3 (C)   Tabelltype                -- "tax_type"
#   0: Lønn
#   1: Pensjon
#
#   1 posisjon
#
#   Kolonne 4 (D)   Trekkgrunnlag   5 posisjoner    -- "gross_amount"
#   Kolonne 5 (E)   Trekk   5 posisjoner            -- "tax_amount"


# Trekktabeller. Contains the columns mentioned above,
# plus a column for the year this rate applies to.
#
# table_name is a string, the other columns are integers
class TaxRate < ActiveRecord::Base

  # TODO: implement according to:
  # https://skort.skatteetaten.no/skd/trekk/html/hjelpTrekk.html
  # http://www.lovdata.no/for/sf/fd/xd-20071221-1766.html
  def self.lookup(year, table_name, period_code, tax_type, gross_amount)
    first(:order => "gross_amount desc", :conditions => ["year = ? and table_name = ? and period_length = ? and tax_type = ? and gross_amount = ?", year, table_name, period_code, tax_type, round(tax_type, period_code, gross_amount)]).tax_amount
  end


  protected

  # I månedstabellen skal lønnsbeløpet (trekkgrunnlaget) avrundes nedover til nærmeste beløp som kan deles med 100, i 14-dagerstabellen til nærmeste beløp som er delelig med 50, og i uke- og dagtabellene til nærmeste beløp som er delelig med 20.
  #
  # For pensjonsbeløp (trekkgrunnlag) trekkes det etter den særskilte månedstabell for pensjon. Pensjonsbeløpet skal avrundes nedover til nærmeste beløp som kan deles med 100.
  #
  # Trekkgrunnlag (Avrundingsregler) 
  # https://skort.skatteetaten.no/skd/trekk/html/hjelpTrekk.html
  def self.round(tax_type, period_code, gross_amount)
    case tax_type
    when 1 # pensjon. rundes ned til nærmeste 100
      return gross_amount.to_i / 100 * 100
    when 0 # lønn, ikke pensjon
      case period_code
      when 1 # måned -- rundes ned til nærmeste 100
        return gross_amount.to_i / 100 * 100
      when 2 # 14 dager -- rundes ned til nærmeste 50
        return gross_amount.to_i / 50 * 50
      when 3,4,5,6,7 # uke, 4-1 dag(er) # rundes ned til nærmeste 20
        return gross_amount.to_i / 20 * 20
      else
        raise ArgumentError.new("Invalid period code")
      end # case period_code
    else
      raise ArgumentError.new("Invalid tax_type")
    end # case tax_type
    raise "Not supposed to reach this statement"
  end

end
