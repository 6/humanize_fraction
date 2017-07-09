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
        [1, 11, "one eleventh"],
        [1, 100, "one one hundredth"],
        [1, 1_000, "one one thousandth"],
        [1, 10_000, "one ten thousandth"],
        [5, 10_000, "five ten thousandths"],
        [5, 10_001, "five ten thousand firsts"],
        [1, 1_000_000, "one one millionth"],
        [1, 1000000000000000000000000000, "one one octillionth"],
      ].each do |numerator, denominator, expected_output|
        context "#{numerator}/#{denominator}" do
          subject { described_class.new(numerator: numerator, denominator: denominator).to_s(shorthand: false, quarter: false) }

          it { is_expected.to eq(expected_output) }
        end
      end
    end

    context "with option {shorthand: true}" do
      [
        [1, 2, "a half"],
        [1, 3, "a third"],
        [1, 8, "an eighth"],
        [1, 11, "an eleventh"],
        [1, 10, "a tenth"],
        [1, 80, "an eightieth"],
        [1, 100, "a hundredth"],
        [1, 111, "a one hundred eleventh"],
        [1, 1_000, "a thousandth"],
        [1, 10_000, "a ten thousandth"],
        [1, 11_000, "an eleven thousandth"],
        [1, 1_000_000, "a millionth"],
        [1, 1000000000000000000000000000, "an octillionth"],
      ].each do |numerator, denominator, expected_output|
        context "#{numerator}/#{denominator}" do
          subject { described_class.new(numerator: numerator, denominator: denominator).to_s(shorthand: true) }

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
          subject { described_class.new(numerator: numerator, denominator: denominator).to_s(quarter: true) }

          it { is_expected.to eq(expected_output) }
        end
      end
    end

    context "with whole_part" do
      [
        [0, 3, 4, "zero and three fourths"],
        [1, 1, 4, "one and one fourth"],
        [220, 220, 230, "two hundred and twenty and two hundred and twenty two hundred thirtieths"],
      ].each do |whole_part, numerator, denominator, expected_output|
        context "#{whole_part} #{numerator}/#{denominator}" do
          subject { described_class.new(whole_part: whole_part, numerator: numerator, denominator: denominator).to_s }

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
        context string do
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
        context string do
          subject { described_class.from_string(string).to_s(options) }

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
        context string do
          subject { described_class.from_string(string).to_s }

          it { is_expected.to eq(expected_output) }
        end
      end
    end

    context "invalid fractions" do
      [
        "not a fraction",
        "1/0",
        "1/a",
        "a/1",
        "1/2a2",
        123,
        nil,
        "",
      ].each do |string|
        context string do
          it "raises ArgumentError" do
            expect { HumanizeFraction::Humanizer.from_string(string) }.to raise_error(ArgumentError)
          end
        end
      end
    end
  end
end
