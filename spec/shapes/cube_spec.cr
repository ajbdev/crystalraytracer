require "../spec_helper.cr"

describe Cube do
  describe "#intersect" do
    it "ray intersects a cube" do
      examples = [
        [{ 5.0, 0.5, 0.0 }, {-1.0,  0.0, 0.0 }, 4, 6], #+x
        [{-5.0, 0.5, 0.0 }, { 1.0,  0.0, 0.0 }, 4, 6], #-x
        [{ 0.5, 5.0, 0.0 }, { 0.0, -1.0, 0.0 }, 4, 6], #+y
        [{ 0.5, 5.0, 0.0 }, { 0.0,  1.0, 0.0 }, 4, 6], #-y
        [{ 0.5, 0.0, 5.0 }, { 0.0,  0.0, 1.0 }, 4, 6], #+z
        [{ 0.5, 0.0, -5.0}, { 0.0,  0.0, 1.0 }, 4, 6], #-z
        [{ 0.0, 0.5, 0.0 }, { 0.0,  0.0, 1.0 },-1, 1]  #inside
      ]

      c = Cube.new
      
      examples.each do |e|
        Point.new(e[0].as(Tuple))
        r = Ray.new(Point.new(e[0].as(Tuple)), Vector.new(e[1].as(Tuple)))
        xs = c.intersect(r)

        xs.size.should eq 2
        xs[0].t.should eq e[2]
        xs[1].t.should eq e[3]
      end
    end
  end
  describe "#normal_at" do
  end
end