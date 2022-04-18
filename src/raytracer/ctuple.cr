
# CTuple (Coordinate Tuple)
#
# This class stores a tuple value representation of a point or vector in a 3D space
# and provides utility methods for creating and accessing coordinatae values and maths.

class CTuple
  EPSILON = 0.00001

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
    (@tuple[0] - b[0]).abs < EPSILON &&
    (@tuple[1] - b[1]).abs < EPSILON &&
    (@tuple[2] - b[2]).abs < EPSILON
  end

  def ==(other : CTuple)
    approximately?(other.val)
  end

  def *(matrix : Matrix)
    matrix * self
  end

  def magnitude
    Math.sqrt(x * x + y * y + z * z)
  end

  def normalize
    self.class.new(x/magnitude, y/magnitude, z/magnitude, w/magnitude)
  end

  def dot(other : CTuple)
    x * other.x + y * other.y + z * other.z + w * other.w
  end

  def cross(other : CTuple)
    self.class.new_vector(y * other.z - z * other.y, z * other.x - x * other.z, x * other.y - y * other.x)
  end

  def clamp_to_f32_values
    self.class.new(x.to_f32.to_f64,y.to_f32.to_f64,z.to_f32.to_f64,w.to_f32.to_f64)
  end

  def reflect(normal : CTuple)
    n = normal * 2 * dot(normal)
    self - n.clamp_to_f32_values
  end

  def as_point()
    Point.new(@tuple[0],@tuple[1],@tuple[2])
  end

  def as_vector()
    Vector.new(@tuple[0],@tuple[1],@tuple[2])
  end
end
