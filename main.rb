require "gosu"
require_relative "./SceneManager.rb"
require_relative "./scenes/TitleScene.rb"

class Main < Gosu::Window
  def initialize
    super 1280, 720
    self.caption = "Game?"

    SceneManager.run
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
      SceneManager.run
    else
      super
    end
  end
end

Main.new.show
