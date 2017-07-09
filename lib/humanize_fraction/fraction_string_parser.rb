# This class takes a fraction string (e.g. "1 3/4") and parses it into the
# individual fraction components of whole_part, numerator, and denominator.
module HumanizeFraction
  class FractionStringParser
    # From: https://github.com/thechrisoshow/fractional/blob/master/lib/fractional.rb
    SINGLE_FRACTION = /\A\s*(\-?\d+)\s*\/\s*(\-?\d+)\s*\z/
    MIXED_FRACTION = /\A\s*(\-?\d*)\s+(\d+)\s*\/\s*(\d+)\s*\z/

    attr_reader :string
    sig String,
    def initialize(string)
      @string = string
    end

    def fraction_components
      @fraction_components ||= begin
        if string_is_mixed_fraction?
          mixed_fraction_components
        elsif string_is_single_fraction?
          single_fraction_components
        else
          raise ArgumentError, "Unable to extract fraction from string #{string}"
        end
      end
    end

    private

    def mixed_fraction_components
      whole_part, numerator, denominator = string.scan(MIXED_FRACTION).flatten.map(&:to_i)
      components = {whole_part: whole_part, numerator: numerator, denominator: denominator}
      validate_fraction_components(components)
      components
    end

    def single_fraction_components
      numerator, denominator = string.split("/").map(&:to_i)
      components = {whole_part: nil, numerator: numerator, denominator: denominator}
      validate_fraction_components(components)
      components
    end

    def string_is_mixed_fraction?
      string.match(MIXED_FRACTION)
    end

    def string_is_single_fraction?
      string.match(SINGLE_FRACTION)
    end

    def validate_fraction_components(components)
      if components[:denominator].zero?
        raise ArgumentError, "Unable to parse fraction with zero denominator"
      end
    end
  end
end
