require "../spec_helper.cr"

describe Plane do
  describe "#normal_at" do
    it "the normal of a plane is constant everywhere" do
      p = Plane.new
      n1 = p.normal_at(Point.new(0,0,0))
      n2 = p.normal_at(Point.new(10,0,-10))
      n3 = p.normal_at(Point.new(-5,0,150))

      n1.should eq Vector.new(0,1,0)
      n2.should eq Vector.new(0,1,0)
      n3.should eq Vector.new(0,1,0)
    end
  end
  describe "#intersect" do
    it "with a ray parallel to the plane" do
      p = Plane.new
      r = Ray.new(Point.new(0,10,0), Vector.new(0,0,1))
      xs = p.intersect(r)
      xs.size.should eq 0
    end
    it "with a coplanar ray" do
      p = Plane.new
      r = Ray.new(Point.new(0,0,0), Vector.new(0,0,1))
      xs = p.intersect(r)
      xs.size.should eq 0
    end
    it "a ray intersecting a plane from above" do
      p = Plane.new
      r = Ray.new(Point.new(0,1,0), Vector.new(0,-1,0))
      xs = p.intersect(r)
      
      xs.size.should eq 1
      xs[0].t.should eq 1
      xs[0].object.should eq p
    end
    it "a ray intersecting a plane from below" do
      p = Plane.new
      r = Ray.new(Point.new(0,-1,0), Vector.new(0,1,0))
      xs = p.intersect(r)
      xs.size.should eq 1
      xs[0].t.should eq 1
      xs[0].object.should eq p
    end
  end
end