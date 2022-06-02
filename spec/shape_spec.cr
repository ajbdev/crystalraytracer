require "./spec_helper.cr"

class TestShape < Shape
  def intersect(ray : Ray)
    Intersections.new
  end

  def normal_at(point : CTuple)
    Vector.new(point.x,point.y,point.z)
  end
end

describe Shape do
  describe TestShape do
    describe "#intersect" do
      it "returns a collection of intersections" do
        ts = TestShape.new
        r = Ray.new(Point.new(0,10,0), Vector.new(0,0,1))
        ts.intersect(r).class.should eq Intersections
      end
    end
    describe "#normal_at" do
      it "returns a vector" do
        ts = TestShape.new
        ts.normal_at(Point.new(1,0,0)).class.should eq Vector
      end
    end
  end
end
