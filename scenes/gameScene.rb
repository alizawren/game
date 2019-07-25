require "gosu"
require_relative "../gameObjects/player.rb"
require_relative "../gameObjects/enemy.rb"
require_relative "../gameObjects/obstacles/obstacle.rb"
require_relative "../gameObjects/obstacles/wall.rb"
require_relative "../gameObjects/interactable.rb"
require_relative "../quadtree.rb"
require_relative "./scene.rb"
require_relative "../constants.rb"
require_relative "../camera.rb"
require_relative "../crosshair.rb"
require_relative "./guis/pauseMenuGui.rb"
require_relative "./dialogue/dialogueBubble.rb"
require_relative "./dialogue/optionsBubble.rb"
require_relative "./dialogue/partnerDialogue.rb"
require_relative "../gameObjects/projectiles/bullet.rb"

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

    @player = Player.new(Vector[120, 120], "gamescene")

    @dialogues = []
    @objects = Hash.new
    @objects["player"] = []
    @objects["enemies"] = []
    @objects["obstacles"] = []
    @objects["interactables"] = []
    @objects["projectiles"] = []
    # first we always need walls to prevent character from walking outside of real bg
    bg_width = @bg.width
    bg_height = @bg.height
    wall_thickness = 10
    # @objects["obstacles"].push(Wall.new(0, bg_height / 2, wall_thickness / 2, bg_height))
    # @objects["obstacles"].push(Wall.new(bg_width / 2, 0, bg_width, wall_thickness / 2))
    # @objects["obstacles"].push(Wall.new(bg_width, bg_height / 2, wall_thickness / 2, bg_height))
    # @objects["obstacles"].push(Wall.new(bg_width / 2, bg_height, bg_width, wall_thickness / 2))
    @objects["obstacles"].push(Wall.new(0, 0, -wall_thickness, bg_height))
    @objects["obstacles"].push(Wall.new(0, 0, bg_width, -wall_thickness))
    @objects["obstacles"].push(Wall.new(bg_width, 0, wall_thickness, bg_height))
    @objects["obstacles"].push(Wall.new(0, bg_height, bg_width, wall_thickness))
  end

  def unload
    super
    @quadtree = nil
  end

  def update(mouse_x, mouse_y)
    @camera.update(@player.center, Vector[@bg.width / 2, @bg.height / 2])
    @transform = @camera.transform
    #can we handle all of this in maybe a player update method?
    @player.state = 0
    # WARNING: technically we don't want to allow them to use both. If they are holding left and D at the same time,
    # we don't want one to cancel out the other.
    if Gosu.button_down? Gosu::KB_A or Gosu.button_down? Gosu::KB_LEFT
      @player.go_left
      @player.state = 1
      # @player.flip = 1
      @player.facing = 2
    end
    if Gosu.button_down? Gosu::KB_D or Gosu.button_down? Gosu::KB_RIGHT
      @player.go_right
      @player.state = 1
      # @player.flip = 0
      @player.facing = 0
    end
    if Gosu.button_down? Gosu::KB_W or Gosu.button_down? Gosu::KB_UP
      @player.go_up
      @player.state = 1
      @player.facing = 1
    end
    if Gosu.button_down? Gosu::KB_S or Gosu.button_down? Gosu::KB_DOWN
      @player.go_down
      @player.state = 1
      @player.facing = 3
    end
    # NOTE: must make state transitions more clear, rewrite whole thing
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

    # collision detection
    # @quadtree.clear
    # for i in 0..@allObjects.length - 1
    #   if (!@allObjects[i].nil?)
    #     @quadtree.insert(@allObjects[i])
    #   end
    # end

    # update transforms for each object

    @objects.each_value do |objectList|
      for i in 0..objectList.length - 1
        objectList[i].transform = @transform
        if (objectList[i].is_a?(Enemy))
          objectList[i].update(@player.center, @player.velocity)
        else
          objectList[i].update
        end
      end
    end

    @objects.each_value do |objectList|
      for i in 0..objectList.length - 1
        #now check collisions
        @objects.each_value do |objectList2|
          for j in 0..objectList2.length - 1
            obj1 = objectList[i]
            obj2 = objectList2[j]
            if obj1 == obj2
              break
            end
            overlap(obj1, obj2)
          end
        end
      end
    end

    for dialogue in @dialogues
      dialogue.update
    end
    # for i in 0..@objects.length - 1
    #   if (!@objects[i].nil?)
    #     for x in 0..@objects.length - 1
    #       # run collision detection algorithm between @allObjects[i] and returnObjects[x]
    #       obj1 = @allObjects[i]
    #       obj2 = @allObjects[x]
    #       if obj1 == obj2
    #         break
    #       end
    #       overlap(obj1, obj2)
    #     end
    #   end
    # end
    # for enemy in @enemies
    #   enemy.transform = @transform
    # end
    # for obstacle in @obstacles
    #   obstacle.transform = @transform
    # end
    # for projectile in @projectiles
    #   projectile.transform = @transform
    # end
    # @player.transform = @transform

    # for enemy in @enemies
    #   enemy.update(@player.center, @player.velocity)
    # end
    # for obstacle in @obstacles
    #   obstacle.update
    # end
    # for projectile in @projectiles
    #   projectile.update
    # end
    # @player.update

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
    # for i in 0..@allObjects.length - 1
    #   if (!@allObjects[i].nil?)
    #     for x in 0..@allObjects.length - 1
    #       # run collision detection algorithm between @allObjects[i] and returnObjects[x]
    #       obj1 = @allObjects[i]
    #       obj2 = @allObjects[x]
    #       if obj1 == obj2
    #         break
    #       end
    #       overlap(obj1, obj2)
    #     end
    #   end
    # end

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

    @objects.each_value do |objectList|
      for object in objectList
        object.draw
        object.draw_frame
      end
    end
    for dialogue in @dialogues
      dialogue.draw
    end
    # @player.draw
    # @player.draw_frame
    # for enemy in @enemies
    #   enemy.draw
    #   enemy.draw_frame
    # end
    # for obstacle in @obstacles
    #   obstacle.draw
    #   obstacle.draw_frame
    # end
    # for projectile in @projectiles
    #   # projectile.draw
    #   projectile.draw_frame
    # end

    @crosshair.draw
  end

  def button_down(id, close_callback)
    case id
    when Gosu::KB_T
      @dialogues.push(DialogueBubble.new(@player, "Thinking"))
      # do something with DialogueBubble.new(@player,"Thinking")
    when Gosu::MS_LEFT
      old_pos = @transform.inverse * Vector[@crosshair.x, @crosshair.y, 1]
      bullet = Bullet.new(@player.center, (Vector[old_pos[0], old_pos[1]] - @player.center).normalize * 10)
      @objects["projectiles"].push(bullet)
    end
  end
end

def overlap(obj1, obj2)
  mtv = Hash.new
  mtvHit = findOverlap(obj1.boundPolys["hit"], obj2.boundPolys["hit"])
  if (mtvHit)
    #call overlap on both objects if they overlap?
    #so they can handle it themselves?

    obj1.overlap(obj2, "hit", mtvHit.v)
    # obj2.overlap(obj1, "hit", mtvHit.v)
    mtv["hit"] = mtvHit
  end
  mtvWalk = findOverlap(obj1.boundPolys["walk"], obj2.boundPolys["walk"])
  if (mtvWalk)
    obj1.overlap(obj2, "walk", mtvWalk.v)
    # obj2.overlap(obj1, "walk", mtvWalk.v)
    mtv["walk"] = mtvWalk
  end

  return mtv
end
