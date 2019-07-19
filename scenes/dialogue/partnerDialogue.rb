
class PartnerDialogue
    def initialize(text, fps = 20)
        @text = text
        @font = Gosu::Font.new(FONT_HEIGHT)
        @frame = 0
        @fps = fps
        @timer = 60 / @fps
    end
  
    def update
        if (@timer == 0)
            if @frame < @text.length
                @frame += 1
            end
            @timer = 60 / @fps
        else
            @timer -= 1
        end
    end
  
    def draw
        @Gosu.draw_rect(200,CANVAS_HEIGHT-300,CANVAS_WIDTH-210,290)
        @font.draw_text(@text[0,@frame],@x,@y,@z)

    end
  
    def button_down(id, close_callback)

    end
  end
  