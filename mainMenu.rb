require 'gosu'
require_relative './scene.rb'

class MainMenu < Scene
  attr_accessor :background_image
  def initialize
    @background_image = Gosu::Image.new("img/space.png", :tileable => true)
    @title = Gosu::Image.from_text("A Game? Perhaps?", 24)
    @choices = ["Play", "Help", "Seriously help"];
    @font = Gosu::Font.new(24)
    @select = 0;
  end

  def load
  end

  def unload
  end
  
  def update
    # up
      if Gosu.button_down? Gosu::KB_UP or Gosu::button_down? Gosu::GP_BUTTON_0
        
      end
      # down
      if Gosu.button_down? Gosu::KB_DOWN
        
      end
      # select/enter
      if Gosu.button_down? Gosu::KB_ENTER or Gosu::button_down? Gosu::KB_Z
      end
    
  end
  
  def draw
    @background_image.draw(0, 0, 0)
    for i in 0..@choices.length-1 do 
        @font.draw_text(@choices[i], 200, 300+i*20,2)
    end
  end
end

# Main.new.show