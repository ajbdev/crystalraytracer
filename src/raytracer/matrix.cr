class Matrix
  getter rows : Int32
  getter columns : Int32
  getter matrix : Array(Array(Float64))

  def initialize(rows, columns)
    @rows = rows
    @columns = columns
    @matrix = Array.new(rows) { Array.new(columns) { 0.0 }}
  end

  def initialize(matrix : Array(Array(Float64)))
    @rows = matrix.size
    @columns = matrix[0].size
    @matrix = matrix
  end

  def initialize(matrix : Array(Array(Float64 | Int32)))
    @rows = matrix.size
    @columns = matrix[0].size
    @matrix = Array.new(rows) { Array.new(columns) { 0.0 }}

    rows.times do |x|
      columns.times do |y|
        @matrix[x][y] = matrix[x][y].to_f
      end
    end
  end

  def recalc_size
    @rows = matrix.size
    @columns = matrix[0].size
  end

  def *(other : Matrix)
    raise DimensionMismatch.new("Matrices must be square and of equal size") if @rows != other.columns
    
    result = self.class.new(rows, columns)

    rows.times do |y|
      columns.times do |x|
        result[y][x] = (0..rows-1).map { |i| matrix[y][i] * other[i][x] }.sum
      end
    end

    result
  end

  def *(tuple : CTuple)
    raise DimensionMismatch.new("Tuple size must match column and row size") if tuple.size != columns != rows

    result = Array(Float64).new(rows) { 0.0 }
    rows.times do |y|
      result[y] = (0..columns-1).map { |i| matrix[y][i] * tuple[i] }.sum
    end

    CTuple.new(result[0],result[1],result[2],result[3])
  end

  def identity
    Matrix.new(self.class.identity(rows))
  end

  def self.new_identity
    new(identity)
  end

  def self.identity(size = 4)
    id = Array.new(size) { Array.new(size) { 0.0 }}

    size.times do |i|
      id[i][i] = 1.0
    end

    id
  end

  def determinant
    return (matrix[0][0] * matrix[1][1]) - (matrix[0][1] * matrix[1][0]) if rows == 2

    det = 0
    columns.times do |x|
      det = det + matrix[0][x] * cofactor(0,x)
    end

    det
  end

  def minor(row, column)
    submatrix(row, column).determinant
  end

  def cofactor(row, column)
    minor(row, column) * ((row+column) % 2 == 0 ? 1 : -1)
  end

  def copy
    c = [] of Array(Float64)
    rows.times do |y|
      c << [] of Float64
      columns.times do |x|
        c[y] << matrix[y][x]
      end
    end

    Matrix.new(c)
  end

  def submatrix(row, column)
    sub = copy

    sub.matrix.delete_at(row)
    sub.matrix.each do |row|
      row.delete_at(column)
    end

    sub.recalc_size

    sub
  end

  def invertible?
    determinant != 0
  end

  def inverse
    raise ArgumentError.new("Matrix is not invertible") unless invertible?

    m = Array.new(rows) { Array.new(columns) { 0.0 }}

    rows.times do |y|
      columns.times do |x|
        c = cofactor(y,x)
        m[x][y] = c / determinant
      end
    end

    self.class.new(m)
  end

  def transpose
    self.class.new(matrix.transpose)
  end

  def approximately?(other : Matrix)
    approximately?(other.matrix)
  end

  def approximately?(arr : Array(Array(Float64)))
    raise DimensionMismatch.new("Matrices must be square and of equal size") if @rows != arr.size || @columns != arr[0].size

    rows.times do |y|
      columns.times do |x|
        return false unless (matrix[y][x] - arr[y][x]).abs < CTuple::EPSILON
      end
    end

    true
  end

  def ==(other : Matrix)
    approximately?(other)
  end

  def ==(arr : Array(Array(Float64)))
    approximately?(arr)
  end

  def [](row : Int)
    matrix[row]
  end

  class DimensionMismatch < Exception
  end
end