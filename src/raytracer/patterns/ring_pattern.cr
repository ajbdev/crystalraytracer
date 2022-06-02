class RingPattern < Pattern

  def initialize(a : Color, b : Color, transform = Matrix.new(Matrix.identity))
    @a = a
    @b = b
    @transform = transform
  end

  def pattern_at(p : CTuple) : Color
    Math.sqrt(p.x**2 + p.z**2).floor % 2 == 0 ? @a : @b
  end
end