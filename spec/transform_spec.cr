require "./spec_helper.cr"

describe Transform do
  describe "transformations" do
    it "multiplies by a translation matrix" do
      transform = Transform.translation(5, -3, 2)
      p = Point.new(-3, 4, 5)
      (transform * p).should eq Point.new(2,1,7)
    end
    it "multiplies by the inverse of a translation matrix" do
      transform = Transform.translation(5, -3, 2)
      inv = transform.inverse
      p = Point.new(-3, 4, 5)
      (inv * p).should eq Point.new(-8, 7, 3)
    end
    it "is not affected by vectors" do
      transform = Transform.translation(5, -3, 2)
      v = Vector.new(-3, 4, 5)
      (transform * v).should eq v
    end
  end
  describe "scaling" do
    it "matrix applied to a point" do
      transform = Transform.scaling(2, 3, 4)
      p = Point.new(-4, 6, 8)

      (transform * p).should eq Point.new(-8, 18, 32)
    end
    it "matrix applied to a vector" do
      transform = Transform.scaling(2, 3, 4)
      v = Vector.new(-4, 6, 8)

      (transform * v).should eq Vector.new(-8, 18, 32)
    end
    it "multiplies by the inverse of a scaling matrix" do
      transform = Transform.scaling(2, 3, 4)
      inv = transform.inverse
      v = Vector.new(-4, 6, 8)

      (inv * v).should eq Vector.new(-2, 2, 2)
    end
    it "reflection is scaling by a negative value" do
      transform = Transform.scaling(-1, 1, 1)
      p = Point.new(2, 3, 4)

      (transform * p).should eq Point.new(-2, 3, 4)
    end
  end
end