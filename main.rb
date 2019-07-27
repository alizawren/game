require "gosu"
require_relative "./sceneManager.rb"
require_relative "./scenes/mainMenu.rb"

class Main < Gosu::Window
  def initialize
    super 1280, 720
    self.caption = "Game?"

    SceneManager.changeScene(MainMenu.new)
  end

  def update
    SceneManager.update(mouse_x, mouse_y)
  end

  def draw
    SceneManager.draw
  end

  def button_down(id)
    SceneManager.button_down(id, method(:close))

    if id == Gosu::KB_ESCAPE
      SceneManager.changeScene(MainMenu.new)
    else
      super
    end
  end
end

Main.new.show
