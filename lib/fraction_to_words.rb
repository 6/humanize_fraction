require "active_support/inflector"
require "humanize"
require "twitter_cldr"

require "fraction_to_words/version"

class FractionToWords
  attr_reader :numerator, :denominator, :quarter, :shorthand

  def initialize(numerator:, denominator:, shorthand: false, quarter: false)
    [numerator, denominator].each do |number|
      if !number.is_a?(Integer)
        raise ArgumentError, "Expected Integer but got #{number.class.name}"
      end
    end
    @numerator = numerator
    @denominator = denominator
    @shorthand = shorthand
    @quarter = quarter
  end
  alias_method :quarter?, :quarter
  alias_method :shorthand?, :shorthand

  def to_s
    words = []
    words << humanize_numerator
    words << humanize_denominator
    words.join(" ")
  end

  private

  def humanize_numerator
    number = if numerator == 1 && shorthand?
      # 8 is the only(?) case where you want to prefix with `an` instead of `a`.
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
      quarter? ? "quarter" : "fourth"
    else
      denominator.localize(:en).to_rbnf_s("SpelloutRules", "spellout-ordinal")
    end
    # Handle case of `a millionth`, `a thousandth`, etc.
    if shorthand? && denominator >= 100 &&
      first_digit(denominator) == 1 && remaining_digits_zeros?(denominator)
      number.sub!(/\Aone\s/, "")
    end
    if numerator != 1
      number = ActiveSupport::Inflector.pluralize(number)
    end
    number
  end

  def first_digit(number)
    number.to_s.split("").first.to_i
  end

  # Checks if everything after first digit are zeros.
  def remaining_digits_zeros?(number)
    numbers = number.to_s.split("")
    numbers.shift
    numbers.size > 0 && numbers.map(&:to_i).all?(&:zero?)
  end
end
