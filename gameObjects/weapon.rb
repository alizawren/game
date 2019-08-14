require "json"
require_relative "./weapons.json"

class Weapon
  attr_reader :id
  attr_reader :name
  attr_reader :type
  attr_reader :damage
  attr_reader :clip
  attr_accessor :ammo
  attr_accessor :projectile
  def initialize(id)
    this.id = id

    file = File.read(jsonfile)
    data = JSON.parse(file)

    this.name = data[id].name
    this.type = data[id].type
    this.damage = data[id].damage
    if this.type == "ranged"
      this.clip = clip
      this.ammo = ammo
      this.projectile = data[id].projectile
  end
end
