require "json"
require_relative "../rectangle.rb"
require_relative "../constants"
require_relative "./gameObject.rb"
require_relative "../animation.rb"
require_relative "../sceneManager.rb"
require_relative "./weapons/weapon.rb"

ARM_RIGHT_ANCHOR = Vector[0.125, 0.45]
ARM_LEFT_ANCHOR = Vector[0.9, 0.5]
ARM_UP_ANCHOR = Vector[0.5, 0.9]
ARM_DOWN_ANCHOR = Vector[0.55, 0.125]
ARM_RIGHT_TRANSF = Vector[64 - 72, 38 - 64]
ARM_LEFT_TRANSF = Vector[53 - 64, 42 - 64]
ARM_UP_TRANSF = Vector[76 - 64, 36 - 64]
ARM_DOWN_TRANSF = Vector[48 - 64, 34 - 64]

class Player < GameObject
  attr_reader :currentWeapon
  attr_accessor :state
  # attr_accessor :flip
  attr_accessor :armangle
  attr_accessor :facing
  attr_accessor :maxSpeed

  def initialize(sceneref, center = Vector[0, 0], sceneType = "gamescene", primary = "./weapons.json")
    super sceneref, center
    @width = 128
    @height = 128

    @id = "player"

    # @boundPoly = Rectangle.new(@x, @y, @width, @height)
    hitPoly = BoundingPolygon.new(self, Vector[0, 6], 24, 78)
    walkPoly = BoundingPolygon.new(self, Vector[0, 42], 32, 12)

    @boundPolys["hit"] = hitPoly
    @boundPolys["walk"] = walkPoly

    instantiateAnimations(sceneType)

    @armleft = Gosu::Image.new("img/scia/armleft.bmp")
    @armright = Gosu::Image.new("img/scia/armright.bmp")
    @armup = Gosu::Image.new("img/scia/armup.bmp")
    @armdown = Gosu::Image.new("img/scia/armdown.bmp")
    @armangle = 0
    @armpos = ARM_RIGHT_TRANSF
    @armanchor = ARM_RIGHT_ANCHOR

    @shadow = Gosu::Image.new("img/scia/scia_shadow.bmp", :retro => true)

    @z = PLAYER_LAYER

    @state = 0 # 0 for idle, 1 for walking, 2 for shooting (tentative)
    # @flip = 0 # 0 for facing right, 1 for facing left
    @facing = 0 # 0 for right, 1 for up, 2 for left, 3 for down
    @curr_anim = @idle_right
    @arm = nil

    #physics stuff
    @maxSpeed = 3
    #weapon stuff
    @primaryWeapon = Weapon.new("Pistol") #id of primary weapon
    @secondaryWeapon = Weapon.new("Knife") #id of secondary weapon
    @currentWeapon = @primaryWeapon
  end

  def switchWeapons
    currentWeapon = @currentWeapon.equal?(@primaryWeapon) ? @secondaryWeapon : @primaryWeapon
  end

  def instantiateAnimations(sceneType)
    file = File.read("gameObjects/playerAnims.json")
    data_hash = JSON.parse(file)

    @idle_up = Animation.new(data_hash[sceneType]["idle"]["up"], @width, @height, retro: true)
    @idle_right = Animation.new(data_hash[sceneType]["idle"]["right"], @width, @height, retro: true)
    @idle_left = Animation.new(data_hash[sceneType]["idle"]["left"], @width, @height, retro: true)
    @idle_down = Animation.new(data_hash[sceneType]["idle"]["down"], @width, @height, retro: true)

    @walking_up = Animation.new(data_hash[sceneType]["walking"]["up"], @width, @height, retro: true)
    @walking_right = Animation.new(data_hash[sceneType]["walking"]["right"], @width, @height, retro: true)
    @walking_left = Animation.new(data_hash[sceneType]["walking"]["left"], @width, @height, retro: true)
    @walking_down = Animation.new(data_hash[sceneType]["walking"]["down"], @width, @height, retro: true)

    if (data_hash[sceneType]["shoot"])
      @shoot_right = Animation.new(data_hash[sceneType]["shoot"]["right"], @width, @height)
      @shoot_left = Animation.new(data_hash[sceneType]["shoot"]["left"], @width, @height)
      @shoot_up = Animation.new(data_hash[sceneType]["shoot"]["up"], @width, @height)
      @shoot_down = Animation.new(data_hash[sceneType]["shoot"]["down"], @width, @height)
    end
  end

  def go_up
    if (@velocity[1] - 2 > -@maxSpeed)
      @velocity[1] -= 2
    end
  end

  def go_down
    if (@velocity[1] + 2 < @maxSpeed)
      @velocity[1] += 2
    end
  end

  def go_left
    if (@velocity[0] - 2 > -@maxSpeed)
      @velocity[0] -= 2
    end
  end

  def go_right
    if (@velocity[0] + 2 < @maxSpeed)
      @velocity[0] += 2
    end
  end

  def update
    @center = @center + @velocity
    if (@state != 1) # need more states to distinguish horizontal from vertical movement
      @velocity = @velocity * 0.8
    end
    @boundPolys.each_value do |value|
      value.update
    end

    case @state
    when 0
      case @facing
      when 0
        @curr_anim = @idle_right
      when 1
        @curr_anim = @idle_up
      when 2
        @curr_anim = @idle_left
      when 3
        @curr_anim = @idle_down
      end

      @arm = nil
    when 1
      case @facing
      when 0
        @curr_anim = @walking_right
      when 1
        @curr_anim = @walking_up
      when 2
        @curr_anim = @walking_left
      when 3
        @curr_anim = @walking_down
      end
      @arm = nil
      # @curr_anim.flip = @flip
    when 2
      case @facing
      when 0
        @curr_anim = @shoot_right
        @arm = @armright
        @armanchor = ARM_RIGHT_ANCHOR
        @arm_transform = ARM_RIGHT_TRANSF
      when 1
        @curr_anim = @shoot_up
        @arm = @armup
        @armanchor = ARM_UP_ANCHOR
        @arm_transform = ARM_UP_TRANSF
        @armangle += 90
      when 2
        @curr_anim = @shoot_left
        @arm = @armleft
        @armanchor = ARM_LEFT_ANCHOR
        @arm_transform = ARM_LEFT_TRANSF
        @armangle += 180
      when 3
        @curr_anim = @shoot_down
        @arm = @armdown
        @armanchor = ARM_DOWN_ANCHOR
        @arm_transform = ARM_DOWN_TRANSF
        @armangle += 270
      end
    else
      @curr_anim = @idle_anim
      @arm = nil
      # @curr_anim.flip = @flip
    end

    @curr_anim.update
  end

  def draw(translate, scale)
    # note: in the future, make things more consistent so we don't have to recalculate this and can just call super
    pos = @center * scale + translate
    x = pos[0]
    y = pos[1]
    w = @width * scale
    h = @height * scale

    color = OPAQUE
    shadowColor = SHADOW_COLOR
    @shadow.draw_as_quad(x - w / 2, y - h / 2, shadowColor, x + w / 2, y - h / 2, shadowColor, x + w / 2, y + h / 2, shadowColor, x - w / 2, y + h / 2, shadowColor, SHADOW_LAYER)
    @curr_anim.draw_as_quad(x - w / 2, y - h / 2, color, x + w / 2, y - h / 2, color, x + w / 2, y + h / 2, color, x - w / 2, y + h / 2, color, @z)

    # TODO: arm logic
    # armpos = pos + @armpos

    # if (!@arm.nil?)
    #   @arm.draw_rot(armpos[0], armpos[1], 1, @armangle, @armanchor[0], @armanchor[1], PLAYER_ARM_LAYER)
    # end
  end

  def overlap(obj2, poly, overlap = Vector[0, 0])
    case poly
    when "hit"
      if (obj2.is_a?(Enemy))
        boundPolys["hit"].color = Gosu::Color::RED
        # replace with a "restartScene" call
        # SceneManager.restartScene
        # go_to(Vector[50, 50])
        SceneManager.restartScene
      end
    when "walk"
      if (obj2.is_a?(FixedObject) && !obj2.through)
        #first handle the case where the objects are only touching edges
        if (overlap[0] == 0)
          if (obj2.center[0] > @center[0])
            # puts("touch right")
            @velocity[0] = @velocity[0] > 0 ? 0 : @velocity[0]
          else
            # puts("touch left")
            @velocity[0] = @velocity[0] < 0 ? 0 : @velocity[0]
          end
        elsif (overlap[1] == 0)
          if (obj2.center[1] > @center[1])
            # puts("touch down")
            @velocity[1] = @velocity[1] > 0 ? 0 : @velocity[1]
          else
            # puts("touch up")
            @velocity[1] = @velocity[1] < 0 ? 0 : @velocity[1]
          end
        elsif (overlap[0]).abs <= (overlap[1]).abs
          @center[0] += overlap[0]
          if (overlap[0] < 0)
            # puts("overlap right")
            @velocity[0] = @velocity[0] > 0 ? 0 : @velocity[0]
          else
            # puts("overlap left")
            @velocity[0] = @velocity[0] < 0 ? 0 : @velocity[0]
          end
        else
          # puts(overlap)
          @center[1] += overlap[1]
          if (overlap[1] < 0)
            # puts("overlap down")
            @velocity[1] = @velocity[1] > 0 ? 0 : @velocity[1]
          else
            # puts("overlap up")
            @velocity[1] = @velocity[1] < 0 ? 0 : @velocity[1]
          end
        end
      end
    when "walkhit"
      # check when hitting hit poly
      if (obj2.is_a?(FixedObject))
        obj2.z = ABOVE_PLAYER
      else
        obj2.z = BELOW_PLAYER
      end
    end
  end
end
