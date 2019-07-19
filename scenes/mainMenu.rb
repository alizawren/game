require "gosu"
require_relative "./scene.rb"
require_relative "./scene1.rb"
require_relative "../rectangle.rb"
require_relative "../constants.rb"
require_relative "./guis/mainMenuGui.rb"

TEXT_Y = 400

class MainMenu < Scene
  attr_accessor :background_image

  def load
    @background_image = Gosu::Image.new("img/space.png", :tileable => true)
    @title = Gosu::Image.from_text("A Game? Perhaps?", FONT_HEIGHT * 2)

    SceneManager.guiPush(MainMenuGui.new)
  end

  def draw
    @background_image.draw(0, 0, 0)
    @title.draw(0, 0, 0)
  end
  def button_down(id,close_callback)
  end
end
