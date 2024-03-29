require "json"
require_relative "../functions.rb"
require_relative "./scene.rb"
require_relative "./guis/pauseMenuGui.rb"
require_relative "../handlers/eventHandler.rb"
require_relative "../camera.rb"
require_relative "../crosshair.rb"
require_relative "../gameObjects/player.rb"
require_relative "../gameObjects/enemy.rb"
require_relative "../gameObjects/obstacles/obstacle.rb"
require_relative "../gameObjects/fixedObject.rb"
require_relative "../gameObjects/floatObject.rb"

class GameScene < Scene
  attr_accessor :parallax
  attr_accessor :eventHandler
  attr_reader :objects
  attr_reader :player
  attr_reader :mouse_x
  attr_reader :mouse_y
  attr_accessor :camera
  attr_accessor :dialogueMode
<<<<<<< HEAD
  attr_accessor :hitscans
=======
  attr_accessor :guiMode
>>>>>>> b42862fd7481ee1374432e08a64ba57a3fd9ccff

  def initialize(jsonfile = "scenes/scenefiles/defaultScene.json")
    SceneManager.clear

    @mouse_x = 0
    @mouse_y = 0

    @crosshair = Crosshair.instance
    @eventHandler = EventHandler.new(self)
    @eventHandler.addHandler("dialogue")
    @eventHandler.addHandler("camera")
    @eventHandler.addHandler("gui")
    @dialogueMode = false

    @objects = Hash.new

    file = File.read(jsonfile)
    data = JSON.parse(file)

    @type = data["type"]

    @parallax = Gosu::Image.new(data["parallax"], :tileable => true, :retro => true)
    @bg = Gosu::Image.new(data["bg"], :tileable => false, :retro => true)

    @hitscans = []
    @objects["player"] = []
    @objects["fixed"] = []
    if (@type == "gamescene")
      @objects["enemies"] = []
      # @objects["projectiles"] = []
    end
    @player = Player.new(self, Vector[data["player"]["x"], data["player"]["y"]], @type)
    @objects["player"].push(@player)

    scale = !data["scale"].nil? ? data["scale"] : 2
    @camera = Camera.new(scale, @player.center)

    addObjects(data)
    addWalls
  end

  def addObjects(data)
    # get objects
    if (!data["objects"].nil?)
      # get each key (obstacles, fixed, etc)
      keys = data["objects"].keys
      for key in keys
        # add key to dictionary
        @objects[key] = []
        # for each object, construct object and add to list of objects
        for val in data["objects"][key]
          obj = nil

          case val["type"]
          when "fixed"
            w = val["width"]
            h = val["height"]
            if (val["width"] == "bgwidth")
              w = @bg.width
            end
            if (val["height"] == "bgheight")
              h = @bg.height
            end

            through = val["through"]
            method = ""
            if val["method"]
              method = val["method"]
            end

            id = ""
            if val["id"]
              id = val["id"]
            end
            imgsrc = nil
            if val["imgsrc"]
              imgsrc = val["imgsrc"]
            end

            obj = FixedObject.new(self, val["x"], val["y"], w, h, imgsrc, id, method, through)
          when "float"
            w = val["width"]
            h = val["height"]
            if (val["width"] == "bgwidth")
              w = @bg.width
            end
            if (val["height"] == "bgheight")
              h = @bg.height
            end

            through = val["through"]
            method = ""
            if val["method"]
              method = val["method"]
            end

            id = ""
            if val["id"]
              id = val["id"]
            end
            imgsrc = nil
            if val["imgsrc"]
              imgsrc = val["imgsrc"]
            end

            obj = FloatObject.new(self, val["x"], val["y"], w, h, imgsrc, id, method, through)
          when "polygon"
            if (val["x"].nil? or val["y"].nil? or val["vertices"].nil?)
              next
            end
            vertices = val["vertices"]
            if (vertices.empty?)
              next
            end
            newverts = []
            for vertex in vertices
              newverts.push(Vector[vertex["x"], vertex["y"]])
            end
            # obj = Obstacle.new(Vector[val["x"], val["y"]], newverts)
          when "enemy"
            path = val["path"]
            newpath = []
            for node in path
              newpath.push(Vector[node["x"], node["y"]])
            end
            obj = Enemy.new(self, newpath)
          else
          end

          if (!obj.nil? and !val["boundPolys"].nil?)
            val["boundPolys"].each do |poly, info|
              polyCenter = Vector[info["x"], info["y"]]
              polyWidth = info["width"]
              polyHeight = info["height"]
              boundPoly = BoundingPolygon.new(obj, polyCenter, polyWidth, polyHeight)
              obj.boundPolys[poly] = boundPoly
            end
          end

          if (!obj.nil? and !val["img"].nil?)
            obj.image = Gosu::Image.new(val["img"])
          end

          if (!obj.nil?)
            @objects[key].push(obj)
          end
        end
      end
    end
  end

  def addWalls
    # first we always need walls to prevent character from walking outside of real bg
    bg_width = @bg.width
    bg_height = @bg.height
    wall_thickness = 10
    @objects["fixed"].push(FixedObject.new(self, 0, 0, -wall_thickness, bg_height))
    @objects["fixed"].push(FixedObject.new(self, 0, 0, bg_width, -wall_thickness))
    @objects["fixed"].push(FixedObject.new(self, bg_width, 0, wall_thickness, bg_height))
    @objects["fixed"].push(FixedObject.new(self, 0, bg_height, bg_width, wall_thickness))
  end

  def update(mouse_x, mouse_y)
    super
    @mouse_x = mouse_x
    @mouse_y = mouse_y

    @player.state = 0

    processInput

    # update each object
    @objects.each_value do |objectList|
      for object in objectList
        if !object.nil?
          if (object.is_a?(Enemy))
            object.update(@player.center, @player.velocity)
          else
            object.update
          end
        end
      end
    end

    @objects.each_value do |objectList|
      for obj1 in objectList
        #now check collisions
        @objects.each_value do |objectList2|
          for obj2 in objectList2
            if obj1 == obj2
              break
            end
            overlap(obj1, obj2)
          end
        end
      end
    end

    @eventHandler.update()

    @crosshair.update(@mouse_x, @mouse_y) # might move this location

    @camera.setPos(@player.center, Vector[@mouse_x, @mouse_y])
    @camera.update(@player.center, Vector[@mouse_x, @mouse_y])
  end

  def processInput
    # WARNING: technically we don't want to allow them to use both. If they are holding left and D at the same time,
    # we don't want one to cancel out the other.
    if Gosu.button_down? Gosu::KB_A or Gosu.button_down? Gosu::KB_LEFT
      @player.go_left
      @player.state = 1 # need more states to distinguish horizontal from vertical movement
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

    if (@type == "gamescene")
      # if Gosu.button_down? Gosu::MS_LEFT
      #   # angle logic in here
      #   invtransf = @cameratransform.inverse
      #   hom = Vector[@player.center[0], @player.center[1], 1]
      #   pcenter = @cameratransform * hom
      #   angle = Gosu.angle(pcenter[0], pcenter[1], mouse_x, mouse_y) - 90
      #   @player.armangle = angle
      #   case angle
      #   when -45..45
      #     # right
      #     @player.facing = 0
      #   when 45..135
      #     # down
      #     @player.facing = 3
      #   when 135..225
      #     # left
      #     @player.facing = 2
      #   else
      #     # up
      #     @player.facing = 1
      #   end
      #   @player.state = 2
      # end
    end
    # NOTE: must make state transitions more clear, rewrite whole thing
  end

  def draw
    cameraInvert = -@camera.pos # get camera's coordinates and invert them

    # bg drawn at world's 0,0
    @parallax.draw(0, 0, PARALLAX_LAYER)
    x1 = cameraInvert[0]
    y1 = cameraInvert[1]
    x2 = x1 + @camera.scale * @bg.width
    y2 = y1 + @camera.scale * @bg.height
    white = Gosu::Color::WHITE
    # @bg.draw(cameraInvert[0], cameraInvert[1], BG_LAYER, @camera.scale, @camera.scale)
    @bg.draw_as_quad(x1, y1, white, x2, y1, white, x2, y2, white, x1, y2, white, BG_LAYER)

    # calculate each object's true position and draw it.
    @objects.each_value do |objectList|
      for object in objectList
        object.draw(cameraInvert, @camera.scale)
        # object.draw_frame(cameraInvert, @camera.scale)
      end
    end
    for hit in @hitscans
