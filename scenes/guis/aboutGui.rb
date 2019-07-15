require_relative "../../gui.rb"
require_relative "../../constants.rb"

class AboutGui < Gui
  def initialize
    super(20, 20)
    @choices = ["Ok"]
  end

  def update
    @selector.x = CANVAS_WIDTH / 2 - @font.text_width(@choices[@select]) / 2 - MARGIN / 2
    @selector.y = TEXT_Y + @select * (FONT_HEIGHT + MARGIN)
    @selector.width = @font.text_width(@choices[@select]) + MARGIN
    @selector.height = FONT_HEIGHT
  end

  def draw
    super
    for i in 0..@choices.length - 1
      @font.draw_text(@choices[i], CANVAS_WIDTH / 2 - @font.text_width(@choices[i]) / 2, TEXT_Y + i * (FONT_HEIGHT + MARGIN), @z)
    end
    text = "If you made it this far, congratulations! Oh, there's no word wrap for this, is there. Welp, here I go. Writing myself off into oblivioooooooooooooooooooooooooooooooooooooooooooooooo"
    @font.draw_text(text, @x + MARGIN, @y + MARGIN, @z)
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
        SceneManager.guiPop
      end
    end
  end
end
