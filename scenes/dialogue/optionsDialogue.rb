
class OptionsDialogue
  def initialize(choices, source = nil, duration = 100, fps = 20, show: true)
    @source = source
    @type = "options"
    @choices = choices
    @font = Gosu::Font.new(FONT_HEIGHT, :name => FONT_TYPE)
    @show = show

    # @width = @font.text_width(@choices[0]) + MARGIN * 2
    @height = @font.height + MARGIN * 2

    @frame = 0
    @duration = duration
    @fps = fps
    @timer = 60 / @fps
    if !@source.nil?
      @x = source.x
      @y = source.y
    else
      @x = 100 + MARGIN
      @y = CANVAS_HEIGHT - 200
    end
    @z = TEXT_LAYER
  end

  def update
    if (@timer == 0)
      if @frame < @choices[0].length + @duration #technically would need to get longest option?
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
          puts "drawing"
          @font.draw_text(@choices[i][0, @frame], vec[0] + MARGIN, vec[1] + (i + 1) * (FONT_HEIGHT + MARGIN), @z)
          @font.draw_text(@choices[i][0, @frame], 0 + MARGIN, (i + 1) * (FONT_HEIGHT + MARGIN), @z)
        end
      end
    else
      for i in 0..@choices.length - 1
        @font.draw_text(@choices[i][0, @frame], @x, @y + (i + 1) * (FONT_HEIGHT + MARGIN), @z)
      end
    end
  end

  def contains(cameratransf, x, y)
    # mouseHom = Vector[x, y, 1]
    # worldMouse = cameratransf.inverse * mouseHom
    # x = worldMouse[0]
    # y = worldMouse[1]

    puts "mouse"
    puts x, y
    puts "dialogue"
    puts @x, @y
    puts @width, @height
    if (x <= @x + @width && x >= @x && y <= @y + @height && y >= @y)
      return true
    else
      return false
    end
  end
end