<<<<<<< HEAD
      p1 = @camera.transform * Vector[hit[0][0], hit[0][1], 1]
      p2 = @camera.transform * Vector[hit[1][0], hit[1][1], 1]
=======
      p1 = Vector[hit[0][0], hit[0][1]] * @camera.scale + cameraInvert
      p2 = Vector[hit[1][0], hit[1][1]] * @camera.scale + cameraInvert
>>>>>>> b42862fd7481ee1374432e08a64ba57a3fd9ccff
      Gosu.draw_line(p1[0], p1[1], Gosu::Color::WHITE, p2[0], p2[1], Gosu::Color::WHITE, 99)
      Gosu.draw_rect(p2[0], p2[1], 5, 5, Gosu::Color::RED, 98)
    end
    # @hitscans = []
    @eventHandler.draw

    @crosshair.draw
  end

  def button_down(id, close_callback)
    case id
    when Gosu::KB_E
      @player.switchWeapons
    when Gosu::KB_LEFT_SHIFT
      if (@type == "gamescene")
        #change the state to sprint
        @player.maxSpeed = 10
      end
    when Gosu::MS_LEFT
      # instead of shooting bullets, check if it's clicking on an interactable
      if (@mouse_x.nil? or @mouse_y.nil?)
        return
      end

      cameraInvert = -@camera.pos # get camera's coordinates and invert them
      mouse_world = (Vector[@mouse_x, @mouse_y] - cameraInvert) / @camera.scale

      @eventHandler.button_down(id, close_callback)

      if @dialogueMode
        return
      end
      # TODO: Ideally we don't want to loop over ALL the fixed objects and check if the player wants to interact with it
      # separate fixed from fixed interactables? Add some flag so at least they don't perform contains calculations?
      # (note: inverse matrix calculations are particularly expensive)
      for interactable in @objects["fixed"]
        if interactable.contains(mouse_world[0], mouse_world[1])
          interactable.activate
          return
        end
      end

      if (@type == "gamescene")
        case @player.currentWeapon.type
        when "ranged"
