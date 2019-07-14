require "gosu"
require_relative "./obstacle.rb"

class Wall < Obstacle
  attr_accessor :x
  attr_accessor :y
  attr_accessor :width
  attr_accessor :height
  #walls are just rectangle shaped obstacles
  def initialize(x = 0, y = 0, width = 30, height = 30, color = Gosu::Color::WHITE, z = 0, clear = false)
    @x = x
    @y = y
    @width = width
    @height = height
    #calculates the vertices and calls on superclass constructor
    super [Vector[@x, @y], Vector[@x + @width, @y], Vector[@x + @width, @y + @height], Vector[@x, @y + @height]], color, z, clear
  end
end
