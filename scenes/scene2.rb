require "gosu"
require_relative "./gameScene.rb"

class Scene2 < GameScene
  attr_accessor :background_image

  def load
    super
    @player.go_to(50, 50)

    @enemies.push(Enemy.new([Vector[1000, 50], Vector[1005, 50]]))
    @enemies.push(Enemy.new([Vector[1000, 345], Vector[1000, 345]]))
    @enemies.push(Enemy.new([Vector[180, 400], Vector[100, 405]]))

    @obstacles.push(Wall.new(500,500,100,50))
    # @obstacles.push(Wall.new(500,500,50,100))

    @allObjects = []
    @allObjects.push(@player)
    for enemy in @enemies
      @allObjects.push(enemy)
    end
    for obstacle in @obstacles
      @allObjects.push(obstacle)
    end
    # puts @allObjects
  end

  def update
    super
  end
end

# Main.new.show
