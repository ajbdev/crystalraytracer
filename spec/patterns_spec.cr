require "./spec_helper.cr"

describe Patterns do
  describe "#new" do
    it "creates a new stripe pattern" do
      p = StripePattern.new(Color.white, Color.black)

      expect(p.a).to eq(Color.white)
      expect(p.b).to eq(Color.black)
    end

    it "is constant in y" do
      p = StripePattern.new(Color.white, Color.black)
      expect(p.stripe_at(Point.new(0,0,0))).to eq(Color.white)
      expect(p.stripe_at(Point.new(0,1,0))).to eq(Color.white)
      expect(p.stripe_at(Point.new(0,2,0))).to eq(Color.white)
    end

    it "alternates in z" do
      p = StripePattern.new(Color.white, Color.black)
      expect(p.stripe_at(Point.new(0,0,0))).to eq(Color.white)
      expect(p.stripe_at(Point.new(0.9,0,0))).to eq(Color.white)
      expect(p.stripe_at(Point.new(1,0,0))).to eq(Color.black)
      expect(p.stripe_at(Point.new(-0.1,0,0))).to eq(Color.black)
      expect(p.stripe_at(Point.new(-1,0,0))).to eq(Color.black)
      expect(p.stripe_at(Point.new(-1.1,0,0))).to eq(Color.white)
    end
  end
end