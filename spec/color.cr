require "./spec_helper.cr"

describe Color do
  describe "#new" do
    it "provides color attribute getters" do
      c = Color.new(-0.5, 0.4, 1.7)
      c.red.should eq -0.5
      c.green.should eq 0.4
      c.blue.should eq 1.7
    end

    it "has a default alpha of 1.0" do
      c = Color.new(0.1, 0.2, 0.3)
      c.alpha.should eq 1.0
    end
  end

  describe "#math" do
    it "adds colors" do
      a = Color.new(0.9, 0.6, 0.75)
      b = Color.new(0.7, 0.1, 0.25)

      (a + b).approximately({1.6, 0.7, 1.0}).should eq true
    end

    it "subtracts colors" do
      a = Color.new(0.9, 0.6, 0.75)
      b = Color.new(0.7, 0.1, 0.25)

      (a - b).approximately({ 0.2, 0.5, 0.5 }).should eq true
    end

    it "multiplies color by a scalar" do
      c = Color.new(0.2, 0.3, 0.4)

      (c * 2).approximately({ 0.4, 0.6, 0.8 }).should eq true
    end

    it "multiplies colors together" do
      a = Color.new(1, 0.2, 0.4)
      b = Color.new(0.9, 1, 0.1)

      (a * b).approximately({ 0.9, 0.2, 0.04 })
    end
  end
end