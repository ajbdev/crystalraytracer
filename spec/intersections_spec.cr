require "./spec_helper.cr"

describe Intersections do
  describe "#new" do
    s = Sphere.new
    i1 = Intersection.new(1, s)
    i2 = Intersection.new(2, s)
    xs = Intersections.new([i1, i2])
    xs.size.should eq 2
    xs[0].t.should eq 1
    xs[1].t.should eq 2
  end
end