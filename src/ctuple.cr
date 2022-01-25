
# CTuple (Coordinate Tuple)
#
# This class stores a tuple value representation of a point or vector in a 3D space
# and provides utility methods for creating and accessing coordinatae values.

class CTuple
  def initialize(tuple)
    @tuple = tuple
  end

  def initialize(x : Float64, y : Float64, z : Float64, w : Float64)
    @tuple = {x,y,z,w}
  end

  def x
    @tuple[0]
  end

  def y
    @tuple[1]
  end

  def z
    @tuple[2]
  end

  def w
    @tuple[3]
  end

  def val
    @tuple
  end

  def point?
    w == 1.0
  end

  def vector?
    w == 0.0
  end

  def self.new_point(x : Float64, y : Float64, z : Float64)
    CTuple.new(x, y, z, 1.0)
  end

  def self.new_vector(x : Float64, y : Float64, z : Float64)
    CTuple.new(x, y, z, 0.0)
  end

  def +(t : CTuple)
    CTuple.new(x + t.x, y + t.y, z + t.z, w + t.w)
  end

  def -(t : CTuple)
    CTuple.new(x - t.x, y - t.y, z - t.z, w - t.w)
  end

  def -
    CTuple.new(-x,-y,-z,-w)
  end
end
