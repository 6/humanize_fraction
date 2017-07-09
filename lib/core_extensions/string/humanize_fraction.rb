module CoreExtensions
  module String
    module HumanizeFraction
      def humanize_fraction(options = {})
        ::HumanizeFraction::Humanizer.from_string(self).to_s(options)
      end
    end
  end
end
