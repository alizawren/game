require_relative "./gameObject.rb"

class Interactable < GameObject
  def initialize(center = Vector[0.0, 0.0], width = 30, height = 30, activateFunc)
    super(center, width, height)

    #calculates the vertices and calls on superclass constructor
    vertices = [Vector[-@width / 2, -@height / 2], Vector[@width / 2, -@height / 2], Vector[@width / 2, @height / 2], Vector[-@width / 2, @height / 2]]
    hitPoly = BoundingPolygon.new(self, vertices)
    @boundPolys["hit"] = hitPoly
    @boundPolys["walk"] = hitPoly

    @activateFunc = activateFunc
  end

  def contains(x, y)
    hom = Vector[@center[0], @center[1], 1]
    newcenter = @transform * hom

    if (x <= newcenter[0] + @width / 2 && x >= newcenter[0] - @width / 2 && y <= newcenter[1] + @height / 2 && y >= newcenter[1] - @height / 2)
      return true
    else
      return false
    end
  end

  def activate
    # puts "I was clicked!"
    @activateFunc.call
  end
end
