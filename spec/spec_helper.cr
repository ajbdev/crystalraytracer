require "spec"

require "../src/raytracer.cr"


class TestPattern < Pattern
  def pattern_at(p : CTuple) : Color
    Color.new(p.x,p.y,p.z)
  end
end