require "./spec_helper.cr"

describe Ray do
  describe "#new" do
    it "creates a ray with a point and a vector" do
      origin = Point.new(1, 2, 3)
      direction = Vector.new(4, 5, 6)
      r = Ray.new(origin, direction)
      r.origin.should eq origin
      r.direction.should eq direction
    end
  end
  describe "#position" do
    it "computes a point from a distance" do
      r = Ray.new(Point.new(2, 3, 4), Vector.new(1, 0, 0))
      r.position(0).should eq Point.new(2,3,4)
      r.position(1).should eq Point.new(3,3,4)
      r.position(-1).should eq Point.new(1, 3, 4)
      r.position(2.5).should eq Point.new(4.5, 3, 4)
    end
  end
  describe "ray intersection" do
    it "intersects a sphere at two points" do
      r = Ray.new(Point.new(0, 0, -5), Vector.new(0, 0, 1))
      s = Shapes::Sphere.new()
      xs = s.intersect(r)
      xs.size.should eq 2
      xs.[0]?.should eq 4.0
      xs.[1]?.should eq 6.0
    end
    it "intersects a sphere at a tangent" do
      r = Ray.new(Point.new(0, 1, -5), Vector.new(0, 0, 1))
      s = Shapes::Sphere.new()
      xs = s.intersect(r)
      xs.size.should eq 2
      xs[0]?.should eq 5.0
      xs[1]?.should eq 5.0
    end
    it "misses a sphere" do
      r = Ray.new(Point.new(0, 2, -5), Vector.new(0, 0, 1))
      s = Shapes::Sphere.new()
      xs = s.intersect(r)
      xs.size.should eq 0
    end
    it "orginates inside a sphere" do
      r = Ray.new(Point.new(0, 0, 0), Vector.new(0, 0, 1))
      s = Shapes::Sphere.new()
      xs = s.intersect(r)
      xs.size.should eq 2
      xs[0]?.should eq -1.0
      xs[1]?.should eq 1.0
    end
    it "sphere is behind a ray" do
      r = Ray.new(Point.new(0,0,5), Vector.new(0,0,1))
      s = Shapes::Sphere.new()
      xs = s.intersect(r)
      xs.size.should eq 2
      xs[0]?.should eq -6.0
      xs[1]?.should eq -4.0
    end
  end

end