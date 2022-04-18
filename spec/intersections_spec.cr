require "./spec_helper.cr"

describe Intersections do
  describe "#new" do
    it "aggregates into a collection" do
      s = Sphere.new
      i1 = Intersection.new(1, s)
      i2 = Intersection.new(2, s)
      xs = Intersections.new([i1, i2])
      xs.size.should eq 2
      xs[0].t.should eq 1
      xs[1].t.should eq 2
    end
  end
  describe "#hit" do
    it "when all intersections have positive t" do
      s = Sphere.new
      i1 = Intersection.new(1, s)
      i2 = Intersection.new(2, s)
      xs = Intersections.new(i1, i2)

      xs.hit.should eq i1
    end
    it "when some intersections have negative t" do
      s = Sphere.new
      i1 = Intersection.new(-1, s)
      i2 = Intersection.new(2, s)
      xs = Intersections.new(i1, i2)

      xs.hit.should eq i2
    end
    it "is always the lowest nonnegative intersection" do
      s = Sphere.new
      i1 = Intersection.new(5, s)
      i2 = Intersection.new(7, s)
      i3 = Intersection.new(-3, s)
      i4 = Intersection.new(2, s)

      xs = Intersections.new(i1, i2, i3, i4)

      xs.hit.should eq i4
    end
  end
  describe "#precompute" do
    it "precomputes the state of an intersection" do
      r = Ray.new(Point.new(0,0,-5), Vector.new(0,0,1))
      shape = Sphere.new
      i = Intersection.new(4, shape)
      comps = i.precompute(r)
  
      comps.t.should eq i.t
      comps.object.should eq i.object
      comps.point.should eq Point.new(0,0,-1)
      comps.eye_v.should eq Vector.new(0,0,-1)
      comps.normal_v.should eq Vector.new(0,0,-1)
    end

    it "the hit, when an intersection occurs on the outside" do
      r = Ray.new(Point.new(0,0,-5), Vector.new(0,0,1))
      shape = Sphere.new
      i = Intersection.new(4, shape)

      comps = i.precompute(r)
      comps.inside.should eq false
    end

    it "shading an intersection" do
      w = World.default
      r = Ray.new(Point.new(0,0,-5), Vector.new(0,0,1))
      shape = w.objects.first
      i = Intersection.new(4, shape)
      comps = i.precompute(r)
      c = w.shade_hit(comps)
      c.should eq Color.new(0.38066119308103435, 0.47582649135129296, 0.28549589481077575)
    end

    it "shading an intersection from the inside" do
      w = World.default
      w.light = Lights::Point.new(Point.new(0,0.25,0), Color.white)
      r = Ray.new(Point.new(0,0,0), Vector.new(0,0,1))
      shape = w.objects[1]
      i = Intersection.new(0.5, shape)

      comps = i.precompute(r)
      c = w.shade_hit(comps)
      c.should eq Color.new(0.9049844720832566, 0.9049844720832566, 0.9049844720832566)
    end
  end


end