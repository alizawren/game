require "gosu"
require_relative "./gameScene.rb"
require_relative "../gameObjects/player.rb"
require_relative "../gameObjects/obstacles/obstacle.rb"
require_relative "../gameObjects/obstacles/wall.rb"
require_relative "../gameObjects/interactable.rb"
require_relative "../quadtree.rb"
require_relative "../constants.rb"
require_relative "../camera.rb"
require_relative "../crosshair.rb"

require "matrix"

class CutScene < GameScene
  def load
    super
    @parallax = Gosu::Image.new("img/space.png", :tileable => true)
    @bg = Gosu::Image.new("img/tempbg.png", :tileable => true)

    @player = Player.new(Vector[130, 450], "cutscene")
  end

  def update(mouse_x, mouse_y)
    super
  end
end
