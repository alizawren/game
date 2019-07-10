require 'gosu'
require_relative './player.rb'
require_relative './scene.rb'

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
    #can we handle all of this in maybe a player update method?
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

      for enemy in @enemies do 
        enemy.update(@player.x, @player.y, @player.vel_x, @player.vel_y)
      end
      for obstacle in @obstacles do
        obstacle.update
      end
      @player.move
  end
  
  def draw
    @background_image.draw(0, 0, 0)
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