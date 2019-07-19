
class DialogueBubble
    def initialize(source, text, fps = 20)
      
        @source = source
        @text = text
        @font = Gosu::Font.new(FONT_HEIGHT)
        @x = 0
        @y = 0
        @width = @font.text_width(@text)+MARGIN*2
        @height = @font.height+MARGIN*2

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
        curr = Vector[@source.x+@source.width, @source.y-@source.height/2, 1]
        newpos = @source.transform * curr
        x = newpos[0]
        y = newpos[1]
        @x = x
        @y = y
    end
  
    def draw
        @font.draw_text(@text[0,@frame],@x+MARGIN,@y+MARGIN,@z)
    end
    def button_down(id,close_callback)
    end
  end
  