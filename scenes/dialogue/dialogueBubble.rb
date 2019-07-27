require "gosu"
require_relative "../../constants.rb"

class DialogueBubble
  def initialize(source, text, fps = 20)
    @source = source
    @text = text
    @font = Gosu::Font.new(FONT_HEIGHT, :name => FONT_TYPE)
    @x = 0
    @y = 0
    @z = TEXT_LAYER
    @width = @font.text_width(@text) + MARGIN * 2
    @height = @font.height + MARGIN * 2

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
    @x = @source.x
    @y = @source.y
  end

  def draw(transf)
    vec = transf * Vector[@x, @y, 1]
    # Gosu::draw_rect(@x,@y,@width,@height,Gosu::Color::WHITE)
    @font.draw_text(@text[0, @frame], vec[0] + MARGIN, vec[1] + MARGIN, @z)
  end

  def button_down(id, close_callback)
  end
end
