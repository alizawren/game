require_relative "../rectangle.rb"
require_relative "../constants"
require_relative "../collision.rb"
class GameObject
  attr_reader :x
  attr_reader :y
  attr_reader :vel_x
  attr_reader :vel_y
  attr_reader :boundingRect
  attr_reader :width
  attr_reader :height
  attr_accessor :color

  def initialize(x = 0.0, y = 0.0, width = 30, height = 30)
    @x = x
    @y = y
    @vel_x = @vel_y = @angle = 0.0
    @width = width
    @height = width
<<<<<<< HEAD
    @image = Rectangle.new(@x, @y, @width, @height)
    @polygon = Polygon.new(Vector[0,0],Vector[@width,0],Vector[@width,@height],Vector[0,@height])
=======
    @boundingRect = Rectangle.new(@x, @y, @width, @height)

>>>>>>> 8a4c99469e5defd65ad34f5964423c70fcdff17f
    @allCollidingObjects = []
  end

  def position
    Vector[@x, @y]
  end

  def force(forceVector)
    @x += forceVector[0]
    @y += forceVector[1]
  end

  def goto(x, y)
    @x, @y = x, y
  end

  def turn_left
    @angle -= 4.5
  end

  def turn_right
    @angle += 4.5
  end

  def update
    @boundingRect.color = @color
    move
  end

  def move
    @x += @vel_x
    @y += @vel_y
    @x %= CANVAS_WIDTH
    @y %= CANVAS_HEIGHT
    @polygon.update(@x,@y)
  end

  def draw
    # @boundingRect.draw_rot(@x, @y, 1, @angle)
    @boundingRect.draw(@x, @y, 1)
  end
end
