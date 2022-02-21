class Vector < CTuple
  def initialize(x : Float64, y : Float64, z : Float64)
    @tuple = {x, y, z, 0.0}
  end
end