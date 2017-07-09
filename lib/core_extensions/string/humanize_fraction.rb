module CoreExtensions
  module String
    module HumanizeFraction
      def humanize_fraction(options = {})
        ::HumanizeFraction::Humanizer.from_string(self, options).to_s
      end
    end
  end
end
