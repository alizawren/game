require_relative "./projectile.rb"

class Bullet < Projectile
  def initialize(sceneref, center = Vector[0, 0], velocity = Vector[0, 0], damage = 10, width = 2, height = 2)
    # super sceneref, center, velocity, damage, width, height
    super sceneref
  end
end
