require 'gosu'
require_relative './player.rb'
require_relative './scene.rb'
require_relative './enemy.rb'

class Scene1 < Scene
  attr_accessor :background_image
  def load
    @background_image = Gosu::Image.new("img/space.png", :tileable => true)

    @player = Player.new
    @player.goto(50, 50)

    @enemies = []
    @enemies.push(Enemy.new([Vector[660,50], Vector[450,50]]))
    @enemies.push(Enemy.new([Vector[700,300], Vector[500,300]]))
    @enemies.push(Enemy.new([Vector[180,300], Vector[100,300]]))
  end

  def unload
  end
  
  def update
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
      @player.move
  end
  
  def draw
    @background_image.draw(0, 0, 0)
    @player.draw
    for enemy in @enemies do 
      enemy.draw
    end
  end
end

# Main.new.show