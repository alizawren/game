require "matrix"
require_relative "../gameObject.rb"

class Projectile < GameObject
  attr_accessor :damage

  def initialize(sceneref, id, center = Vector[0, 0], velocity = Vector[0, 0])
    @id = id 
    file = File.read("gameObjects/projectiles/projectiles.json")
    data = JSON.parse(file)
    @name = data[id]["name"]
    @damage = data[id]["damage"]
    width = data[id]["width"]
    height = data[id]["height"]

    super sceneref, center, width, height 
    @velocity = velocity
    @angle = Math.atan(velocity[1] / velocity[0])
    hitPoly = BoundingPolygon.new(self, [Vector[-@width / 2, -@height / 2], Vector[@width / 2, -@height / 2], Vector[@width / 2, @height / 2], Vector[-@width / 2, @height / 2]])
    @boundPolys["hit"] = hitPoly
    @sceneref = sceneref
    @lifetime = 0
  end

  def update
    super
    # ensures that projectile gets deleted if it lives for too long
    @lifetime += 1
    if @lifetime > 100
      @sceneref.deleteObject(self.object_id)
    end
  end

  def overlap(obj2, poly, mtv = Vector[0, 0])
    if (obj2.is_a?(FixedObject))
      @sceneref.deleteObject(self.object_id)
    end
    if (obj2.is_a?(Enemy))
      @sceneref.deleteObject(self.object_id)
    end
  end
end
