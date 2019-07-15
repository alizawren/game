require_relative "../boundingPolygon.rb"
require_relative "../constants"
require_relative "../collision.rb"
require "matrix"

class GameObject
  attr_reader :center
  attr_reader :velocity

  attr_reader :boundPoly
  attr_reader :width
  attr_reader :height
  attr_accessor :color
  attr_accessor :transform

  # def initialize(x = 0.0, y = 0.0, width = 30, height = 30)
  def initialize(center = Vector[0.0, 0.0], width = 30, height = 30)
    @center = center
    @velocity = Vector[0.0, 0.0]
    @angle = 0.0
    @width = width
    @height = height

    # in the future, need a polygon for colliding with walls (feet only)
    # and one for colliding with other objects including attacks (whole body)
    @boundPoly = BoundingPolygon.new(self)
    @image = Gosu::Image.new("img/aSimpleSquare.png")

    @transform = Matrix.I(3) # 3x3 to account for translation

    @allCollidingObjects = []
  end

  def go_to(pos)
    @center = pos
  end

  def force(forceVector)
    @center = @center + forceVector
  end

  def turn_left
    @angle -= 4.5
  end

  def turn_right
    @angle += 4.5
  end

  def update
    @boundPoly.transform = @transform
    # implement collisions in here; if collide with wall, can't move
    puts @velocity
    @center = @center + @velocity
    @boundPoly.update
  end

  def draw
    curr = Vector[@center[0], @center[1], 1]
    newpos = @transform * curr
    x = newpos[0]
    y = newpos[1]

    @image.draw(x - @width / 2, y - @height / 2, 1)
  end

  def draw_frame
    @boundPoly.draw
  end

  def overlap(obj2, mtv = Vector[0, 0])
  end
end
