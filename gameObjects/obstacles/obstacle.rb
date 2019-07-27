require "gosu"
require_relative "../gameObject.rb"

class Obstacle < GameObject
  attr_reader :activateFunc # TEMPORARY

  def initialize(center, vertices)
    super(center)

    #calculates the vertices and calls on superclass constructor
    hitPoly = BoundingPolygon.new(self, vertices)
    @boundPolys["hit"] = hitPoly
    @boundPolys["walk"] = hitPoly

    @activateFunc = ""
  end
end
