
class OptionsDialogue
  def initialize(choices, source = nil, duration = 100, fps = 20, show: true)
    @source = source
    @type = "options"
    @choices = choices
    @font = Gosu::Font.new(FONT_HEIGHT, :name => FONT_TYPE)
    @show = show

    @width = @font.text_width(@choices[0]) + MARGIN * 2
    @height = @font.height + MARGIN * 2

    @frame = 0
    @duration = duration
    @fps = fps
    @timer = 60 / @fps
    if !@source.nil?
      @x = source.x
      @y = source.y
    else
      @x = 0
      @y = 0
    end
    @z = TEXT_LAYER
  end

  def update
    if (@timer == 0)
      if @frame < @text.length + duration
        @frame += 1
      else
        @show = false
      end
      @timer = 60 / @fps
    else
      @timer -= 1
    end
    #do some kind of check for mouse clicking
  end

  def draw(transform = Vector[0, 0, 0])
    if !@source.nil?
      if @show
        vec = transform * Vector[@x, @y, 1]
        for i in 0..@choices.length - 1
          @font.draw_text(@choices[i][0, @frame], vec[0] + MARGIN, vec[1] + (i + 1) * (FONT_HEIGHT + MARGIN), @z)
        end
      end
    else

      for i in 0..@choices.length - 1
        @font.draw_text(@choices[i][0, @frame], 100+ MARGIN, CANVAS_WIDTH + (i + 1) * (FONT_HEIGHT + MARGIN), @z)
      end
    end
  end

  def contains(cameratransf, x, y)
    mouseHom = Vector[x, y, 1]
    worldMouse = cameratransf.inverse * mouseHom
    x = worldMouse[0]
    y = worldMouse[1]

    if (x <= @center[0] + @width / 2 && x >= @center[0] - @width / 2 && y <= @center[1] + @height / 2 && y >= @center[1] - @height / 2)
      return true
    else
      return false
    end
  end

  # def button_down(id, close_callback)
  #     case id
  #     when Gosu::KB_UP
  #         @select = (@select + @choices.length - 1) % @choices.length
  #     when Gosu::KB_DOWN
  #         @select = (@select + 1) % @choices.length
  #     when Gosu::KB_RETURN, Gosu::KB_Z
  #         case @select
  #         when 0
  #             SceneManager.guiPop()
  #         end
  #     end
  # end
end