<<<<<<< HEAD
          target3 = @camera.transform.inverse * Vector[@crosshair.x, @crosshair.y, 1]
          target = Vector[target3[0], target3[1]]
          collisionPoint = hitscan(@player.center, target, [@player])
          if (!collisionPoint.nil?)
            @hitscans.push([@player.center, collisionPoint])
          else
            p2 = ((target - @player.center).normalize() * @player.currentWeapon.range)
=======
          # oldpos = @camera.transform.inverse * Vector[@crosshair.x, @crosshair.y, 1]
          # projectile = Projectile.new(self, @player.currentWeapon.projectile,@player.center, (Vector[oldpos[0], oldpos[1]] - @player.center).normalize * BULLET_SPEED)
          # @objects["projectiles"].push(projectile)

          #moving on from projectiles
          collisionPoint = @player.currentWeapon.hitscan(@player.center, mouse_world, @objects, [@player])
          if (!collisionPoint.nil?)
            @hitscans.push([@player.center, collisionPoint])
          else
            p2 = ((mouse_world - @player.center).normalize() * @player.currentWeapon.range)
>>>>>>> b42862fd7481ee1374432e08a64ba57a3fd9ccff
            @hitscans.push([@player.center, p2])
          end
        when "melee"
          #somehow handle melee attacks :P
        end
      end
    end
  end

  def deleteObject(objid)
    @objects.each_value do |objectList|
      objectList.each_index do |i|
        if objectList[i].object_id == objid
          objectList.delete_at(i)
          return
        end
      end
    end
  end

  def hitscan(source, target, ignore = [])
    p1 = source

    hit = ((target - p1).normalize() * @range)
    p2 = Vector[hit[0] + p1[0], hit[1] + p1[1]]
    cp = []
    @objects.each_value do |objectType|
      objectType.each do |obj|
        if !ignore.include?(obj)
          poly = obj.boundPolys["hit"]
          if (!poly.nil?)
            collisionPoint = lineRectCollision(p1, p2, poly.topleft, poly.topright, poly.bottomright, poly.bottomleft)
            if !collisionPoint.nil?
              cp.push(collisionPoint)

              # obj.overlap("Bullet","hit")
              # return(collisionPoint)
            end
          end
        end
      end
    end
    closest = cp[0]
    for point in cp
      if (point - p1).magnitude < (closest - p1).magnitude
        closest = point
      end
    end
    return(closest)
  end
