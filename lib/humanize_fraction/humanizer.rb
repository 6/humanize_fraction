module HumanizeFraction
  class Humanizer
    # From: https://github.com/thechrisoshow/fractional/blob/master/lib/fractional.rb
    SINGLE_FRACTION = /\A\s*(\-?\d+)\/(\-?\d+)\s*\z/
    MIXED_FRACTION = /\A\s*(\-?\d*)\s+(\d+)\/(\d+)\s*\z/

    # Numbers that should be prefixed with `a` instead of `an` even though they
    # start with a vowel.
    NUMBERS_STARTING_WITH_SILENT_VOWEL = [
      "one",
    ]

    attr_reader :numerator, :denominator, :whole_part, :quarter, :shorthand

    def initialize(numerator:, denominator:, whole_part: nil, shorthand: false, quarter: false)
      [numerator, denominator].each do |number|
        if !number.is_a?(Integer)
          raise ArgumentError, "Expected Integers for numerator/denominator but got #{number.class.name}"
        end
      end
      if !whole_part.nil? && !whole_part.is_a?(Integer)
        raise ArgumentError, "Expected Integer or NilClass for whole_part but got #{whole_part.class.name}"
      end
      @whole_part = whole_part
      @numerator = numerator
      @denominator = denominator
      @shorthand = shorthand
      @quarter = quarter
    end
    alias_method :quarter?, :quarter
    alias_method :shorthand?, :shorthand

    def to_s
      humanized_denominator = humanize_denominator
      words = []
      words << humanize_whole_part if !whole_part.nil?
      words << humanize_numerator(humanized_denominator)
      words << humanized_denominator
      words.join(" ")
    end

    def self.from_string(string, options = {})
      if !string.is_a?(String)
        raise ArgumentError, "Expected String but got #{string.class.name}"
      end
      if string_is_mixed_fraction?(string)
        whole, numerator, denominator = string.scan(MIXED_FRACTION).flatten.map(&:to_i)
        new(whole_part: whole, numerator: numerator, denominator: denominator, **options)
      elsif string_is_single_fraction?(string)
        numerator, denominator = string.split("/").map(&:to_i)
        new(numerator: numerator, denominator: denominator, **options)
      else
        raise ArgumentError, "Unable to extract fraction from string #{string}"
      end
    end

    private

    def humanize_whole_part
      "#{whole_part.humanize} and"
    end

    def humanize_numerator(humanized_denominator)
      number = if numerator == 1 && shorthand?
        first_number = humanized_denominator.split(" ").first
        indefinite_article(first_number)
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
      if shorthand? && denominator >= 100 && one_followed_by_zeros?(denominator)
        number.sub!(/\Aone\s/, "")
      end
      if numerator != 1
        number = ActiveSupport::Inflector.pluralize(number)
      end
      number
    end

    # Checks number is a 1 followed by only zeros, e.g. 10 or 10000000
    def one_followed_by_zeros?(number)
      digits = number.to_s.split("")
      first_digit = digits.shift
      first_digit.to_i == 1 && digits.size > 0 && digits.map(&:to_i).all?(&:zero?)
    end

    def indefinite_article(humanized_number)
      if humanized_number.match(/\A[aeiou]/) &&
        !NUMBERS_STARTING_WITH_SILENT_VOWEL.include?(humanized_number)
        "an"
      else
        "a"
      end
    end

    def self.string_is_mixed_fraction?(value)
      value&.match(MIXED_FRACTION)
    end

    def self.string_is_single_fraction?(value)
      value&.match(SINGLE_FRACTION)
    end
  end
end
