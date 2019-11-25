require_relative "./menuGui.rb"
require_relative "./aboutGui.rb"
require_relative "../gameScene.rb"

# NOTE: we want to be able to specify GUIs with data files as well

class MainMenuGui < MenuGui
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

  def button_down(id, close_callback)
    super
    case id
    when Gosu::KB_RETURN, Gosu::KB_Z
      case @select
      when 0
        SceneManager.changeScene(GameScene.new("scenes/scenefiles/scene1.json"))
        # SceneManager.changeScene(GameScene.new("scenes/scenefiles/scene2.json"))
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