end

def lineRectCollision(l1, l2, r1, r2, r3, r4)
  cp1 = lineLineCollision(l1, l2, r1, r2)
  cp2 = lineLineCollision(l1, l2, r2, r3)
  cp3 = lineLineCollision(l1, l2, r3, r4)
  cp4 = lineLineCollision(l1, l2, r4, r1)
  cp = []
  if (!cp1.nil?)
    cp.push(cp1)
  end
  if (!cp2.nil?)
    cp.push(cp2)
  end
  if (!cp3.nil?)
    cp.push(cp3)
  end
  if (!cp4.nil?)
    cp.push(cp4)
  end
  if cp.length == 0
    return
  end
  closest = cp[0]
  for point in cp
    if (point - l1).magnitude < (closest - l1).magnitude
      closest = point
    end
  end
  return(closest)
end

def lineLineCollision(p1, p2, p3, p4)
  den = (p4[1] - p3[1]) * (p2[0] - p1[0]) - (p4[0] - p3[0]) * (p2[1] - p1[1])
  num1 = (p4[0] - p3[0]) * (p1[1] - p3[1]) - (p4[1] - p3[1]) * (p1[0] - p3[0])
  num2 = (p2[0] - p1[0]) * (p1[1] - p3[1]) - (p2[1] - p1[1]) * (p1[0] - p3[0])
  if (den == 0)
    if (num1 == 0 && num2 == 0)
      return(p2)
    end
  else
    uA = num1 / den
    uB = num2 / den
    if (uA >= 0 && uA <= 1 && uB >= 0 && uB <= 1)
      return(Vector[p1[0] + (uA * (p2[0] - p1[0])), p1[1] + (uA * (p2[1] - p1[1]))])
    end
  end
end

def overlap(obj1, obj2)
  overlap = Hash.new
  overlapHit = findOverlap(obj1.boundPolys["hit"], obj2.boundPolys["hit"])
  if (overlapHit)
    #call overlap on both objects if they overlap?
    #so they can handle it themselves?
    obj1.overlap(obj2, "hit", overlapHit)
    # obj2.overlap(obj1, "hit", mtvHit.v)
    overlap["hit"] = overlapHit
  end
  overlapWalk = findOverlap(obj1.boundPolys["walk"], obj2.boundPolys["walk"])
  if (overlapWalk)
    obj1.overlap(obj2, "walk", overlapWalk)
    # obj2.overlap(obj1, "walk", mtvWalk.v)
    overlap["walk"] = overlapWalk
  end

  overlapWalkHit = findOverlap(obj1.boundPolys["walk"], obj2.boundPolys["hit"])
  if (overlapWalkHit)
    obj1.overlap(obj2, "walkhit", overlapWalkHit)
    overlap["walkhit"] = overlapWalkHit
  end

  return overlap
end
