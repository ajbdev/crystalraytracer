class Shape
  property transform : Matrix
  property material : Material

  def initialize
    @transform = Matrix.new(Matrix.identity)
    @material = Material.new
  end
end