require "gosu"

class Dialogue
  def initialize(text, fps = 20, show = true)
    @text = text
    @font = Gosu::Font.new(FONT_HEIGHT)

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
  end

  def draw(x, y, z)
    # Gosu::draw_rect(@x,@y,@width,@height,Gosu::Color::WHITE)
    if @show
      @font.draw_text(@text[0, @frame], x + MARGIN, y + MARGIN, z)
    end
  end

  # def button_down(id,close_callback)
  # end
end
