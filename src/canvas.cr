class Canvas
  getter width : Int32
  getter height : Int32
  getter pixels : Array(Array(Color))

  MAX_PPM_LINE_WIDTH = 70

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
    String.build do |ppm|
      ppm << "P3\n#{width} #{height}\n255\n" # File header with magic numbers

      height.times do |y|
        line = [] of String
        line_c = 0
        width.times do |x|
          rgb = pixels[x][y].to_rgb_int255
          3.times do |c|
            val = rgb[c].to_s

            if line_c + line.size + val.size > MAX_PPM_LINE_WIDTH
              ppm << "#{line.join(' ')}\n"
              line = [] of String
              line_c = 0
            end

            line << val
            line_c += val.size
          end
        end

        ppm << line.join(' ')
        ppm << "\n"
      end
    end
  end
end