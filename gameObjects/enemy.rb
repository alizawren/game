require "matrix"
require_relative "../rectangle.rb"
require_relative "../constants"
require_relative "./gameObject.rb"

#enemy constants
ENEMY_MAX_SPEED = 1.5
ENEMY_MAX_SPEED_PURSUIT = 3.0
MASS = 20.0
ENEMY_MAX_FORCE = 10.0
SLOWING_RADIUS = 50.0
PURSUIT_CONST = 25
IDLE_TIME = 50
ATTACK_SPEED = 100

class Enemy < GameObject
  #start with a path the enemy should follow
  def initialize(sceneref, path = [Vector[0, 0], Vector[100, 0]], weaponID = "Pistol")
    @path = path
    @center = @path[0]
    super sceneref, @center
    #starting position is the first point in the path
    @image = Gosu::Image.new("img/aSimpleSquare.png")

    #we'll do textures later,
    #they're just rectangles for now
    # hitPoly = BoundingPolygon.new(self, [Vector[-@width / 2, -@height / 2], Vector[@width / 2, -@height / 2], Vector[@width / 2, @height / 2], Vector[-@width / 2, @height / 2]])
    hitPoly = BoundingPolygon.new(self, Vector[0, 0], @width, @height)

    @boundPolys["hit"] = hitPoly

    @currNode = 1 # which node on path
    @state = 1 # 0 for idle, 1 for moving, 2 for pursuit
    #assign various constants
    @timer = 100
    @attackTimer = ATTACK_SPEED
    @weapon = Weapon.new(weaponID)
    @enemy_speed = ENEMY_MAX_SPEED
  end

  def update(playerCenter = Vector[0, 0], playerVelocity = Vector[0, 0])
    target = nil

    if (@state == 0)
      # stay in place for some time
      target = @center
      @timer -= 1
      if (@timer == 0)
        @timer = IDLE_TIME
        @state = 1
      end
    elsif (@state == 1)
      target = @path[@currNode]
      if (distance(target, @center) <= 5)
        @state = 0
        @currNode += 1
        if (@currNode == @path.length)
          @currNode = 0
        end
      end
    elsif (@state == 2)
      target = playerCenter + playerVelocity * PURSUIT_CONST
      if (@attackTimer == ATTACK_SPEED)
        @attackTimer = 0
        case @weapon.type
        when "ranged"
          # projectile = Projectile.new(@sceneref, @weapon.projectile,@center,(playerCenter-@center).normalize * BULLET_SPEED)
          # @sceneref.objects["projectiles"].push(projectile)
          # @weapon.hitscan(@center,playerCenter,@sceneref.objects,[self])

          collisionPoint = hitscan(@center, playerCenter, [self])
          if (!collisionPoint.nil?)
            @sceneref.hitscans.push([@center, collisionPoint])
          else
            p2 = ((playerCenter - @center).normalize() * @weapon.range)
            @sceneref.hitscans.push([@center, p2])
          end
        when "melee"
          #still don't know how to do melee...
        end
      end
      @attackTimer += 1
    end

    if (distance(playerCenter, @center) <= 150)
      @enemy_speed = ENEMY_MAX_SPEED_PURSUIT
      @state = 2
    end

    if (distance(playerCenter, @center) >= 200)
      @enemy_speed = ENEMY_MAX_SPEED
      @state = 1
    end

    targetMinusPos = target - @center
    if !targetMinusPos.zero?
      targetMinusPos = targetMinusPos.normalize
    end

    # dist = Math.sqrt((target[0] - @center[0]) ** 2 + (target[1] - @center[1]) ** 2)
    dist = distance(target, @center)
    desired_velocity = (dist < SLOWING_RADIUS) ? targetMinusPos * @enemy_speed * (dist / SLOWING_RADIUS) : targetMinusPos * @enemy_speed
    steering = desired_velocity - @velocity
    steering = truncate(steering, ENEMY_MAX_FORCE)
    steering = steering / MASS

    # newvel = truncate(Vector[@vel_x + steering[0], @vel_y + steering[1]], @enemy_speed)
    newvel = truncate(@velocity + steering, @enemy_speed)
    @velocity = newvel

    super()
  end

  def overlap(obj2, poly, overlap = Vector[0, 0])
    # case poly
    # when "hit"
    # when "walk"
    #   if (obj2.is_a?(Obstacle))
    #     force(-mtv)
    #   end
    # end
    boundPolys["hit"].color = Gosu::Color::RED
    if (obj2.is_a?(Obstacle))
      if (overlap[0] == 0)
        if (obj2.center[0] > @center[0])
          # puts("touch right")
          @velocity[0] = @velocity[0] > 0 ? 0 : @velocity[0]
        else
          # puts("touch left")
          @velocity[0] = @velocity[0] < 0 ? 0 : @velocity[0]
        end
      elsif (overlap[1] == 0)
        if (obj2.center[1] > @center[1])
          # puts("touch down")
          @velocity[1] = @velocity[1] > 0 ? 0 : @velocity[1]
        else
          # puts("touch up")
          @velocity[1] = @velocity[1] < 0 ? 0 : @velocity[1]
        end
      elsif (overlap[0]).abs <= (overlap[1]).abs
        @center[0] += overlap[0]
        if (overlap[0] < 0)
          # puts("overlap right")
          @velocity[0] = @velocity[0] > 0 ? 0 : @velocity[0]
        else
          # puts("overlap left")
          @velocity[0] = @velocity[0] < 0 ? 0 : @velocity[0]
        end
      else
        # puts(overlap)
        @center[1] += overlap[1]
        if (overlap[1] < 0)
          # puts("overlap down")
          @velocity[1] = @velocity[1] > 0 ? 0 : @velocity[1]
        else
          # puts("overlap up")
          @velocity[1] = @velocity[1] < 0 ? 0 : @velocity[1]
        end
      end
    end
    if (obj2.is_a?(Projectile))
      #kill this enemy somehow
    end
  end
end

def truncate(vec, max_const)
  i = max_const / vec.magnitude()
  i = i < 1 ? i : 1
  return Vector[vec[0] * i, vec[1] * i] # deep copy
end

def distance(vec1, vec2)
  return Math.sqrt((vec1[0] - vec2[0]) ** 2 + (vec1[1] - vec2[1]) ** 2)
end
