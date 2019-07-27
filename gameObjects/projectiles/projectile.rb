require "matrix"
require_relative "../gameObject.rb"

class Projectile < GameObject
  attr_accessor :damage

  def initialize(sceneref, center = Vector[0, 0], velocity = Vector[0, 0], damage = 0, width = 2, height = 2)
    super(center, width, height)
    @velocity = velocity
    @angle = Math.atan(velocity[1] / velocity[0])
    hitPoly = BoundingPolygon.new(self, [Vector[-@width / 2, -@height / 2], Vector[@width / 2, -@height / 2], Vector[@width / 2, @height / 2], Vector[-@width / 2, @height / 2]])
    @boundPolys["hit"] = hitPoly
    @sceneref = sceneref
  end

  def overlap(obj2, poly, mtv = Vector[0, 0])
    if (obj2.is_a?(Obstacle))
      @velocity = Vector[0, 0]
      @sceneref.delete(self.object_id)
    end
  end
end
