require "gosu"
require_relative "../gameObject.rb"

class Obstacle < GameObject
  def initialize(center, vertices)
    super(center)

    #calculates the vertices and calls on superclass constructor
    hitPoly = BoundingPolygon.new(self, vertices)
    @boundPolys["hit"] = hitPoly
    @boundPolys["walk"] = hitPoly
  end

  def draw
    # draw nothing for obstacles for now; scene code will call draw frames
  end
end
