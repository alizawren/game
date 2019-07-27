require_relative "./scene.rb"
require_relative "./guis/pauseMenuGui.rb"
require_relative "./dialogue/dialogue.rb"
require_relative "./dialogue/dialogueOptions.rb"

class GameScene < Scene
  attr_accessor :parallax

  def load
    @mouse_x = 0
    @mouse_y = 0
    @transform = Matrix.I(3)

    @camera = Camera.new

    @quadtree = Quadtree.new(0, Rectangle.new(0, 0, CANVAS_WIDTH, CANVAS_HEIGHT))

    @parallax = Gosu::Image.new("img/space.png", :tileable => true)
    @bg = Gosu::Image.new("img/tempbg.png", :tileable => true)

    @crosshair = Crosshair.instance

    @player = Player.new(Vector[120, 120])

    @objects = Hash.new
    @objects["player"] = []
    @objects["obstacles"] = []
    @objects["interactables"] = []
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
    @mouse_x = mouse_x
    @mouse_y = mouse_y

    @camera.update(@player.center, Vector[@bg.width / 2, @bg.height / 2])
    @transform = @camera.transform
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

    @crosshair.draw
  end

  def button_down(id, close_callback)
    case id
    when Gosu::KB_T
      #set player dialogue to a new bubble
      @player.dialogue = Dialogue.new("wassup")
    when Gosu::MS_LEFT
      # instead of shooting bullets, check if it's clicking on an interactable
      if (@mouse_x.nil? or @mouse_y.nil?)
        return
      end
      for interactable in @objects["interactables"]
        if interactable.contains(@mouse_x, @mouse_y)
          interactable.activate
        end
      end
      #when are we gonna shoot bullets?
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
