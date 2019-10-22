require_relative "./gameObject"

class FixedObject < GameObject
  attr_reader :through
  attr_reader :activateFunc

  def initialize(sceneref, x, y, width, height, imgsrc = nil, id = "", activateFunc = "", through = false)
    center = Vector[x + width / 2, y + height / 2]
    super sceneref, center, width, height

    walkPoly = BoundingPolygon.new(self, Vector[0, 0], @width, @height)
    hitPoly = BoundingPolygon.new(self, Vector[0, 0], @width, @height)
    @boundPolys["hit"] = hitPoly
    @boundPolys["walk"] = walkPoly

    if (id.length > 0)
      @id = id
    else
      @id = self.object_id
    end

    if (!imgsrc.nil?)
      @image = Gosu::Image.new(imgsrc, :tileable => true, :retro => true)
    end

    @activateFunc = activateFunc
    @through = through
  end

  def contains(x, y)
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
