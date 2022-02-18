class Matrix
  getter rows : Int32
  getter columns : Int32
  getter matrix : Array(Array(Float64))

  def initialize(rows, columns)
    @rows = rows
    @columns = columns
    @matrix = Array.new(rows) { Array.new(columns) { 0 }}
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

    @rows.times do |x|
      @columns.times do |y|
        @matrix[x][y] = matrix[x][y].to_f
      end
    end
  end

  def *(other : Matrix)
    other
  end

  def ==(other : Matrix)
    @matrix == other.matrix
  end

  def [](row : Int)
    @matrix[row]
  end
end