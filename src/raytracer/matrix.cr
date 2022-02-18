class Matrix
  getter rows
  getter columns
  getter matrix

  def initialize(rows, columns)
    @rows = rows
    @columns = columns
    @matrix = Array.new(rows) { Array.new(columns) {  }}
  end
end