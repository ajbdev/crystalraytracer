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
end