class Point < CTuple
  def initialize(x : Float64, y : Float64, z : Float64)
    @tuple = {x, y, z, 1.0}
  end
end