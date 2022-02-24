class Shape
  property transform : Matrix

  def initialize
    @transform = Matrix.new(Matrix.identity)
  end
end