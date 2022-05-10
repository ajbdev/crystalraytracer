class CheckerPattern < Pattern
  def initialize(a : Color, b : Color, transform = Matrix.new(Matrix.identity))
    @a = a
    @b = b
    @transform = transform
  end

  def pattern_at(p : CTuple) : Color
    (p.x.floor + p.y.floor + p.z.floor) % 2 == 0 ? @a : @b
  end
end