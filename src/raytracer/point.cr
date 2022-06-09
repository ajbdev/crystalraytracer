class Point < CTuple
  def initialize(x : Float64, y : Float64, z : Float64)
    @tuple = {x, y, z, 1.0}
  end

  def initialize(x : Float64, y : Float64, z : Float64, w : Float64)
    @tuple = {x, y, z, 1.0}
  end

  def initialize(t : Tuple(Float64, Float64, Float64))
    @tuple = {t[0], t[1], t[2], 1.0}
  end
end