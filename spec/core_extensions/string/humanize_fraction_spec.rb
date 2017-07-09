describe CoreExtensions::String::HumanizeFraction do
  before do
    String.include(CoreExtensions::String::HumanizeFraction)
  end

  it "monkey-patches a humanize_fraction method to String" do
    expect("abc").to respond_to(:humanize_fraction)
  end

  context "with valid fractions" do
    it "humanizes fraction correctly" do
      expect("1/3".humanize_fraction).to eq("one third")
      expect("2 3/4".humanize_fraction).to eq("two and three fourths")
    end
  end

  context "with valid fractions and options" do
    it "humanizes fraction correctly" do
      expect("1/3".humanize_fraction(shorthand: true)).to eq("a third")
      expect("2 3/4".humanize_fraction(quarter: true)).to eq("two and three quarters")
    end
  end

  context "with valid fractions but invalid options" do
    it "raises ArgumentError" do
      expect { "1/3".humanize_fraction({invalid: "ok"}) }.to raise_error(ArgumentError)
    end
  end
end
