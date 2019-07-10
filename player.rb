require_relative './rectangle.rb'
require_relative './constants'

MAX_SPEED = 5

class Player
  attr_reader :x
  attr_reader :y
  attr_reader :vel_x
  attr_reader :vel_y

    def initialize
      # @image = Gosu::Image.new("img/starfighter.bmp")
      @image = Rectangle.new
      @x = @y = @vel_x = @vel_y = @angle = 0.0
    end
    def position
      Vector[@x,@y]
    end
    def force(forceVector)
      @x += forceVector[0]
      @y += forceVector[1]
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

    def go_up
      if (@vel_y - 2 > -MAX_SPEED)
        @vel_y -= 2
      end
    end

    def go_down
      if (@vel_y + 2 < MAX_SPEED)
        @vel_y += 2
      end
    end

    def go_left
      if (@vel_x - 2 > -MAX_SPEED)
        @vel_x -= 2
      end
    end

    def go_right
      if (@vel_x + 2 < MAX_SPEED)
        @vel_x += 2
      end
    end
    
    def accelerate
      @vel_x += Gosu.offset_x(@angle, 0.5)
      @vel_y += Gosu.offset_y(@angle, 0.5)
    end
    
    def move
      @x += @vel_x
      @y += @vel_y
      @x %= CANVAS_WIDTH
      @y %= CANVAS_HEIGHT
      
      @vel_x *= 0.8
      @vel_y *= 0.8
    end
  
    def draw
      # @image.draw_rot(@x, @y, 1, @angle)
      @image.draw(@x,@y,1)
    end
  end