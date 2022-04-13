
# CTuple (Coordinate Tuple)
#
# This class stores a tuple value representation of a point or vector in a 3D space
# and provides utility methods for creating and accessing coordinatae values and maths.

class CTuple
  EQUALITY_DELTA_THRESHOLD = Float64::EPSILON

  def initialize(tuple : Tuple)
    @tuple = tuple
  end

  def initialize(x : Float64, y : Float64, z : Float64, w : Float64)
    @tuple = {x,y,z,w}
  end

  def x
    @tuple[0]
  end

  def x=(f : Float64)
    @tuple = {f,y,z,w}
  end

  def y
    @tuple[1]
  end

  def y=(f : Float64)
    @tuple = {x,f,z,w}
  end

  def z
    @tuple[2]
  end

  def z=(f : Float64)
    @tuple = {x,y,f,w}
  end

  def w
    @tuple[3]
  end

  def w=(f : Float64)
    @tuple = {x,y,z,f}
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

  def +(other : CTuple)
    CTuple.new(x + other.x, y + other.y, z + other.z, w + other.w)
  end

  def -(other : CTuple)
    CTuple.new(x - other.x, y - other.y, z - other.z, w - other.w)
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
    (@tuple[0] - b[0]).abs < EQUALITY_DELTA_THRESHOLD &&
    (@tuple[1] - b[1]).abs < EQUALITY_DELTA_THRESHOLD &&
    (@tuple[2] - b[2]).abs < EQUALITY_DELTA_THRESHOLD
  end

  def ==(other : CTuple)
    approximately?(other.val)
  end

  def *(other : Matrix)
    other * self
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

  def reflect(normal : Vector)
    self - normal * 2 * self.dot(normal)
  end

  def to_point()
    Point.new(@tuple[0],@tuple[1],@tuple[2])
  end

  def to_vector()
    Vector.new(@tuple[0],@tuple[1],@tuple[2])
  end
end
