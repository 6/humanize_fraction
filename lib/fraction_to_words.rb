require "active_support/inflector"
require "humanize"
require "twitter_cldr"

require "fraction_to_words/version"

class FractionToWords
  attr_reader :numerator, :denominator, :options

  def initialize(numerator, denominator, options = {})
    [numerator, denominator].each do |number|
      if !number.is_a?(Integer)
        raise ArgumentError, "Expected Integer but got #{number.class.name}"
      end
    end
    @numerator = numerator
    @denominator = denominator
    @options = options
  end

  def to_s
    words = []
    words << humanize_numerator
    words << humanize_denominator
    words.join(" ")
  end

  private

  def humanize_numerator
    number = if numerator == 1 && !options[:always_spell_out]
      first_digit(denominator) == 8 ? "an" : "a"
    else
      numerator.humanize
    end
    number
  end

  def humanize_denominator
    number = case denominator
    when 2
      "half"
    when 4
      "quarter"
    else
      denominator.localize(:en).to_rbnf_s("SpelloutRules", "spellout-ordinal")
    end
    if numerator != 1
      number = ActiveSupport::Inflector.pluralize(number)
    end
    number
  end

  def first_digit(number)
    number.to_s.split("").first.to_i
  end
end
