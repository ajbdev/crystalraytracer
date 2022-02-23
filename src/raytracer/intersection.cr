class Intersection
  getter t
  getter object

  def initialize(t : Float64, obj : Shape)
    @t = t
    @object = obj
  end
end