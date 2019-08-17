require "json"
require_relative "../projectiles/projectile.rb"
class Weapon
  attr_reader :name
  attr_reader :type
  attr_reader :damage
  attr_reader :clip
  attr_reader :projectile
  attr_accessor :ammo
  
  def initialize(name)
    file = File.read("gameObjects/weapons/weapons.json")
    data = JSON.parse(file)

    @name = name
    @type = data[name]["type"]
    @damage = data[name]["damage"]
    if @type == "ranged"
      @clip = clip
      @ammo = ammo
      @projectile = data[name]["projectile"]
    end
  end
end
