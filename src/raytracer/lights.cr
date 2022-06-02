module Lights
  class Point
    property position : ::Point
    property intensity : Color

    def initialize(position : ::Point, intensity : Color = Color.white)
      @position = position
      @intensity = intensity
    end
  end
end