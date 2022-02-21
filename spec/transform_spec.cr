require "./spec_helper.cr"

describe Transform do
  describe "transformations" do
    it "multiplies by a translation matrix" do
      transform = Transform.new(5, -3, 2)
      p = Point.new(-3, 4, 5)
      (transform * p).should eq Point.new(2,1,7)
    end
    it "multiplies by the inverse of a translation matrix" do
      transform = Transform.new(5, -3, 2)
      inv = transform.inverse
      p = Point.new(-3, 4, 5)
      (inv * p).should eq Point.new(-8, 7, 3)
    end
    it "is not affected by vectors" do
      transform = Transform.new(5, -3, 2)
      v = Vector.new(-3, 4, 5)
      (transform * v).should eq v
    end
  end
end