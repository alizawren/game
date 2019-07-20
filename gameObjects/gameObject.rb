require_relative "../boundingPolygon.rb"
require_relative "../constants.rb"
require_relative "../collision.rb"
require "matrix"

class GameObject
  attr_reader :center
  attr_reader :velocity

  attr_reader :boundPolys
  attr_reader :width
  attr_reader :height
  attr_accessor :transform

  # def initialize(x = 0.0, y = 0.0, width = 30, height = 30)
  def initialize(center = Vector[0.0, 0.0], width = 30, height = 30)
    @center = center
    @velocity = Vector[0.0, 0.0]
    @angle = 0.0
    @width = width
    @height = height

    @transform = Matrix.I(3) # 3x3 to account for translation

    @boundPolys = Hash.new

    @image = Gosu::Image.new("img/aSimpleSquare.png")

    @allCollidingObjects = []
  end

  def x
    @center[0]
  end
  def y
    @center[1]
  end
  def go_to(pos)
    @center = pos
  end

  def force(forceVector)
    puts @center
    @center = @center + forceVector
    puts @center
  end

  def turn_left
    @angle -= 4.5
  end

  def turn_right
    @angle += 4.5
  end

  def update
    # implement collisions in here; if collide with wall, can't move
    @center = @center + @velocity
    @boundPolys.each_value do |value|
      value.update
    end
  end

  def draw
    curr = Vector[@center[0], @center[1], 1]
    newpos = @transform * curr
    x = newpos[0]
    y = newpos[1]

    @image.draw(x - @width / 2, y - @height / 2, 1)
  end

  def draw_frame
    @boundPolys.each_value do |value|
      value.draw
    end
  end

  def overlap(obj2, poly, mtv = Vector[0, 0])
  end
end
