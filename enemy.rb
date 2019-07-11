require 'matrix'
require_relative './rectangle.rb'
require_relative './constants.rb'
require_relative './collision.rb'

#enemy constants
ENEMY_MAX_SPEED = 1.5
ENEMY_MAX_SPEED_PURSUIT = 3.0
MASS = 20.0
ENEMY_MAX_FORCE = 10.0
SLOWING_RADIUS = 50.0
PURSUIT_CONST = 25
IDLE_TIME = 50

class Enemy
    attr_reader :polygon
    # attr_reader :image
    #start with a path the enemy should follow
    def initialize(path = [Vector[0,0], Vector[100,0]])
      #starting position is the first point in the path
      @x = path[0][0]
      @y = path[0][1]
      @width = 30
      @height = 30
      #we'll do textures later,
      #they're just rectangles for now
      @image = Rectangle.new(@x, @y, @width, @height, Gosu::Color::BLUE)
      @polygon = Polygon.new(@image.vertices,Vector[@x,@y])
      @vel_x = @vel_y = 0.0
      @path = path
      @currNode = 1 # which node on path
      @state = 1 # 0 for idle, 1 for moving, 2 for pursuit
      #assign various constants
      @timer = 100
      @enemy_speed = ENEMY_MAX_SPEED
    end
  
    def goto(x, y)
      @x, @y = x, y
    end
    
    def turn_left
      @angle -= 4.5
    end
    
    def turn_right
      @angle += 4.5
    end
    
    def update(playerX=0, playerY=0, playerVelX=0, playerVelY=0)
        targetx = nil;
        targety= nil;
  
        if (@state == 0) 
            # stay in place for some time
            targetx = @x
            targety = @y 
            @timer-=1
            if (@timer == 0) 
                @timer = IDLE_TIME
                @state = 1;
            end
        elsif (@state == 1)
            targetx = @path[@currNode][0]
            targety = @path[@currNode][1]
            if (Math.sqrt((targetx-@x)**2 + (targety-@y)**2) <= 5) 
                @state = 0
                @currNode+=1
                    if (@currNode == @path.length) 
                        @currNode = 0;
                    end
            end

        elsif (@state == 2) 
            # target = position;
            targetx = playerX + playerVelX * PURSUIT_CONST
            targety = playerY + playerVelY * PURSUIT_CONST
        end
        
        if (Math.sqrt((playerX-@x)**2 + (playerY-@y)**2) <= 150) 
            @enemy_speed = ENEMY_MAX_SPEED_PURSUIT
            @state = 2
        end
        
        targetMinusPos = Vector[targetx - @x, targety - @y]
        if !targetMinusPos.zero?
            targetMinusPos = targetMinusPos.normalize
        end

        dist = Math.sqrt((targetx-@x)**2 + (targety-@y)**2)
        desired_velocity = (dist < SLOWING_RADIUS) ? targetMinusPos * @enemy_speed * (dist / SLOWING_RADIUS) : targetMinusPos * @enemy_speed
        steering = Vector[desired_velocity[0] - @vel_x, desired_velocity[1] - @vel_y]
        steering = truncate(steering, ENEMY_MAX_FORCE)
        steering = steering / MASS
        
        newvel = truncate(Vector[@vel_x+steering[0], @vel_y+steering[1]], @enemy_speed)
        @vel_x = newvel[0]
        @vel_y = newvel[1]

        move
    end
    
    def move
      @x += @vel_x
      @y += @vel_y
      @x %= CANVAS_WIDTH
      @y %= CANVAS_HEIGHT
      @polygon.update(@x,@y)
      #   @vel_x *= 0.8
      #   @vel_y *= 0.8
    end
  
    def draw
      # @image.draw_rot(@x, @y, 1, @angle)
      @image.draw(@x,@y,1)
      @polygon.draw
    end

end

def truncate (vec, max_const) 
    i = max_const / vec.magnitude();
    i = i < 1 ? i : 1;
    return Vector[vec[0] * i, vec[1] * i]
end
