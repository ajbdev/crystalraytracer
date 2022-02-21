class Transform < Matrix
  def initialize(x, y, z)
    @matrix = Matrix.identity
    @rows = 4
    @columns = 4

    @matrix[0][3] = x
    @matrix[1][3] = y
    @matrix[2][3] = z
  end
end