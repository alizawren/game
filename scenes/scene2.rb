require "gosu"
require_relative "./gameScene.rb"

class Scene2 < GameScene
  attr_accessor :background_image

  def load
    super
    @player.goto(50, 50)

    @enemies.push(Enemy.new([Vector[400, 50], Vector[450, 50]]))
    @enemies.push(Enemy.new([Vector[300, 345], Vector[350, 345]]))
    @enemies.push(Enemy.new([Vector[180, 400], Vector[100, 405]]))

    # @obstacles.push(Wall.new(500,500,50,100))

    @allObjects = []
    @allObjects.push(@player)
    for enemy in @enemies
      @allObjects.push(enemy)
    end
  end
end
