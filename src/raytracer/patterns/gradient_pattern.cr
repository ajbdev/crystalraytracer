class GradientPattern < Pattern

  def initialize(a : Color, b : Color, transform = Matrix.new(Matrix.identity))
    @a = a
    @b = b
    @transform = transform
  end

  def pattern_at(p : CTuple) : Color
    distance = @b - @a

    # Produces a more linear gradient, needs updated tests to implement:
    # fraction = (p.x + 1.0) * 0.5
    fraction = p.x - p.x.floor

    (@a + distance * fraction).as_color
  end
end