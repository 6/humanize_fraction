describe FractionToWords do
  it "has a version number" do
    expect(FractionToWords::VERSION).not_to be nil
  end

  describe "#to_s" do
    [
      [0, 2, "zero halves"],
      [1, 2, "a half"],
      [2, 2, "two halves"],
      [0, 3, "zero thirds"],
      [1, 3, "a third"],
      [2, 3, "two thirds"],
      [3, 3, "three thirds"],
      [0, 8, "zero eighths"],
      [1, 8, "an eighth"],
      [2, 8, "two eighths"],
    ].each do |numerator, denominator, expected_output|
      context "#{numerator}/#{denominator}" do
        subject { described_class.new(numerator, denominator).to_s }

        it { is_expected.to eq(expected_output) }
      end
    end
  end
end
