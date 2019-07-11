require 'gosu'
require_relative './player.rb'
require_relative './gameScene.rb'
require_relative './enemy.rb'
require_relative './obstacle.rb'

class Scene1 < GameScene
  attr_accessor :background_image
  def load
    # @background_image = Gosu::Image.new("img/space.png", :tileable => true)

    @player = Player.new
    @player.goto(50, 50)

    @enemies = []
    @enemies.push(Enemy.new([Vector[660,50], Vector[450,50]]))
    @enemies.push(Enemy.new([Vector[700,300], Vector[500,300]]))
    @enemies.push(Enemy.new([Vector[180,300], Vector[100,300]]))
    @obstacles = []

    @obstacles.push(Wall.new(500,500,50,100))
  end

  def unload
  end
  
end

# Main.new.show