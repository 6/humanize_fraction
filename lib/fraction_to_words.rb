require "active_support/inflector"
require "humanize"
require "twitter_cldr"

require "core_extensions/string/humanize_fraction"
require "fraction_to_words/version"

class FractionToWords
  # From: https://github.com/thechrisoshow/fractional/blob/master/lib/fractional.rb
  SINGLE_FRACTION = /^\s*(\-?\d+)\/(\-?\d+)\s*$/
  MIXED_FRACTION = /^\s*(\-?\d*)\s+(\d+)\/(\d+)\s*$/

  attr_reader :numerator, :denominator, :integer_part, :quarter, :shorthand

  def initialize(numerator:, denominator:, integer_part: nil, shorthand: false, quarter: false)
    [numerator, denominator].each do |number|
      if !number.is_a?(Integer)
        raise ArgumentError, "Expected Integers for numerator/denominator but got #{number.class.name}"
      end
    end
    if !integer_part.nil? && !integer_part.is_a?(Integer)
      raise ArgumentError, "Expected Integer or NilClass for integer_part but got #{integer_part.class.name}"
    end
    @integer_part = integer_part
    @numerator = numerator
    @denominator = denominator
    @shorthand = shorthand
    @quarter = quarter
  end
  alias_method :quarter?, :quarter
  alias_method :shorthand?, :shorthand

  def to_s
    words = []
    words << humanize_integer_part if !integer_part.nil?
    words << humanize_numerator
    words << humanize_denominator
    words.join(" ")
  end

  def self.from_string(string, options = {})
    if !string.is_a?(String)
      raise ArgumentError, "Expected String but got #{string.class.name}"
    end
    if string_is_mixed_fraction?(string)
      whole, numerator, denominator = string.scan(MIXED_FRACTION).flatten.map(&:to_i)
      new(integer_part: whole, numerator: numerator, denominator: denominator, **options)
    elsif string_is_single_fraction?(string)
      numerator, denominator = string.split("/").map(&:to_i)
      new(numerator: numerator, denominator: denominator, **options)
    else
      raise ArgumentError, "Unable to extract fraction from string #{string}"
    end
  end

  private

  def humanize_integer_part
    "#{integer_part.humanize} and"
  end

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

  def self.string_is_mixed_fraction?(value)
    value&.match(MIXED_FRACTION)
  end

  def self.string_is_single_fraction?(value)
    value&.match(SINGLE_FRACTION)
  end
end
