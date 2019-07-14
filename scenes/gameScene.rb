require "gosu"
require_relative "../gameObjects/player.rb"
require_relative "../gameObjects/enemy.rb"
require_relative "../gameObjects/obstacles/obstacle.rb"
require_relative "../gameObjects/obstacles/wall.rb"
require_relative "../quadtree.rb"
require_relative "./scene.rb"
require_relative "../constants.rb"

CollisionData = Struct.new(:other, :overlap, :speed1, :speed2, :oldpos1, :oldpos2, :pos1, :pos2) do
end

class GameScene < Scene
  attr_accessor :background_image

  def load
    @quadtree = Quadtree.new(0, Rectangle.new(0, 0, CANVAS_WIDTH, CANVAS_HEIGHT))

    @background_image = Gosu::Image.new("img/space.png", :tileable => true)

    @player = Player.new
    @player.go_to(50, 50)

    @enemies = []

    @obstacles = []
  end

  def unload
    super
    @quadtree = nil
  end

  def update
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

    for enemy in @enemies
      enemy.update(@player.x, @player.y, @player.vel_x, @player.vel_y)
    end
    for obstacle in @obstacles
      obstacle.update
    end
    @player.update

    # collision detection
    @quadtree.clear
    for i in 0..@allObjects.length - 1
      if (!@allObjects[i].nil?)
        @quadtree.insert(@allObjects[i])
      end
    end

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
          if (overlap(obj1, obj2))
            @allObjects[i].color = Gosu::Color::RED
            @allObjects[x].color = Gosu::Color::RED
          end
        end
      end
    end
  end

  def draw
    @background_image.draw(0, 0, 0)
    @player.draw
    @player.bounding.draw_frame
    for enemy in @enemies
      enemy.draw
      enemy.bounding.draw_frame
    end
    for obstacle in @obstacles
      obstacle.draw
      obstacle.bounding.draw_frame
    end
  end
end

def overlap(obj1, obj2)
  mtv = findOverlap(obj1.bounding,obj2.bounding)
  if(mtv)
    #call overlap on both objects if they overlap?
    #so they can handle it themselves?
    obj1.overlap(obj2,mtv.v)
    obj2.overlap(obj1,mtv.v)
    return mtv 
  end
  return false
  # overlap = Vector[0, 0]

  # obj1centerx = obj1.x + (obj1.width / 2.0)
  # obj1centery = obj1.y + (obj1.height / 2.0)
  # obj2centerx = obj2.x + (obj2.width / 2.0)
  # obj2centery = obj2.y + (obj2.height / 2.0)

  # # algorithm for collision of normal rectangles
  # if (obj1.width / 2.0 == 0 || obj1.height / 2.0 == 0 || obj2.width / 2.0 == 0 || obj2.height / 2.0 == 0 \
  #   || (obj1centerx - obj2centerx).abs > obj1.width / 2.0 + obj2.width / 2.0 \
  #   || (obj1centery - obj2centery).abs > obj1.height / 2.0 + obj2.height / 2.0)
  #   return false
  # end

  # overlap = Vector[]
  
  
  # return true
end
