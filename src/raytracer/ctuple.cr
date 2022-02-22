
# CTuple (Coordinate Tuple)
#
# This class stores a tuple value representation of a point or vector in a 3D space
# and provides utility methods for creating and accessing coordinatae values and maths.

class CTuple
  def initialize(tuple : Tuple)
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
    self.new(x, y, z, 1.0)
  end

  def self.new_vector(x : Float64, y : Float64, z : Float64)
    self.new(x, y, z, 0.0)
  end

  def +(t : CTuple)
    CTuple.new(x + t.x, y + t.y, z + t.z, w + t.w)
  end

  def -(t : CTuple)
    CTuple.new(x - t.x, y - t.y, z - t.z, w - t.w)
  end

  def -
    self.class.new(-x, -y, -z, -w)
  end

  def *(f : Float64)
    self.class.new(x*f, y*f, z*f, w*f)
  end

  def /(f : Float64)
    self.class.new(x/f, y/f, z/f, w/f)
  end
  
  def size
    @tuple.size
  end

  def [](n)
    @tuple[n]
  end

  def approximately?(x : Float64, y : Float64, z : Float64)
    approximately?({ x, y, z })
  end

  def approximately?(b : Tuple)
    (@tuple[0] - b[0]).abs < Float64::EPSILON &&
    (@tuple[1] - b[1]).abs < Float64::EPSILON &&
    (@tuple[2] - b[2]).abs < Float64::EPSILON
  end

  def ==(other : CTuple)
    approximately?(other.val)
  end

  def magnitude
    Math.sqrt(x * x + y * y + z * z)
  end

  def normalize
    self.class.new(x/magnitude, y/magnitude, z/magnitude, w/magnitude)
  end

  def dot(b : CTuple)
    x * b.x + y * b.y + z * b.z + w * b.w
  end

  def cross(b : CTuple)
    self.class.new_vector(y * b.z - z * b.y, z * b.x - x * b.z, x * b.y - y * b.x)
  end
end
