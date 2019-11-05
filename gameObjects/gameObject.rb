require_relative "../boundingPolygon.rb"
require_relative "../constants.rb"
require_relative "../collision.rb"
require "matrix"

class GameObject
  attr_reader :center
  attr_reader :velocity

  attr_reader :id
  attr_accessor :image
  attr_accessor :boundPolys

  attr_accessor :z
  attr_reader :width
  attr_reader :height
  attr_reader :transform
  attr_reader :halfsize

  # def initialize(x = 0.0, y = 0.0, width = 30, height = 30)
  def initialize(sceneref, center = Vector[0.0, 0.0], width = 128, height = 128, id = "", z = OBJECT_LAYER)
    @sceneref = sceneref
    if (id.length > 0)
      @id = id
    else
      @id = self.object_id
    end
    @center = center
    @velocity = Vector[0.0, 0.0]
    @angle = 0.0
    @width = width # should be constant
    @height = height # should be constant
    @halfsize = Vector[width / 2, height / 2] # should be constant
    @transform = Matrix.I(3) # 3x3 to account for translation

    @boundPolys = Hash.new

    @z = z

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

  def draw(translate, scale)
    pos = @center * scale + translate
    x = pos[0]
    y = pos[1]
    w = @width * scale
    h = @height * scale

    if (!@image.nil?)
      color = Gosu::Color::WHITE

      @image.draw_as_quad(x - w / 2, y - h / 2, color, x + w / 2, y - h / 2, color, x + w / 2, y + h / 2, color, x - w / 2, y + h / 2, color, @z)
      # @image.draw(x - w / 2, y - h / 2, @z, scale, scale)
    end
  end

  def draw_frame(translate, scale)
    @boundPolys.each_value do |value|
      newScale = scale * 1 # since the objects themselves don't have scales, we simply pass on the parameter
      newTrans = @center * scale + translate
      value.draw(newTrans, newScale)
    end
  end

  def overlap(obj2, poly, overlap = Vector[0, 0])
  end
end
