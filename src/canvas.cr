class Canvas
  getter width : Int32
  getter height : Int32
  getter pixels : Array(Array(Color))

  def initialize(w : Int32, h : Int32)
    @width = w
    @height = h
    @pixels = Array.new(w) { Array.new(h) { Color.black }}
  end

  def pixel(x : Int32, y : Int32)
    @pixels[x][y]
  end

  def pixel(x : Int32, y : Int32, c : Color)
    @pixels[x][y] = c
  end

  def fill(c : Color)
    height.times do |y|
      width.times do |x|
        @pixels[x][y] = c
      end
    end
  end

  def to_ppm
    max_ppm_width = 70

    String.build do |ppm|
      ppm << "P3\n#{width} #{height}\n255\n" # File header with magic numbers

      height.times do |y|
        row = ""
        width.times do |x|
          rgb = pixels[x][y].to_rgb_int255
          3.times do |i|
            val = rgb[i].to_s

            row += "\n" if (row + val).size > max_ppm_width

            row += val
            
            row += " " if x+1 < width
          end
          #row += " " if x+1 < width
        end
        ppm << "#{row}\n"
      end
    end
  end
end