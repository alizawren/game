require_relative "../rectangle.rb"
require_relative "../constants"

class GameObject
  attr_reader :x
  attr_reader :y
  attr_reader :vel_x
  attr_reader :vel_y
  attr_reader :image
  attr_reader :width
  attr_reader :height
  attr_accessor :color

  def initialize(x = 0.0, y = 0.0, width = 30, height = 30)
    @x = x
    @y = y
    @vel_x = @vel_y = @angle = 0.0
    @width = width
    @height = width
    @image = Rectangle.new(@x, @y, @width, @height)

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
    @image.color = @color
    move
  end

  def move
    @x += @vel_x
    @y += @vel_y
    @x %= CANVAS_WIDTH
    @y %= CANVAS_HEIGHT
  end

  def draw
    # @image.draw_rot(@x, @y, 1, @angle)
    @image.draw(@x, @y, 1)
  end
end