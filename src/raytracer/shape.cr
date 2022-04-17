abstract class Shape
  property transform : Matrix
  property material : Material

  def initialize
    @transform = Matrix.new(Matrix.identity)
    @material = Material.new
  end

  abstract def intersect(ray : Ray)

  abstract def normal_at(point : CTuple)
end