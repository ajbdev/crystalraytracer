require "./spec_helper.cr"

describe Pattern do
  describe StripePattern do
    it "creates a new stripe pattern" do
      p = StripePattern.new(Color.white, Color.black)

      p.a.should eq(Color.white)
      p.b.should eq(Color.black)
    end

    it "is constant in y" do
      p = StripePattern.new(Color.white, Color.black)
      p.stripe_at(Point.new(0,0,0)).should eq(Color.white)
      p.stripe_at(Point.new(0,1,0)).should eq(Color.white)
      p.stripe_at(Point.new(0,2,0)).should eq(Color.white)
    end

    it "is constant in z" do
      p = StripePattern.new(Color.white, Color.black)

      p.stripe_at(Point.new(0,0,0)).should eq(Color.white)
      p.stripe_at(Point.new(0,0,1)).should eq(Color.white)
      p.stripe_at(Point.new(0,0,2)).should eq(Color.white)
    end

    it "alternates in x" do
      p = StripePattern.new(Color.white, Color.black)
      p.stripe_at(Point.new(0,0,0)).should eq(Color.white)
      p.stripe_at(Point.new(0.9,0,0)).should eq(Color.white)
      p.stripe_at(Point.new(1,0,0)).should eq(Color.black)
      p.stripe_at(Point.new(-0.1,0,0)).should eq(Color.black)
      p.stripe_at(Point.new(-1,0,0)).should eq(Color.black)
      p.stripe_at(Point.new(-1.1,0,0)).should eq(Color.white)
    end
  end
end