require "./spec_helper.cr"

describe Camera do
  describe "new" do
    it "constructs a camera" do
      h_size = 160
      v_size = 120
      fov = Math::PI / 2
      c = Camera.new(h_size, v_size, fov)
      c.h_size.should eq 160
      c.v_size.should eq 120
      c.fov.should eq Math::PI / 2
      c.transform.matrix.should eq Matrix.identity
    end

    it "the pixel size for a horizontal canvas" do
      c = Camera.new(200, 125, Math::PI / 2)
      c.pixel_size.should eq 0.01.to_f32
    end

    it "the pixel size for a vertical canvas" do
      c = Camera.new(125, 200, Math::PI / 2)
      c.pixel_size.should eq 0.01.to_f32
    end
  end

  describe "#ray_for_pixel" do
    it "constructs a ray through the center of the canvas" do
      c = Camera.new(201, 101, Math::PI / 2)
      r = c.ray_for_pixel(100, 50)
      r.origin.should eq Point.new(0, 0, 0)
      r.direction.should eq Vector.new(0, 0, -1)
    end

    it "constructs a ray through a corner of the canvas" do
      c = Camera.new(201, 101, Math::PI / 2)
      r = c.ray_for_pixel(0, 0)
      r.origin.should eq Point.new(0, 0, 0)
      r.direction.should eq Vector.new(0.66519, 0.33259, -0.66851)
    end

    it "constructs a ray when the camera is transformed" do
      c = Camera.new(201, 101, Math::PI / 2)
      c.transform = Transform.rotate_y(Math::PI / 4) * Transform.translate(0, -2, 5)
      r = c.ray_for_pixel(100, 50)
      r.origin.should eq Point.new(0, 2, -5)
      r.direction.should eq Vector.new(Math.sqrt(2) / 2, 0, -Math.sqrt(2) / 2)
    end

    it "constructs a ray when the camera is transformed" do
      c = Camera.new(201, 101, Math::PI / 2)
      c.transform = Transform.rotate_y(Math::PI / 4) * Transform.translate(0, -2, 5)
      r = c.ray_for_pixel(100, 50)
      r.origin.should eq Point.new(0, 2, -5)
      r.direction.should eq Vector.new(Math.sqrt(2) / 2, 0, -Math.sqrt(2) / 2)
    end

    it "constructs a ray when the camera is transformed" do
      c = Camera.new(201, 101, Math::PI / 2)
      c.transform = Transform.rotate_y(Math::PI / 4) * Transform.translate(0, -2, 5)
      r = c.ray_for_pixel(100, 50)
      r.origin.should eq Point.new(0, 2, -5)
      r.direction.should eq Vector.new(Math.sqrt(2) / 2, 0, -Math.sqrt(2) / 2)
    end
  end

  describe "#render" do
    it "renders a world with a camera" do
      w = World.default
      c = Camera.new(11, 11, Math::PI / 2)
      from = Point.new(0, 0, -5)
      to = Point.new(0, 0, 0)
      up = Vector.new(0, 1, 0)
      c.transform = Transform.view_transform(from, to, up)
      img = c.render(w)
      img.pixel(5,5).should eq Color.new(0.38066, 0.47583, 0.2855)
    end
  end
end