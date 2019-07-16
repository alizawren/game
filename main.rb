require "gosu"
require_relative "./sceneManager.rb"
require_relative "./scenes/mainMenu.rb"
require_relative "./scenes/scene1.rb"
require_relative "./scenes/scene2.rb"

class Main < Gosu::Window
  def initialize
    super 1280, 720
    self.caption = "Game?"

    @scene1 = Scene1.new
    @scene2 = Scene2.new
    @menu = MainMenu.new
    SceneManager.changeScene(@menu)
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
      SceneManager.changeScene(@menu)
    else
      super
    end
  end
end

Main.new.show
