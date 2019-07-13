require_relative "../../gui.rb"
require_relative "./aboutGui.rb"
require_relative "../../constants.rb"

class MainMenuGui < Gui
  def initialize
    super
    @choices = ["Play", "About", "What", "Exit"]
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
    # @selector.draw
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
        SceneManager.changeScene(Scene2.new)
      when 1
        SceneManager.guiPush(AboutGui.new)
      when 3
        close_callback.call
        # close
      else
      end
    end
  end
end
