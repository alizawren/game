require_relative "../boundingPolygon.rb"
require_relative "../constants.rb"
require_relative "../collision.rb"
require "matrix"

class GameObject
  attr_reader :center
  attr_reader :velocity

  attr_accessor :image
  attr_accessor :boundPolys

  attr_accessor :z
  attr_reader :width
  attr_reader :height
  attr_reader :transform

  # def initialize(x = 0.0, y = 0.0, width = 30, height = 30)
  def initialize(center = Vector[0.0, 0.0], width = 30, height = 30)
    @center = center
    @velocity = Vector[0.0, 0.0]
    @angle = 0.0
    @width = width
    @height = height

    @transform = Matrix.I(3) # 3x3 to account for translation

    @boundPolys = Hash.new

    # @image = Gosu::Image.new("img/aSimpleSquare.png")

    @z = 1

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
    @center = @center + forceVector
  end

  def update
    # implement collisions in here; if collide with wall, can't move
    @center = @center + @velocity
    @boundPolys.each_value do |value|
      value.update
      @z = BELOW_PLAYER
    end
  end

  def draw(transf = Matrix.I(3))
    curr = Vector[@center[0], @center[1], 1]
    newpos = transf * @transform * curr
    x = newpos[0]
    y = newpos[1]

    if (!@image.nil?)
      @image.draw(x - @width / 2, y - @height / 2, @z)
      # @image.draw(@center[0], @center[1], @z)
    end
  end

  def draw_frame(transf = Matrix.I(3))
    @boundPolys.each_value do |value|
      value.draw(transf)
    end
  end

  def overlap(obj2, poly, mtv = Vector[0, 0])
  end
end
