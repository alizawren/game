require "gosu"
require "matrix"

class BoundingPolygon
  attr_reader :obj
  attr_accessor :center
  attr_reader :width
  attr_reader :height
  attr_reader :halfsize
  attr_accessor :color

  def initialize(obj, relativeCenter = Vector[0, 0], width = obj.width, height = obj.height)
    @color = Gosu::Color::GREEN
    @obj = obj
    @center = obj.center
    @relativeCenter = relativeCenter
    @width = width
    @height = height
    @halfsize = Vector[@width / 2, @height / 2]
  end

  def size
    return Vector[@width, @height]
  end

  def center3
    return Vector[@center[0], @center[1], 1]
  end

  def topleft
    return Vector[@center[0] - width / 2, @center[1] - height / 2]
  end

  def topright
    return Vector[@center[0] + width / 2, @center[1] - height / 2]
  end

  def bottomleft
    return Vector[@center[0] - width / 2, @center[1] + height / 2]
  end

  def bottomright
    return Vector[@center[0] + width / 2, @center[1] + height / 2]
  end

  def update
    @center = @obj.center + @relativeCenter
    #do some kind of rotation/transformation of the halfsize
    #to assist collisions
  end

  def draw(translate, scale)
    pos = @relativeCenter * scale + translate
    w = @halfsize[0] * scale
    h = @halfsize[1] * scale

    # four corners
    v1 = Vector[pos[0] - w, pos[1] - h]
    v2 = Vector[pos[0] + w, pos[1] - h]
    v3 = Vector[pos[0] + w, pos[1] + h]
    v4 = Vector[pos[0] - w, pos[1] + h]

    # just need to draw 4 lines
    # top
    Gosu.draw_line(v1[0], v1[1], @color, v2[0], v2[1], @color, DEBUG_LAYER)
    # right
    Gosu.draw_line(v2[0], v2[1], @color, v3[0], v3[1], @color, DEBUG_LAYER)
    # bottom
    Gosu.draw_line(v3[0], v3[1], @color, v4[0], v4[1], @color, DEBUG_LAYER)
    # left
    Gosu.draw_line(v4[0], v4[1], @color, v1[0], v1[1], @color, DEBUG_LAYER)
  end
end
