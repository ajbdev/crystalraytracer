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


end