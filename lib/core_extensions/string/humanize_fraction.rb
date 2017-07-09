module CoreExtensions
  module String
    module HumanizeFraction
      def humanize_fraction(options = {})
        FractionToWords.from_string(self, options).to_s
      end
    end
  end
end
