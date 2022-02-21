class Transform < Matrix

  def self.translation(x, y, z)
    t = Matrix.identity

    t[0][3] = x
    t[1][3] = y
    t[2][3] = z

    Matrix.new(t)
  end

  def self.scaling(x, y, z)
    t = Matrix.identity

    t[0][0] = x
    t[1][1] = y
    t[2][2] = z
    t[3][3] = 1.0

    Matrix.new(t)
  end

  def self.rotate_x(radians : Float64)
    rotation(:x, radians)
  end

  def self.rotate_y(radians : Float64)
    rotation(:y, radians)
  end

  def self.rotate_z(radians : Float64)
    rotation(:z, radians)
  end

  def self.rotation(axis : Symbol, radians : Float64)
    t = Matrix.identity

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

    Matrix.new(t)
  end

  class TransformArgumentError < ArgumentError

  end
end