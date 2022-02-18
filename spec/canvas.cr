require "./spec_helper.cr"

describe Canvas do
  describe "#new" do
    it "initializes with a set width and height" do
      c = Canvas.new(10, 20)


      c.width.should eq 10
      c.height.should eq 20
      c.pixels.each { |row| row.each { |p| p.approximately(0.0, 0.0, 0.0) } }
    end

    it "allows storing pixels to the canvas by position" do
      canvas = Canvas.new(10, 20)
      red = Color.new(1, 0, 0)

      canvas.pixel(2, 3, red)

      canvas.pixel(2, 3).should eq red
    end

    it "exports to ppm format" do
      canvas = Canvas.new(5, 3)
      canvas.pixel(0, 0, Color.new(1.5, 0, 0))
      canvas.pixel(2, 1, Color.new(0, 0.5, 0))
      canvas.pixel(4, 2, Color.new(-0.5, 0, 1))

      canvas.to_ppm.should eq <<-PPM
P3
5 3
255
255 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 128 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 255
PPM
    end

    it "adds a new line at 70 characters" do
      canvas = Canvas.new(10, 2)
      canvas.fill(Color.new(1, 0.8, 0.6))

      canvas.to_ppm.should eq <<-PPM
P3
10 2
255
255 204 153 255 204 153 255 204 153 255 204 153 255 204 153 255 204
153 255 204 153 255 204 153 255 204 153 255 204 153
255 204 153 255 204 153 255 204 153 255 204 153 255 204 153 255 204
153 255 204 153 255 204 153 255 204 153 255 204 153
PPM
    end
  end
end

