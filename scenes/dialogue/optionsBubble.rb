
class OptionsBubble
    def initialize(source, choices = ["..."], fps = 20)
      
        @source = source
        @choices = choices
        @font = Gosu::Font.new(FONT_HEIGHT)
        @x = 0
        @y = 0
        @width = @font.text_width(@choices[0])+MARGIN*2
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
        for i in 0..@choices.length - 1
            @font.draw_text(@choices[i][0,@frame], @x+MARGIN, @y + (i+1) * (FONT_HEIGHT + MARGIN), @z)
        end
    end
  
    def button_down(id, close_callback)
        case id
        when Gosu::KB_UP
            @select = (@select + @choices.length - 1) % @choices.length
        when Gosu::KB_DOWN
            @select = (@select + 1) % @choices.length
        when Gosu::KB_RETURN, Gosu::KB_Z
            case @select
            when 0
                SceneManager.guiPop()
            end
        end
    end
  end
  