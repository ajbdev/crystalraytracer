class Transform < Matrix

  def self.translation(x, y, z)
    t = Matrix.new(Matrix.identity)

    t.matrix[0][3] = x
    t.matrix[1][3] = y
    t.matrix[2][3] = z

    t
  end

  def self.scaling(x, y, z)
    t = Matrix.new(Matrix.identity)

    t.matrix[0][0] = x
    t.matrix[1][1] = y
    t.matrix[2][2] = z
    t.matrix[3][3] = 1.0

    t
  end
end