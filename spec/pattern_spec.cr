require "./spec_helper.cr"

class TestPattern < Pattern
  def pattern_at(p : CTuple) : Color
    Color.new(p.x,p.y,p.z)
  end
end

describe Pattern do
  describe TestPattern do
    describe "#new" do
      p = TestPattern.new
      
      it "transform defaults to identity matrix" do
        p.transform.should eq(Matrix.identity)
      end
    end
    describe "#transform" do
      it "assigns a transform" do
        p = TestPattern.new
        p.transform = Transform.translate(1, 2, 3)
        p.transform.should eq(Transform.translate(1, 2, 3))
      end
      it "with an object transformation" do
        s = Sphere.new
        s.transform = Transform.scale(2, 2, 2)

        p = TestPattern.new
        
        c = p.pattern_at_object(s, Point.new(2, 3, 4))
        c.should eq(Color.new(1, 1.5, 2))
      end
      it "with a pattern transformation" do
        s = Sphere.new
        p = TestPattern.new

        p.transform = Transform.scale(2, 2, 2)

        c = p.pattern_at_object(s, Point.new(2, 3, 4))
        c.should eq(Color.new(1,1.5,2))
      end
      it "with both an object and a pattern transformation" do
        s = Sphere.new
        s.transform = Transform.scale(2, 2, 2)

        p = TestPattern.new
        p.transform = Transform.translate(0.5, 1, 1.5)
        
        c = p.pattern_at_object(s, Point.new(2.5, 3, 3.5))
        c.should eq(Color.new(0.75, 0.5, 0.25))
      end
    end
  end
  describe StripePattern do
    describe "#new" do
      it "creates a new stripe pattern" do
        p = StripePattern.new(Color.white, Color.black)

        p.a.should eq(Color.white)
        p.b.should eq(Color.black)
      end
    end
    describe "#pattern_at" do
      it "is constant in y" do
        p = StripePattern.new(Color.white, Color.black)
        p.pattern_at(Point.new(0, 0, 0)).should eq(Color.white)
        p.pattern_at(Point.new(0, 1, 0)).should eq(Color.white)
        p.pattern_at(Point.new(0, 2, 0)).should eq(Color.white)
      end

      it "is constant in z" do
        p = StripePattern.new(Color.white, Color.black)

        p.pattern_at(Point.new(0, 0, 0)).should eq(Color.white)
        p.pattern_at(Point.new(0, 0, 1)).should eq(Color.white)
        p.pattern_at(Point.new(0, 0, 2)).should eq(Color.white)
      end

      it "alternates in x" do
        p = StripePattern.new(Color.white, Color.black)
        p.pattern_at(Point.new(0, 0, 0)).should eq(Color.white)
        p.pattern_at(Point.new(0.9, 0, 0)).should eq(Color.white)
        p.pattern_at(Point.new(1, 0, 0)).should eq(Color.black)
        p.pattern_at(Point.new(-0.1, 0, 0)).should eq(Color.black)
        p.pattern_at(Point.new(-1, 0, 0)).should eq(Color.black)
        p.pattern_at(Point.new(-1.1, 0, 0)).should eq(Color.white)
      end
    end
    describe "#pattern_at_object" do
      it "stripes with an object transformation" do
        obj = Sphere.new
        obj.transform = Transform.scale(2, 2, 2)
        p = StripePattern.new(Color.white, Color.black)
        c = p.pattern_at_object(obj, Point.new(1.5, 0, 0))

        c.should eq(Color.white)
      end
    end
    describe "#transform" do
      it "stripes with a pattern transformation" do
        obj = Sphere.new
        p = StripePattern.new(Color.white, Color.black)
        p.transform = Transform.scale(2, 2, 2)
        c = p.pattern_at_object(obj, Point.new(1.5, 0, 0))

        c.should eq(Color.white)
      end
      it "stripes with both an object and a pattern transformation" do
        obj = Sphere.new
        obj.transform = Transform.scale(2, 2, 2)
        p = StripePattern.new(Color.white, Color.black)
        p.transform = Transform.scale(2, 2, 2)
        c = p.pattern_at_object(obj, Point.new(2.5, 0, 0))

        c.should eq(Color.white)
      end
    end
  end
  describe GradientPattern do
    it "a gradient linearly interpolates between colors" do
      p = GradientPattern.new(Color.white, Color.black)

      p.pattern_at(Point.new(0, 0, 0)).should eq(Color.white)
      p.pattern_at(Point.new(0.25, 0, 0)).should eq(Color.new(0.75, 0.75, 0.75))
      p.pattern_at(Point.new(0.5, 0, 0)).should eq(Color.new(0.5, 0.5, 0.5))
      p.pattern_at(Point.new(0.75, 0, 0)).should eq(Color.new(0.25, 0.25, 0.25))
    end
  end
  describe RingPattern do
    it "a ring should extend in both x and z" do
      p = RingPattern.new(Color.white, Color.black)

      p.pattern_at(Point.new(0, 0, 0)).should eq(Color.white)
      p.pattern_at(Point.new(1, 0, 0)).should eq(Color.black)
      p.pattern_at(Point.new(0, 0, 1)).should eq(Color.black)
      p.pattern_at(Point.new(0.708, 0, 0.708)).should eq(Color.black)
    end
  end
  describe CheckerPattern do
    it "checkers should repeat in x" do
      p = CheckerPattern.new(Color.white, Color.black)

      p.pattern_at(Point.new(0, 0, 0)).should eq(Color.white)
      p.pattern_at(Point.new(0.99, 0, 0)).should eq(Color.white)
      p.pattern_at(Point.new(1.01, 0, 0)).should eq(Color.black)
    end

    it "checkers should repeat in y" do
      p = CheckerPattern.new(Color.white, Color.black)

      p.pattern_at(Point.new(0, 0, 0)).should eq(Color.white)
      p.pattern_at(Point.new(0, 0.99, 0)).should eq(Color.white)
      p.pattern_at(Point.new(0, 1.01, 0)).should eq(Color.black)
    end

    it "checkers should repeat in z" do
      p = CheckerPattern.new(Color.white, Color.black)

      p.pattern_at(Point.new(0, 0, 0)).should eq(Color.white)
      p.pattern_at(Point.new(0, 0, 0.99)).should eq(Color.white)
      p.pattern_at(Point.new(0, 0, 1.01)).should eq(Color.black)
    end
  end
end
