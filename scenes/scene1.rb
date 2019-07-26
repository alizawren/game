require "gosu"
require_relative "./cutScene.rb"
require_relative "./scene2.rb"

class Scene1 < CutScene
  attr_accessor :background_image

  def load
    super
    @bg = Gosu::Image.new("img/tempbg.png", :tileable => true)

    @player = Player.new(Vector[120, 380], "cutscene")
    @objects["player"].push(@player)
    # @player = Player.new(50, 50])

    # upper wall
    @objects["obstacles"].push(Wall.new(0, 0, @bg.width, 140))
    # chair
    @objects["obstacles"].push(Wall.new(65, 70, 90, 100))
    # desk
    @objects["obstacles"].push(Obstacle.new(Vector[230, 170], [Vector[0, 0], Vector[0, -80], Vector[70, -80], Vector[70, 60], Vector[-180, 60], Vector[-180, 0]]))
    # pool
    @objects["obstacles"].push(Wall.new(355, 325, 230, 90))
    #couch
    @objects["obstacles"].push(Obstacle.new(Vector[755, 355], [Vector[0, 0], Vector[60, 0], Vector[60, -30], Vector[100, -30], Vector[100, 245], Vector[-140, 245], Vector[-140, 125], Vector[0, 125]]))

    @objects["interactables"].push(Interactable.new(Vector[180, 180], 40, 40, method(:phoneActivate)))
  end

  # NOTE: YES, this is probably a messy way to do this.
  def phoneActivate
    SceneManager.changeScene(Scene2.new)
  end

  def unload
  end
end

# Main.new.show
