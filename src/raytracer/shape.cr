abstract class Shape
  property transform : Matrix
  property material : Material

  def initialize(material = Material.new, transform = Matrix.new(Matrix.identity))
    @material = material
    @transform = transform
  end

  abstract def intersect(ray : Ray)

  abstract def normal_at(point : CTuple)
end