require_relative "./menuGui.rb"

class PauseMenuGui < MenuGui
    def initialize
      super 30,30
      @choices = ["Volume", "Unpause"]
    end
  
    def update
      @selector.x = @x - @font.text_width(@choices[@select]) / 2 - MARGIN / 2
      @selector.y = @y + @select * (FONT_HEIGHT + MARGIN)
      @selector.width = @font.text_width(@choices[@select]) + MARGIN
      @selector.height = FONT_HEIGHT
    end
  
    def draw
        super

        for i in 0..@choices.length - 1
            @font.draw_text(@choices[i], @x - @font.text_width(@choices[i]) / 2, @y + i * (FONT_HEIGHT + MARGIN), @z)
            case i 
            when 0
                #show the volume slider
            else
            end
        end
        # @selector.draw
    end
  
    def button_down(id, close_callback)
        case id
        when Gosu::KB_UP
            @select = (@select + @choices.length - 1) % @choices.length
        when Gosu::KB_DOWN
            @select = (@select + 1) % @choices.length
        when Gosu::KB_RIGHT
            case @select 
            when 0
                #increase volume or something
            else
            end 
        when Gosu::KB_LEFT
            case @select
            when 0
                #decrease volume or something
            else
            end
        when Gosu::KB_RETURN, Gosu::KB_Z
            case @select
            when 0
                #this is a slider
            when 1
                SceneManager.guiPop()
            else
            end
        end
    end
  end
  