describe HumanizeFraction::Humanizer do
  describe "#to_s" do
    context "with options {shorthand: false, quarter: false}" do
      [
        [0, 2, "zero halves"],
        [1, 2, "one half"],
        [2, 2, "two halves"],
        [0, 3, "zero thirds"],
        [1, 3, "one third"],
        [2, 3, "two thirds"],
        [3, 3, "three thirds"],
        [1, 4, "one fourth"],
        [1, 8, "one eighth"],
        [2, 8, "two eighths"],
        [2, 500, "two five hundredths"],
        [1, 523, "one five hundred twenty-third"],
        [2, 523, "two five hundred twenty-thirds"],
        [1, 10, "one tenth"],
        [1, 100, "one one hundredth"],
        [1, 1_000, "one one thousandth"],
        [1, 10_000, "one ten thousandth"],
        [5, 10_000, "five ten thousandths"],
        [5, 10_001, "five ten thousand firsts"],
        [1, 1_000_000, "one one millionth"],
      ].each do |numerator, denominator, expected_output|
        context "#{numerator}/#{denominator}" do
          subject { described_class.new(numerator: numerator, denominator: denominator, shorthand: false, quarter: false).to_s }

          it { is_expected.to eq(expected_output) }
        end
      end
    end

    context "with option {shorthand: true}" do
      [
        [1, 2, "a half"],
        [1, 3, "a third"],
        [1, 8, "an eighth"],
        [1, 10, "a tenth"],
        [1, 100, "a hundredth"],
        [1, 1_000, "a thousandth"],
        [1, 10_000, "a ten thousandth"],
        [1, 1_000_000, "a millionth"],
      ].each do |numerator, denominator, expected_output|
        context "#{numerator}/#{denominator}" do
          subject { described_class.new(numerator: numerator, denominator: denominator, shorthand: true).to_s }

          it { is_expected.to eq(expected_output) }
        end
      end
    end

    context "with option {quarter: true}" do
      [
        [0, 4, "zero quarters"],
        [1, 4, "one quarter"],
        [3, 4, "three quarters"],
      ].each do |numerator, denominator, expected_output|
        context "#{numerator}/#{denominator}" do
          subject { described_class.new(numerator: numerator, denominator: denominator, quarter: true).to_s }

          it { is_expected.to eq(expected_output) }
        end
      end
    end

    context "with integer_part" do
      [
        [0, 3, 4, "zero and three fourths"],
        [1, 1, 4, "one and one fourth"],
        [220, 220, 230, "two hundred and twenty and two hundred and twenty two hundred thirtieths"],
      ].each do |integer_part, numerator, denominator, expected_output|
        context "#{integer_part} #{numerator}/#{denominator}" do
          subject { described_class.new(integer_part: integer_part, numerator: numerator, denominator: denominator).to_s }

          it { is_expected.to eq(expected_output) }
        end
      end
    end
  end

  describe ".from_string" do
    context "mixed fraction, no options" do
      [
        ["0 3/4", "zero and three fourths"],
        ["1 1/4", "one and one fourth"],
        ["201 3/12", "two hundred and one and three twelfths"],
      ].each do |string, expected_output|
        context "#{string}" do
          subject { described_class.from_string(string).to_s }

          it { is_expected.to eq(expected_output) }
        end
      end
    end

    context "mixed fraction with options"  do
      [
        ["0 3/4", {quarter: true, shorthand: true}, "zero and three quarters"],
        ["1 1/2", {quarter: true, shorthand: true}, "one and a half"],
      ].each do |string, options, expected_output|
        context "#{string}" do
          subject { described_class.from_string(string, options).to_s }

          it { is_expected.to eq(expected_output) }
        end
      end
    end

    context "single fraction" do
      [
        ["3/4", "three fourths"],
        ["1/4", "one fourth"],
        ["3/12", "three twelfths"],
      ].each do |string, expected_output|
        context "#{string}" do
          subject { described_class.from_string(string).to_s }

          it { is_expected.to eq(expected_output) }
        end
      end
    end
  end
end
