require "gosu"

class Rectangle
  attr_accessor :x
  attr_accessor :y
  attr_accessor :width
  attr_accessor :height
  attr_accessor :color
  attr_accessor :z
  attr_accessor :clear

  def initialize(x = 0, y = 0, width = 30, height = 30, z: 0, color: Gosu::Color::WHITE, clear: false)
    @clear = clear
    @x = x
    @y = y
    @width = width
    @height = height
    @color = color
    @z = z
  end

  #a way to find collisions using vertices
  def vertices
    [Vector[@x, @y], Vector[@x + @width, @y], Vector[@x + @width, @y + @height], Vector[@x, @y + @height]]
  end

  def draw(x = @x, y = @y, z = @z)
    if (clear)
      Gosu.draw_line(x, y, @color, x + @width, y, @color, z)
      Gosu.draw_line(x, y, @color, x, y + @height, @color, z)
      Gosu.draw_line(x + @width, y, @color, x + @width, y + @height, @color, z)
      Gosu.draw_line(x, y + @height, @color, x + @width, y + @height, @color, z)
    else
      Gosu.draw_rect(x, y, @width, @height, @color, z)
    end
  end
end
