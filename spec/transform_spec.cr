require "./spec_helper.cr"

describe Transform do
  describe "transformations" do
    it "multiplies by a translate matrix" do
      transform = Transform.translate(5, -3, 2)
      p = Point.new(-3, 4, 5)
      (transform * p).should eq Point.new(2,1,7)
    end
    it "multiplies by the inverse of a translate matrix" do
      transform = Transform.translate(5, -3, 2)
      inv = transform.inverse
      p = Point.new(-3, 4, 5)
      (inv * p).should eq Point.new(-8, 7, 3)
    end
    it "is not affected by vectors" do
      transform = Transform.translate(5, -3, 2)
      v = Vector.new(-3, 4, 5)
      (transform * v).should eq v
    end
  end
  describe "scale" do
    it "applies to a point" do
      transform = Transform.scale(2, 3, 4)
      p = Point.new(-4, 6, 8)

      (transform * p).should eq Point.new(-8, 18, 32)
    end
    it "applies to a vector" do
      transform = Transform.scale(2, 3, 4)
      v = Vector.new(-4, 6, 8)

      (transform * v).should eq Vector.new(-8, 18, 32)
    end
    it "multiplies by the inverse of a scale matrix" do
      transform = Transform.scale(2, 3, 4)
      inv = transform.inverse
      v = Vector.new(-4, 6, 8)

      (inv * v).should eq Vector.new(-2, 2, 2)
    end
    it "reflection is scale by a negative value" do
      transform = Transform.scale(-1, 1, 1)
      p = Point.new(2, 3, 4)

      (transform * p).should eq Point.new(-2, 3, 4)
    end
  end
  describe "rotation" do
    it "rotates a point around the x axis" do
      p = Point.new(0, 1, 0)

      half_quarter = Transform.rotate_x(Math::PI / 4)
      full_quarter = Transform.rotate_x(Math::PI / 2)

      (half_quarter * p).should eq Point.new(0, Math.sqrt(2) / 2, Math.sqrt(2) / 2)
      (full_quarter * p).should eq Point.new(0, 0, 1)
    end
    it "rotates a point around the y axis" do
      p = Point.new(0, 0, 1)

      half_quarter = Transform.rotate_y(Math::PI / 4)
      full_quarter = Transform.rotate_y(Math::PI / 2)

      (half_quarter * p).should eq Point.new((Math.sqrt(2) / 2), 0, Math.sqrt(2) / 2)
      (full_quarter * p).should eq Point.new(1, 0, 0)
    end
    it "rotates a point around the z axis" do
      p = Point.new(0, 1, 0)

      half_quarter = Transform.rotate_z(Math::PI / 4)
      full_quarter = Transform.rotate_z(Math::PI / 2)

      (half_quarter * p).should eq Point.new((Math.sqrt(2) / 2) * -1, Math.sqrt(2) / 2, 0)
      (full_quarter * p).should eq Point.new(-1, 0, 0)
    end
  end
  describe "shearing" do
    it "moves x in proportion to y" do
      transform = Transform.shear(1, 0, 0, 0, 0, 0)
      p = Point.new(2, 3, 4)

      (transform * p).should eq Point.new(5,3,4)
    end
    it "moves x in proportion to z" do
      transform = Transform.shear(0, 1, 0, 0, 0, 0)
      p = Point.new(2, 3, 4)

      (transform * p).should eq Point.new(6, 3, 4)
    end
    it "moves y in proportion to x" do
      transform = Transform.shear(0, 0, 1, 0, 0, 0)
      p = Point.new(2, 3, 4)

      (transform * p).should eq Point.new(2, 5, 4)
    end
    it "moves y in proportion to z" do
      transform = Transform.shear(0, 0, 0, 1, 0, 0)
      p = Point.new(2, 3, 4)

      (transform * p).should eq Point.new(2, 7, 4)
    end
    it "moves z in proportion to x" do
      transform = Transform.shear(0, 0, 0, 0, 1, 0)
      p = Point.new(2, 3, 4)

      (transform * p).should eq Point.new(2, 3, 6)
    end
    it "moves z in proportion to y" do
      transform = Transform.shear(0, 0, 0, 0, 0, 1)
      p = Point.new(2, 3, 4)

      (transform * p).should eq Point.new(2, 3, 7)
    end
  end
  describe "chaining" do
    it "applies transformations in sequence" do
      p = Point.new(1, 0, 1)
      a = Transform.rotate_x(Math::PI / 2)
      b = Transform.scale(5, 5, 5)
      c = Transform.translate(10, 5, 7)
      t = c * b * a
      (t * p).should eq Point.new(15, 0, 7)
    end
    it "allows a fluent interface" do
      p = Point.new(1, 0, 1)
      transform = Transform.new
                          .translate(10, 5, 7)
                          .scale(5, 5, 5)
                          .rotate_x(Math::PI / 2)

      (transform * p).should eq Point.new(15, 0, 7)
    end
  end
  describe "#view_transform" do
    it "the transformation matrix for the default orientation" do
      from = Point.new(0,0,0)
      to = Point.new(0,0,-1)
      up = Vector.new(0,1,0)

      t = Transform.new.view_transform(from, to, up)

      t.matrix.should eq Matrix.identity
    end
    it "a view transformation matrix looking in positive z direction" do
      from = Point.new(0,0,0)
      to = Point.new(0,0,1)
      up = Vector.new(0,1,0)

      t = Transform.new.view_transform(from, to, up)

      t.matrix.should eq Transform.scale(-1, 1, -1).matrix
    end
    it "the view transformation moves the world" do
      from = Point.new(0,0,8)
      to = Point.new(0,0,0)
      up = Vector.new(0,1,0)
      t = Transform.new.view_transform(from, to, up)
      t.matrix.should eq Transform.translate(0,0,-8).matrix
    end
    it "an arbitrary view transformation" do
      from = Point.new(1,3,2)
      to = Point.new(4,-2,8)
      up = Vector.new(1,1,0)

      t = Transform.new.view_transform(from, to, up)
      
      t.should eq([
        [ -0.50709, 0.50709, 0.67612,   -2.36643 ],
        [ 0.76772,  0.60609, 0.12122,   -2.82843 ],
        [ -0.35857, 0.59761, -0.71714,  0.00000 ],
        [ 0.00000,  0.00000, 0.00000,   1.00000 ]
      ])
    end
  end
end