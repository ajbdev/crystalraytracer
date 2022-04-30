require "./spec_helper.cr"

describe Pattern do
  describe StripePattern do
    describe "#new" do
      it "creates a new stripe pattern" do
        p = StripePattern.new(Color.white, Color.black)

        p.a.should eq(Color.white)
        p.b.should eq(Color.black)
      end
    end
    describe "#stripe_at" do
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
    describe "#stripe_at_object" do
      it "stripes with an object transformation" do
        obj = Sphere.new
        obj.transform = Transform.scale(2,2,2)
        p = StripePattern.new(Color.white, Color.black)
        c = p.stripe_at_object(obj, Point.new(1.5, 0, 0))
        
        c.should eq(Color.white)
      end
    end
    describe "#transform" do
      it "stripes with a pattern transformation" do
        obj = Sphere.new
        p = StripePattern.new(Color.white, Color.black)
        p.transform = Transform.scale(2,2,2)
        c = p.stripe_at_object(obj, Point.new(1.5,0,0))

        c.should eq(Color.white)
      end
      it "stripes with both an object and a pattern transformation" do
        obj = Sphere.new
        obj.transform = Transform.scale(2,2,2)
        p = StripePattern.new(Color.white, Color.black)
        p.transform = Transform.scale(2,2,2)
        c = p.stripe_at_object(obj, Point.new(2.5,0,0))

        c.should eq(Color.white)
      end
    end

    
  end
end