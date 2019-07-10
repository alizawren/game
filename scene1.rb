require 'gosu'
require_relative './player.rb'
require_relative './scene.rb'

class Scene1 < Scene
  attr_accessor :background_image
  def load
    @background_image = Gosu::Image.new("img/space.png", :tileable => true)

    @player = Player.new
    @player.goto(320, 240)
  end

  def unload
  end
  
  def update
    if Gosu.button_down? Gosu::KB_LEFT or Gosu::button_down? Gosu::GP_LEFT
        @player.turn_left
      end
      if Gosu.button_down? Gosu::KB_RIGHT or Gosu::button_down? Gosu::GP_RIGHT
        @player.turn_right
      end
      if Gosu.button_down? Gosu::KB_UP or Gosu::button_down? Gosu::GP_BUTTON_0
        @player.accelerate
      end
      @player.move
  end
  
  def draw
    @background_image.draw(0, 0, 0)
    @player.draw
  end
end

# Main.new.show