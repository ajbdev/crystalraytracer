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
      xs = Intersections.new([i1, i2])

      xs.hit.should eq i1
    end
    it "when some intersections have negative t" do
      s = Sphere.new
      i1 = Intersection.new(-1, s)
      i2 = Intersection.new(2, s)
      xs = Intersections.new([i1, i2])

      xs.hit.should eq i2
    end
    it "is always the lowest nonnegative intersection" do
      s = Sphere.new
      i1 = Intersection.new(5, s)
      i2 = Intersection.new(7, s)
      i3 = Intersection.new(-3, s)
      i4 = Intersection.new(2, s)

      xs = Intersections.new([i1, i2, i3, i4])

      xs.hit.should eq i4
    end
    it "the hit should offset the point" do
      r = Ray.new(Point.new(0,0,-5), Vector.new(0,0,1))
      shape = Sphere.new
      shape.transform = Transform.translate(0,0,1)
      i = Intersection.new(5, shape)
      comps = i.precompute(r)

      comps.over_point.not_nil!.z.should be < -(CTuple::EPSILON/2)
      comps.point.z.should be > comps.over_point.not_nil!.z
    end
    it "the under point is offset below the surface" do
      r = Ray.new(Point.new(0,0,-5), Vector.new(0,0,1))
      shape = Sphere.new
      shape.transform = Transform.translate(0,0,1)
      i = Intersection.new(5, shape)
      xs = Intersections.new([i])
      comps = i.precompute(r, xs)

      comps.under_point.not_nil!.z.should be > CTuple::EPSILON/2
      comps.point.z.should be < comps.under_point.not_nil!.z
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

    it "precomputes the reflection vector" do
      shape = Plane.new
      r = Ray.new(Point.new(0,1,-1), Vector.new(0,-Math.sqrt(2)/2,Math.sqrt(2)/2))
      i = Intersection.new(Math.sqrt(2), shape)

      comps = i.precompute(r)
      comps.reflect_v.should eq Vector.new(0,Math.sqrt(2)/2,Math.sqrt(2)/2)
    end

    it "finds n1 (under) and n2 (over) at intersections in overlapping spheres" do
      refractive_indices = [
        [1.0,1.5],
        [1.5,2.0],
        [2.0,2.5],
        [2.5,2.5],
        [2.5,1.5],
        [1.5,1.0]
      ]

      a = Sphere.glass
      a.transform = Transform.scale(2,2,2)
      a.material.refractive_index = 1.5

      b = Sphere.glass
      b.transform = Transform.translate(0,0,-0.25)
      b.material.refractive_index = 2.0

      c = Sphere.glass
      c.transform = Transform.translate(0,0,0.25)
      c.material.refractive_index = 2.5

      r = Ray.new(Point.new(0,0,-4),Vector.new(0,0,1))
      
      # intersections(2:A, 2.75:B, 3.25:C, 4.75:B, 5.25:C, 6:A)
      xs = Intersections.new([
        {2.0, a},
        {2.75, b},
        {3.25, c},
        {4.75, b},
        {5.25, c},
        {6.0, a}
      ])

      refractive_indices.each_with_index do |n, ix|
        comps = xs[ix].precompute(r, xs)
        comps.n1.should eq n[0]
        comps.n2.should eq n[1]
      end
    end
  end
  describe "#schlick" do
    it "approximation under total internal reflection" do
      shape = Sphere.glass
      r = Ray.new(Point.new(0,0,Math.sqrt(2)/2), Vector.new(0,1,0))
      xs = Intersections.new([{-Math.sqrt(2)/2, shape}, {Math.sqrt(2)/2, shape}])
      comps = xs[1].precompute(r, xs)

      reflectance = comps.schlick
      reflectance.should eq 1.0
    end
    pending "approximation with a perpendicular viewing angle" do
      shape = Sphere.glass
      r = Ray.new(Point.new(0,0,0), Vector.new(0,1,0))
      xs = Intersections.new([{-1.0, shape}, {1.0, shape}])
      comps = xs[1].precompute(r, xs)

      reflectance = comps.schlick
      reflectance.should eq 0.04
    end
    pending "approximation with small angle and n2 > n1" do
      shape = Sphere.glass
      r = Ray.new(Point.new(0,0.99,-2), Vector.new(0,0,1))
      xs = Intersections.new([{1.8589, shape}])
      comps = xs[0].precompute(r, xs)

      reflectance = comps.schlick
      reflectance.should eq 0.48873
    end
  end

end