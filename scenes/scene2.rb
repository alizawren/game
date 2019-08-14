require "gosu"
require_relative "./actionScene.rb"

class Scene2 < ActionScene
  attr_accessor :background_image

  def load
    super
    @objects["player"].push(@player)
    @objects["enemies"].push(Enemy.new(self,[Vector[400, 50], Vector[450, 50]]))
    # @enemies.push(Enemy.new([Vector[300, 345], Vector[350, 345]]))
    @objects["enemies"].push(Enemy.new(self,[Vector[180, 400], Vector[100, 405]]))

    @objects["obstacles"].push(Wall.new(400, 400, 100, 50))
    # @obstacles.push(Wall.new(500,500,50,100))
    @objects["interactables"].push(Interactable.new(Vector[500, 500], 100, 50, method(:objActivate)))
  end

  def objActivate
    puts "obstacle clicked"
  end
end
