require "gosu"
require_relative "./cutScene.rb"

class Scene1 < CutScene
  attr_accessor :background_image

  def load
    super
    @bg = Gosu::Image.new("img/tempbg.png", :tileable => true)

    @player = Player.new(Vector[130, 530])
    @objects["player"].push(@player)
    # @player = Player.new(Vector[50, 50])

    # upper wall
    @objects["obstacles"].push(Wall.new(Vector[@bg.width / 2, 70], @bg.width, 140))
    # chair
    @objects["obstacles"].push(Wall.new(Vector[110, 120], 90, 100))
    # desk lower
    @objects["obstacles"].push(Wall.new(Vector[170, 200], 260, 60))
    # desk right
    @objects["obstacles"].push(Wall.new(Vector[265, 140], 70, 100))
    # pool
    @objects["obstacles"].push(Wall.new(Vector[470, 370], 230, 90))
  end

  def unload
  end
end

# Main.new.show
