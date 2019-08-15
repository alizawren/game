require "json"
require_relative "../projectiles/projectile.rb"
class Weapon
  attr_reader :id
  attr_reader :name
  attr_reader :type
  attr_reader :damage
  attr_reader :clip
  attr_reader :projectile
  attr_accessor :ammo
  
  def initialize(id)
    @id = id
    file = File.read("gameObjects/weapons/weapons.json")
    data = JSON.parse(file)

    @name = data[id]["name"]
    @type = data[id]["type"]
    @damage = data[id]["damage"]
    if @type == "ranged"
      @clip = clip
      @ammo = ammo
      @projectile = data[id]["projectile"]
    end
  end
  def newProjectile(sceneref,center,velocity)
    return Projectile.new(sceneref,@projectile,center,velocity)
  end
end
