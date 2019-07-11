require 'gosu'
require_relative './player.rb'
require_relative './scene.rb'
require_relative './enemy.rb'
require_relative './obstacle.rb'
require_relative './collision.rb'
class GameScene < Scene
  attr_accessor :background_image
  def load
    @background_image = Gosu::Image.new("img/space.png", :tileable => true)

    @player = Player.new
    @player.goto(50, 50)

    @enemies = []
    @obstacles = []
  end

  def unload
  end
  
  def update
    for enemy in @enemies do 
      enemy.update(@player.x, @player.y, @player.vel_x, @player.vel_y)
    end
    for obstacle in @obstacles do
      obstacle.update
    end
    
    #update obstacles and enems first before checking collisions
    if Gosu.button_down? Gosu::KB_LEFT or Gosu::button_down? Gosu::GP_LEFT
      @player.go_left
    end
    if Gosu.button_down? Gosu::KB_RIGHT or Gosu::button_down? Gosu::GP_RIGHT
      @player.go_right
    end
    if Gosu.button_down? Gosu::KB_UP
      @player.go_up
    end
    if Gosu.button_down? Gosu::KB_DOWN
      @player.go_down
    end

    @player.move

    #check collisions after the player moves
    for enemy in @enemies do
      if checkCollision(@player.polygon,enemy.polygon) 
        # puts "touch"
        @player.goto(50,50)
      end
    end

    for obstacle in @obstacles do
      #check if player is in/touching obstacle
      overlap = findOverlap(@player.polygon,obstacle.polygon)
      if overlap 
        #if they are, move the player out of the obstacle
        @player.force(overlap.v)
      end
    end

  end
  
  def draw
    # @background_image.draw(0, 0, 0)
    @player.draw
    for enemy in @enemies do 
      enemy.draw
    end
    for obstacle in @obstacles do
      obstacle.draw
    end
  end
end

# Main.new.show