require "gosu"
require_relative "./gameScene.rb"
require_relative "../gameObjects/player.rb"
require_relative "../gameObjects/enemy.rb"
require_relative "../gameObjects/obstacles/obstacle.rb"
require_relative "../gameObjects/obstacles/wall.rb"
require_relative "../gameObjects/interactable.rb"
require_relative "../quadtree.rb"
require_relative "../constants.rb"
require_relative "../camera.rb"
require_relative "../crosshair.rb"
require_relative "../gameObjects/projectiles/bullet.rb"

require "matrix"

class ActionScene < GameScene
  def load
    super
    @parallax = Gosu::Image.new("img/space.png", :tileable => true)
    @bg = Gosu::Image.new("img/tempbg.png", :tileable => true)

    @player = Player.new(Vector[120, 120], "gamescene")

    @objects["enemies"] = []
    @objects["projectiles"] = []
  end

  def update(mouse_x, mouse_y)
    super
    if Gosu.button_down? Gosu::MS_LEFT
      # angle logic in here
      invtransf = @transform.inverse
      hom = Vector[@player.center[0], @player.center[1], 1]
      pcenter = @transform * hom
      angle = Gosu.angle(pcenter[0], pcenter[1], mouse_x, mouse_y) - 90
      @player.armangle = angle
      case angle
      when -45..45
        # right
        @player.facing = 0
      when 45..135
        # down
        @player.facing = 3
      when 135..225
        # left
        @player.facing = 2
      else
        # up
        @player.facing = 1
      end
      @player.state = 2
    end
  end

  def button_down(id, close_callback)
    super
    case id
    when Gosu::MS_LEFT
      old_pos = @transform.inverse * Vector[@crosshair.x, @crosshair.y, 1]
      bullet = Bullet.new(@player.center, (Vector[old_pos[0], old_pos[1]] - @player.center).normalize * 10)
      @objects["projectiles"].push(bullet)
    end
  end
end
