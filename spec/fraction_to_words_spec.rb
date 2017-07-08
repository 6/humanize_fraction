describe FractionToWords do
  it "has a version number" do
    expect(FractionToWords::VERSION).not_to be nil
  end

  describe "#to_s" do
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
      [1, 10_000, "one ten thousandth"],
      [5, 10_000, "five ten thousandths"],
      [5, 10_001, "five ten thousand firsts"],
    ].each do |numerator, denominator, expected_output|
      context "#{numerator}/#{denominator}" do
        subject { described_class.new(numerator, denominator).to_s }

        it { is_expected.to eq(expected_output) }
      end
    end

    context "with option {shorthand: true}" do
      [
        [1, 2, "a half"],
        [1, 3, "a third"],
        [1, 8, "an eighth"],
        [1, 10_000, "a ten thousandth"],
      ].each do |numerator, denominator, expected_output|
        context "#{numerator}/#{denominator}" do
          subject { described_class.new(numerator, denominator, shorthand: true).to_s }

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
          subject { described_class.new(numerator, denominator, quarter: true).to_s }

          it { is_expected.to eq(expected_output) }
        end
      end
    end
  end
end
