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
  def hitscan(source,target,objects,ignore=[])
    p1 = source
    
    hit = ((target-p1).normalize() * @range)
    p2 = Vector[hit[0]+p1[0],hit[1]+p1[1]]
    cp = []
    objects.each_value do |objectType|
      objectType.each do |obj|
        if !ignore.include?(obj)
          poly = obj.boundPolys["hit"]
          if(!poly.nil?)
            collisionPoint = lineRectCollision(p1,p2,poly.topleft,poly.topright,poly.bottomright,poly.bottomleft)
            if !collisionPoint.nil?
              cp.push(collisionPoint)
              
              # obj.overlap("Bullet","hit")
              # return(collisionPoint)
            end
          end
        end
      end
    end
    closest = cp[0]
    for point in cp
      if (point-p1).magnitude < (closest-p1).magnitude 
        closest = point
      end
    end
    return(closest)
  end
end
def lineRectCollision(l1,l2,r1,r2,r3,r4)
  cp1 = lineLineCollision(l1,l2,r1,r2)
  cp2 = lineLineCollision(l1,l2,r2,r3)
  cp3 = lineLineCollision(l1,l2,r3,r4)
  cp4 = lineLineCollision(l1,l2,r4,r1)
  cp = [] 
  if(!cp1.nil?)
    cp.push(cp1)
  end
  if(!cp2.nil?)
    cp.push(cp2)
  end
  if(!cp3.nil?)
    cp.push(cp3)
  end
  if(!cp4.nil?)
    cp.push(cp4)
  end
  if cp.length == 0
    return 
  end
  closest = cp[0]
  for point in cp
    if (point-l1).magnitude < (closest-l1).magnitude 
      closest = point
    end
  end
  return(closest)
end

def lineLineCollision(p1,p2,p3,p4)
  den = (p4[1]-p3[1])*(p2[0]-p1[0])-(p4[0]-p3[0])*(p2[1]-p1[1])
  num1 = (p4[0]-p3[0])*(p1[1]-p3[1])-(p4[1]-p3[1])*(p1[0]-p3[0])
  num2 = (p2[0]-p1[0])*(p1[1]-p3[1])-(p2[1]-p1[1])*(p1[0]-p3[0])
  if(den == 0)
    if(num1 == 0 && num2 == 0)
      return(p2)
    end
  else
    uA = num1/den 
    uB = num2/den
    if(uA >= 0 && uA <= 1 && uB >= 0 && uB <= 1)
      return(Vector[p1[0]+(uA*(p2[0]-p1[0])),p1[1]+(uA*(p2[1]-p1[1]))])
    end
  end
end