require_relative "./menuGui.rb"
require_relative "./aboutGui.rb"
require_relative "../gameScene.rb"

# NOTE: we want to be able to specify GUIs with data files as well

class TempGui < MenuGui
  def initialize
    super(100, 30)
    @choices = ["Gun", "Knife", "Exit"]
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
    text = "Time to pick who has what weapon for the mission :D this GUi doesn't make any sense tho"
    @font.draw_text(text, @x + MARGIN, @y + MARGIN, @z)
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
        currScene.player.currentWeapon.type = "gun"
      when 1
        currScene.player.currentWeapon.type = "melee"
        SceneManager.guiPop()
      else
      end
      SceneManager.guiPop()
    end
  end
end
