module HumanizeFraction
  class Humanizer
    # Numbers that should be prefixed with `a` instead of `an` even though they
    # start with a vowel.
    NUMBERS_STARTING_WITH_SILENT_VOWEL = [
      "one",
    ]

    attr_reader :numerator, :denominator, :whole_part

    def initialize(numerator:, denominator:, whole_part: nil)
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
    end

    def to_s(shorthand: false, quarter: false)
      humanized_denominator = humanize_denominator(shorthand: shorthand, quarter: quarter)
      words = []
      words << humanize_whole_part if !whole_part.nil?
      words << humanize_numerator(humanized_denominator, shorthand: shorthand)
      words << humanized_denominator
      words.join(" ")
    end

    def self.from_string(string, options = {})
      parser = FractionStringParser.new(string)
      new(**parser.fraction_components, **options)
    end

    private

    def humanize_whole_part
      "#{whole_part.humanize} and"
    end

    def humanize_numerator(humanized_denominator, shorthand:)
      number = if numerator == 1 && shorthand
        first_number = humanized_denominator.split(" ").first
        indefinite_article(first_number)
      else
        numerator.humanize
      end
      number
    end

    def humanize_denominator(shorthand:, quarter:)
      number = case denominator
      when 2
        "half"
      when 4
        quarter ? "quarter" : "fourth"
      else
        I18n.with_locale(:en) { denominator.to_words(ordinal: true) }
      end
      # Handle case of `a millionth`, `a thousandth`, etc.
      if shorthand && denominator >= 100 && one_followed_by_zeros?(denominator)
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
  end
end
