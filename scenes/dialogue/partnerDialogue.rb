require_relative "../../constants.rb"

class PartnerDialogue
  def initialize(text, fps = 20)
    @text = text
    @font = Gosu::Font.new(FONT_HEIGHT, :name => FONT_TYPE)
    @frame = 0
    @fps = fps
    @timer = 60 / @fps
    @x = 0
    @y = 0
    @z = TEXT_LAYER
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

  def draw(transf)
    rect_margin = 20
    rect_padding = 10
    rect_height = 100
    Gosu.draw_rect(rect_margin, CANVAS_HEIGHT - rect_margin - rect_height, CANVAS_WIDTH - 2 * rect_margin, rect_height, BUBBLE_COLOR, @z)
    @font.draw_text(@text[0, @frame], rect_margin + rect_padding, CANVAS_HEIGHT - rect_margin - rect_height + rect_padding, @z)
  end

  def button_down(id, close_callback)
  end
end
