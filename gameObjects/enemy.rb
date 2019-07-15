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

class Enemy < GameObject
  #start with a path the enemy should follow
  def initialize(path = [Vector[0, 0], Vector[100, 0]])
    super()
    #starting position is the first point in the path

    #we'll do textures later,
    #they're just rectangles for now
    @boundPoly = BoundingPolygon.new(self, [Vector[-@width / 2, -@height / 2], Vector[@width / 2, -@height / 2], Vector[@width / 2, @height / 2], Vector[-@width / 2, @height / 2]])

    @path = path
    @center = @path[0]
    @currNode = 1 # which node on path
    @state = 1 # 0 for idle, 1 for moving, 2 for pursuit
    #assign various constants
    @timer = 100
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
    end

    if (distance(playerCenter, @center) <= 150)
      @enemy_speed = ENEMY_MAX_SPEED_PURSUIT
      @state = 2
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

  def overlap(obj2, mtv = Vector[0, 0])
    if (obj2.is_a?(Obstacle))
      force(mtv)
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
