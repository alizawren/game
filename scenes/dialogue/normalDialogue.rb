require "gosu"

class NormalDialogue
  def initialize(text, source = false, duration = 50, fps = 20, show: true)
    @source = source
    @type = "normal"
    @text = text
    @font = Gosu::Font.new(FONT_HEIGHT, :name => FONT_TYPE)

    @width = @font.text_width(@text) + MARGIN * 2
    @height = @font.height + MARGIN * 2

    @frame = 0
    @duration = duration
    @fps = fps
    @timer = 60 / @fps
    if @source
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
      if @frame < @text.length + @duration
        @frame += 1
      else
        show = false
      end
      @timer = 60 / @fps
    else
      @timer -= 1
    end
    @x = @source.x
    @y = @source.y
  end

  def draw(transform = Vector[0, 0, 0])
    # Gosu::draw_rect(@x,@y,@width,@height,Gosu::Color::WHITE)
    if @source
      if @show
        vec = transform * Vector[@x, @y, 1]
        @font.draw_text(@text[0, @frame], vec[0] + MARGIN, vec[1] + MARGIN, @z)
      end
    else
      @font.draw_text(@text[0, @frame], 100, CANVAS_HEIGHT - 200, @z)
    end
  end

  # def button_down(id,close_callback)
  # end
end
