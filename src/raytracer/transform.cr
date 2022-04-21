# Transform operations
class Transform < Matrix

  def initialize(rows, columns)
    @rows = rows
    @columns = columns
    @matrix = Array.new(rows) { Array.new(columns) { 0.0 }}
  end

  def initialize
    @matrix = Matrix.identity
    @rows = matrix.size
    @columns = matrix[0].size
  end

  def initialize(matrix : Array(Array(Float64)))
    @matrix = matrix
    @rows = matrix.size
    @columns = matrix[0].size
  end

  def rotate_x(radians : Float64)
    self * self.class.rotate_x(radians)
  end

  def rotate_y(radians : Float64)
    self * self.class.rotate_y(radians)
  end

  def rotate_z(radians : Float64)
    self * self.class.rotate_z(radians)
  end

  def scale(x : Float64, y : Float64, z : Float64)
    self * self.class.scale(x, y, z)
  end

  def translate(x : Float64, y : Float64, z : Float64)
    self * self.class.translate(x, y, z)
  end

  def shear(xy : Float64, xz : Float64, yx : Float64, yz : Float64, zx : Float64, zy : Float64)
    self * self.class.shear(xy, xz, yx, yz, zx, zy)
  end

  def view_transform(from : Point, to : Point, up : Vector)
    forward = (to - from).normalize
    up_n = up.normalize
    left = forward.cross(up_n)
    true_up = left.cross(forward)

    orientation = Matrix.new([
      [left.x,     left.y,     left.z,     0.0],
      [true_up.x,  true_up.y,  true_up.z,  0.0],
      [-forward.x, -forward.y, -forward.z, 0.0],
      [0.0,        0.0,        0.0,        1.0]
    ])

    orientation * translate(-from.x, -from.y, -from.z)
  end

  def self.view_transform(from : Point, to : Point, up : Vector)
    new.view_transform(from, to, up)
  end

  def self.translate(x : Float64, y : Float64, z : Float64, t = Matrix.identity)
    t[0][3] = x
    t[1][3] = y
    t[2][3] = z

    self.new(t)
  end

  def self.scale(x, y, z, t = Matrix.identity)
    t[0][0] = x
    t[1][1] = y
    t[2][2] = z
    t[3][3] = 1.0

    self.new(t)
  end

  def self.rotate_x(radians : Float64, t = Matrix.identity)
    rotate(:x, radians, t)
  end

  def self.rotate_y(radians : Float64, t = Matrix.identity)
    rotate(:y, radians, t)
  end

  def self.rotate_z(radians : Float64, t = Matrix.identity)
    rotate(:z, radians, t)
  end

  def self.shear(xy : Float64, xz : Float64, yx : Float64, yz : Float64, zx : Float64, zy : Float64, t = Matrix.identity)
    t[0][1] = xy
    t[0][2] = xz
    t[1][0] = yx
    t[1][2] = yz
    t[2][0] = zx
    t[2][1] = zy

    self.new(t)
  end

  def self.rotate(axis : Symbol, radians : Float64, t = Matrix.identity)
    case axis
    when :x
      t[1][1] = Math.cos(radians)
      t[1][2] = Math.sin(radians) * -1
      t[2][1] = Math.sin(radians)
      t[2][2] = Math.cos(radians)
    when :y
      t[0][0] = Math.cos(radians)
      t[0][2] = Math.sin(radians)
      t[2][0] = Math.sin(radians) * -1
      t[2][2] = Math.cos(radians)
    when :z
      t[0][0] = Math.cos(radians)
      t[0][1] = Math.sin(radians) * -1
      t[1][0] = Math.sin(radians)
      t[1][1] = Math.cos(radians)
    else
      raise TransformArgumentError.new("Unknown axis: #{axis}")
    end

    new(t)
  end

  class TransformArgumentError < ArgumentError

  end
end