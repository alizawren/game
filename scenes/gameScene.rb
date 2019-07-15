require "gosu"
require_relative "../gameObjects/player.rb"
require_relative "../gameObjects/enemy.rb"
require_relative "../gameObjects/obstacles/obstacle.rb"
require_relative "../gameObjects/obstacles/wall.rb"
require_relative "../quadtree.rb"
require_relative "./scene.rb"
require_relative "../constants.rb"
require_relative "../camera.rb"
require_relative "../crosshair.rb"
require "matrix"

class GameScene < Scene
  attr_accessor :parallax

  def load
    @transform = Matrix.I(3)

    @camera = Camera.new

    @quadtree = Quadtree.new(0, Rectangle.new(0, 0, CANVAS_WIDTH, CANVAS_HEIGHT))

    @parallax = Gosu::Image.new("img/space.png", :tileable => true)
    @bg = Gosu::Image.new("img/tempbg.png", :tileable => true)

    @crosshair = Crosshair.instance

    @player = Player.new(Vector[120, 120])

    @enemies = []
    @obstacles = []
    # first we always need walls to prevent character from walking outside of real bg
    bg_width = @bg.width
    bg_height = @bg.height
    wall_thickness = 20
    @obstacles.push(Wall.new(Vector[0, bg_height / 2], wall_thickness / 2, bg_height))
    @obstacles.push(Wall.new(Vector[bg_width / 2, 0], bg_width, wall_thickness / 2))
    @obstacles.push(Wall.new(Vector[bg_width, bg_height / 2], wall_thickness / 2, bg_height))
    @obstacles.push(Wall.new(Vector[bg_width / 2, bg_height], bg_width, wall_thickness / 2))
  end

  def unload
    super
    @quadtree = nil
  end

  def update(mouse_x, mouse_y)
    #can we handle all of this in maybe a player update method?
    if Gosu.button_down? Gosu::KB_LEFT or Gosu::button_down? Gosu::GP_LEFT
      @player.go_left
      # @player.state = 1
      @player.flip = 1
    end
    if Gosu.button_down? Gosu::KB_RIGHT or Gosu::button_down? Gosu::GP_RIGHT
      @player.go_right
      # @player.state = 1
      @player.flip = 0
    end
    if Gosu.button_down? Gosu::KB_UP
      @player.go_up
      # @player.state = 1
    end
    if Gosu.button_down? Gosu::KB_DOWN
      @player.go_down
      # @player.state = 1
    end

    # collision detection
    # @quadtree.clear
    # for i in 0..@allObjects.length - 1
    #   if (!@allObjects[i].nil?)
    #     @quadtree.insert(@allObjects[i])
    #   end
    # end

    # @camera.update(@player.x + @player.width / 2, @player.y + @player.height / 2, @bg.width / 2, @bg.height / 2)
    @camera.update(@player.center, Vector[@bg.width / 2, @bg.height / 2])
    @transform = @camera.transform

    # update transforms for each object
    @player.transform = @transform
    for enemy in @enemies
      enemy.transform = @transform
    end
    for obstacle in @obstacles
      obstacle.transform = @transform
    end

    for enemy in @enemies
      enemy.update(@player.center, @player.velocity)
    end
    for obstacle in @obstacles
      obstacle.update
    end
    @player.update

    # OLD QUADTREE CODE
    # returnObjects = []
    # for i in 0..@allObjects.length - 1
    #   returnObjects = @quadtree.retrieve(@allObjects[i])

    #   for x in 0..returnObjects.length - 1
    #     # run collision detection algorithm between @allObjects[i] and returnObjects[x]
    #     obj1 = @allObjects[i]
    #     obj2 = returnObjects[x]
    #     if obj1 == obj2
    #       break
    #     end
    #     if (overlap(obj1, obj2))
    #       @allObjects[i].color = Gosu::Color::RED
    #       returnObjects[x].color = Gosu::Color::RED
    #     end
    #   end
    # end

    # NOTE: there is an issue with quadtree, it seems particularly when objects are in between two quadrants
    # so, this method simply loops through all objects regardless of quadrant
    for i in 0..@allObjects.length - 1
      if (!@allObjects[i].nil?)
        for x in 0..@allObjects.length - 1
          # run collision detection algorithm between @allObjects[i] and returnObjects[x]
          obj1 = @allObjects[i]
          obj2 = @allObjects[x]
          if obj1 == obj2
            break
          end
          overlap(obj1, obj2)
        end
      end
    end

    @crosshair.update(mouse_x, mouse_y) # might move this location
  end

  def draw
    # NOTE: in the future, we would want to make a bitmap class so that we could easily set their transforms
    # and call bitmap.draw instead of the below
    curr = Vector[0, 0, 1]
    newpos = @transform * curr
    x = newpos[0]
    y = newpos[1]
    @parallax.draw(x, y, 0)
    @bg.draw(x, y, 0)

    @player.draw
    @player.draw_frame
    for enemy in @enemies
      enemy.draw
      enemy.draw_frame
    end
    for obstacle in @obstacles
      obstacle.draw
      obstacle.draw_frame
    end

    @crosshair.draw
  end
end

def overlap(obj1, obj2)
  mtv = Hash.new
  mtvHit = findOverlap(obj1.boundPolys["hit"], obj2.boundPolys["hit"])
  if (mtvHit)
    #call overlap on both objects if they overlap?
    #so they can handle it themselves?
    obj1.overlap(obj2, "hit", mtvHit.v)
    obj2.overlap(obj1, "hit", mtvHit.v)
    mtv["hit"] = mtvHit
  end
  mtvWalk = findOverlap(obj1.boundPolys["walk"], obj2.boundPolys["walk"])
  if (mtvWalk)
    obj1.overlap(obj2, "walk", mtvWalk.v)
    obj2.overlap(obj1, "walk", mtvWalk.v)
    mtv["walk"] = mtvWalk
  end

  return mtv
end
