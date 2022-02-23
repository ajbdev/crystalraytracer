require "./spec_helper.cr"

describe Shape do
  describe Sphere do
    describe "#new" do
      it "ensures two spheres are not the same value" do
        a = Sphere.new
        b = Sphere.new
        
        a.should_not eq b
      end
    end
    describe "intersection" do
      it "ray intersects a sphere at two points" do
        r = Ray.new(Point.new(0, 0, -5), Vector.new(0, 0, 1))
        s = Sphere.new()
        xs = s.intersect(r)
        xs.size.should eq 2
        xs.[0]?.should eq 4.0
        xs.[1]?.should eq 6.0
      end
      it "ray intersects a sphere at a tangent" do
        r = Ray.new(Point.new(0, 1, -5), Vector.new(0, 0, 1))
        s = Sphere.new()
        xs = s.intersect(r)
        xs.size.should eq 2
        xs[0]?.should eq 5.0
        xs[1]?.should eq 5.0
      end
      it "ray misses a sphere" do
        r = Ray.new(Point.new(0, 2, -5), Vector.new(0, 0, 1))
        s = Sphere.new()
        xs = s.intersect(r)
        xs.size.should eq 0
      end
      it "ray orginates inside a sphere" do
        r = Ray.new(Point.new(0, 0, 0), Vector.new(0, 0, 1))
        s = Sphere.new()
        xs = s.intersect(r)
        xs.size.should eq 2
        xs[0]?.should eq -1.0
        xs[1]?.should eq 1.0
      end
      it "sphere is behind a ray" do
        r = Ray.new(Point.new(0,0,5), Vector.new(0,0,1))
        s = Sphere.new()
        xs = s.intersect(r)
        xs.size.should eq 2
        xs[0]?.should eq -6.0
        xs[1]?.should eq -4.0
      end
    end
    
  end
end
