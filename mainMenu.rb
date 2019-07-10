require 'gosu'
require_relative './sceneManager.rb'
require_relative './scene.rb'
require_relative './scene1.rb'
require_relative './rectangle.rb'
require_relative './constants.rb'

TEXT_Y = 400
FONT_HEIGHT = 24
MARGIN = 12

class MainMenu < Scene
  attr_accessor :background_image

  def load
    @background_image = Gosu::Image.new("img/space.png", :tileable => true)
    @title = Gosu::Image.from_text("A Game? Perhaps?", FONT_HEIGHT * 2)
    @choices = ["Play", "About", "What", "Exit (doesn't work rn lol)"];
    @font = Gosu::Font.new(FONT_HEIGHT)
    @selector = Rectangle.new(0,0,40,30,Gosu::Color::WHITE,0,true)
    @select = 0;
  end

  def unload
  end
  
  def update
        @selector.x = CANVAS_WIDTH / 2 - @font.text_width(@choices[@select])/2 - MARGIN / 2;
        @selector.y = TEXT_Y+@select*(FONT_HEIGHT+MARGIN)
        @selector.width = @font.text_width(@choices[@select])+MARGIN
        @selector.height = FONT_HEIGHT
    
  end

    def button_down(id) 
      case id
      when Gosu::KB_UP
        @select = (@select + @choices.length - 1) % @choices.length
      when Gosu::KB_DOWN
        @select = (@select + 1) % @choices.length
      when Gosu::KB_RETURN, Gosu::KB_Z
        case @select
        when 0 
            SceneManager.changeScene(Scene1.new)
        when 1
        when 3
            # close
        else
        end
      end
    end
  
  def draw
    @background_image.draw(0, 0, 0)
    @title.draw(0,0,0)
    for i in 0..@choices.length-1 do 
        @font.draw_text(@choices[i], CANVAS_WIDTH / 2 - @font.text_width(@choices[i])/2, TEXT_Y+i*(FONT_HEIGHT+MARGIN), 2)
    end
    @selector.draw
  end
end

# Main.new.show