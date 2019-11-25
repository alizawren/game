require "json"
require_relative "../projectiles/projectile.rb"

class Weapon
  attr_reader :name
  attr_reader :type
  attr_reader :damage
  attr_reader :clip
  attr_reader :projectile
  attr_accessor :ammo
  attr_accessor :range

  def initialize(name)
    file = File.read("gameObjects/weapons/weapons.json")
    data = JSON.parse(file)

    @name = name
    @type = data[name]["type"]
    @damage = data[name]["damage"]
    if @type == "ranged"
      @clip = data[name]["clip"]
      @ammo = data[name]["ammo"]
      # @projectile = data[name]["projectile"]
      #we're moving onto hitscan instead
      @range = data[name]["range"]
    end
  end
end
