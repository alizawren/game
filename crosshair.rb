require "singleton"
require "gosu"
require "./constants.rb"

class Crosshair
  attr_accessor :x
  attr_accessor :y
  include Singleton

  def initialize
    @x = 0
    @y = 0
    @image = Gosu::Image.new("img/crosshair.png")
  end

  def update(mouse_x, mouse_y)
    @x = mouse_x
    @y = mouse_y
  end

  def draw
    @image.draw(@x - @image.width / 2, @y - @image.height / 2, CROSSHAIR_LAYER)
  end
end
