require_relative "./gameObject"

class FixedObject < GameObject
  attr_reader :through
  attr_reader :activateFunc

  def initialize(x, y, width, height, activateFunc = "", through = false)
    center = Vector[x + width / 2, y + height / 2]
    super(center, width, height)
    vertices = [Vector[-width / 2, -height / 2], Vector[width / 2, -height / 2], Vector[width / 2, height / 2], Vector[-width / 2, height / 2]]
    vertices2 = [Vector[-width / 2, -height / 2], Vector[width / 2, -height / 2], Vector[width / 2, height / 2 - 1], Vector[-width / 2, height / 2 - 1]]
    walkPoly = BoundingPolygon.new(self, vertices)
    hitPoly = BoundingPolygon.new(self, vertices2)
    @boundPolys["hit"] = hitPoly
    @boundPolys["walk"] = walkPoly

    @activateFunc = activateFunc
    @through = through
  end

  def contains(cameratransf, x, y)
    mouseHom = Vector[x, y, 1]
    worldMouse = cameratransf.inverse * mouseHom
    x = worldMouse[0]
    y = worldMouse[1]

    if (x <= @center[0] + @width / 2 && x >= @center[0] - @width / 2 && y <= @center[1] + @height / 2 && y >= @center[1] - @height / 2)
      return true
    else
      return false
    end
  end

  def activate
    if @activateFunc.empty?
      return
    end
    func = @activateFunc.to_sym
    send(func)
  end
end
