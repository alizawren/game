require_relative "../constants.rb"
require_relative "../sceneManager.rb"

# when making scenes, implement each of the below methods
class Scene
  def initialize
    @windows = []
  end

  # necessary methods
  def update(mouse_x, mouse_y)
  end

  def button_down(id, close_callback)
  end

  # Return to Calling Scene
  def return_scene
    SceneManager.return
  end

  def draw
  end

  # optional methods
  def transitionIn
  end

  def transitionOut
  end
end
