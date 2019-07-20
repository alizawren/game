require "gosu"
require_relative "./obstacle.rb"

class Wall < Obstacle
  #walls are just rectangle shaped obstacles
  def initialize(center, width = 30, height = 30, color = Gosu::Color::WHITE)
    super(center, width, height)
    @center = center
    @width = width
    @height = height
    #calculates the vertices and calls on superclass constructor
    hitPoly = BoundingPolygon.new(self, [Vector[-@width / 2, -@height / 2], Vector[@width / 2, -@height / 2], Vector[@width / 2, @height / 2], Vector[-@width / 2, @height / 2]])

    # NOTE: for easier wall definition, just do x, y, width, height!!!!
    @boundPolys["hit"] = hitPoly
    @boundPolys["walk"] = hitPoly
  end
end
