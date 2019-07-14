require_relative "../rectangle.rb"
require_relative "../constants"
require_relative "../collision.rb"
require "matrix"

class GameObject
  attr_reader :x # read only! important!
  attr_reader :y
  attr_reader :vel_x
  attr_reader :vel_y
  attr_reader :bounding
  attr_reader :width
  attr_reader :height
  attr_accessor :color
  attr_accessor :transform

  def initialize(x = 0.0, y = 0.0, width = 30, height = 30)
    @x = x
    @y = y
    @vel_x = @vel_y = @angle = 0.0
    @width = width
    @height = width
    @bounding = Rectangle.new(@x, @y, @width, @height)

    @transform = Matrix.I(3) # 3x3 to account for translation

    @allCollidingObjects = []
  end

  def position
    Vector[@x, @y]
  end

  def force(forceVector)
    @x += forceVector[0]
    @y += forceVector[1]
  end

  def go_to(x, y)
    @x, @y = x, y
  end

  def turn_left
    @angle -= 4.5
  end

  def turn_right
    @angle += 4.5
  end

  def update
    @bounding.color = @color
    move
  end

  def move
    # implement collisions in here; if collide with wall, can't move

    @x += @vel_x
    @y += @vel_y
    @x %= CANVAS_WIDTH
    @y %= CANVAS_HEIGHT
    @bounding.update(@x, @y)
  end

  def draw
    # @boundingRect.draw_rot(@x, @y, 1, @angle)
    curr = Vector[@x, @y, 1]
    newpos = @transform * curr
    x = newpos[0]
    y = newpos[1]

    @bounding.draw(x, y, 1)
  end

  def overlap(obj2, mtv = Vector[0, 0])
  end
end
