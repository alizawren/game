require_relative "./gameObject"

class FixedObject < GameObject
  attr_reader :through
  attr_reader :activateFunc

  def initialize(sceneref, x, y, width, height, id = "", imgsrc = nil, activateFunc = "", through = false, scale: 1)
    center = Vector[x + width / 2, y + height / 2]
    super sceneref, center, width, height
    # vertices = [Vector[-width / 2, -height / 2], Vector[width / 2, -height / 2], Vector[width / 2, height / 2], Vector[-width / 2, height / 2]]
    # vertices2 = [Vector[-width / 2, -height / 2], Vector[width / 2, -height / 2], Vector[width / 2, height / 2 - 1], Vector[-width / 2, height / 2 - 1]]
    # walkPoly = BoundingPolygon.new(self, vertices)
    # hitPoly = BoundingPolygon.new(self, vertices2)
    walkPoly = BoundingPolygon.new(self,Vector[0,0],@width,@height)
    hitPoly = BoundingPolygon.new(self,Vector[0,0],@width,@height-1)
    @boundPolys["hit"] = hitPoly
    @boundPolys["walk"] = walkPoly

    if (id.length > 0)
      @id = id
    else
      @id = self.object_id
    end
    
    if (!imgsrc.nil?)
      @image = Gosu::Image.new(imgsrc, :retro => true)
    end
    @scale = scale

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
