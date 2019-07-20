require_relative "../rectangle.rb"
require_relative "../constants"
require_relative "./gameObject.rb"
require_relative "../animation.rb"
require_relative "../sceneManager.rb"

MAX_SPEED = 5
ARM_RIGHT_ANCHOR = Vector[0.125, 0.45]
ARM_LEFT_ANCHOR = Vector[0.9, 0.5]
ARM_UP_ANCHOR = Vector[0.5, 0.9]
ARM_DOWN_ANCHOR = Vector[0.55, 0.125]
ARM_RIGHT_TRANSF = Matrix[[1, 0, (64 - 72) * 0.8], [0, 1, (38 - 64) * 0.8], [0, 0, 1]]
ARM_LEFT_TRANSF = Matrix[[1, 0, (53 - 64) * 0.8], [0, 1, (42 - 64) * 0.8], [0, 0, 1]]
ARM_UP_TRANSF = Matrix[[1, 0, (76 - 64) * 0.8], [0, 1, (36 - 64) * 0.8], [0, 0, 1]]
ARM_DOWN_TRANSF = Matrix[[1, 0, (48 - 64) * 0.8], [0, 1, (34 - 64) * 0.8], [0, 0, 1]]

class Player < GameObject
  attr_accessor :state
  attr_accessor :flip
  attr_accessor :armangle
  attr_accessor :facing

  def initialize(center)
    super
    @width = 128 * 0.8
    @height = 128 * 0.8

    # @boundPoly = Rectangle.new(@x, @y, @width, @height)
    hitPoly = BoundingPolygon.new(self, [Vector[-@width / 2, -@height / 2], Vector[@width / 2, -@height / 2], Vector[@width / 2, @height / 2], Vector[-@width / 2, @height / 2]])
    walkPoly = BoundingPolygon.new(self, [Vector[-@width / 4, @height / 4], Vector[@width / 4, @height / 4], Vector[@width / 4, @height / 2], Vector[-@width / 4, @height / 2]])
    @boundPolys["hit"] = hitPoly
    @boundPolys["walk"] = walkPoly

    @idle_anim = Animation.new("img/scia/idle.png", @width, @height)
    @walking_anim = Animation.new("img/scia/walking.png", @width, @height)
    @shoot_right = Animation.new("img/scia/shootright.png", @width, @height)
    @shoot_left = Animation.new("img/scia/shootleft.png", @width, @height)
    @shoot_up = Animation.new("img/scia/shootup.png", @width, @height)
    @shoot_down = Animation.new("img/scia/shootdown.png", @width, @height)

    @armleft = Gosu::Image.new("img/scia/armleft.bmp")
    @armright = Gosu::Image.new("img/scia/armright.bmp")
    @armup = Gosu::Image.new("img/scia/armup.bmp")
    @armdown = Gosu::Image.new("img/scia/armdown.bmp")
    @armangle = 0
    @arm_transform = ARM_RIGHT_TRANSF
    @armanchor = ARM_RIGHT_ANCHOR

    @state = 0 # 0 for idle, 1 for walking, 2 for shooting (tentative)
    @flip = 0 # 0 for facing right, 1 for facing left
    @facing = 0 # 0 for right, 1 for up, 2 for left, 3 for down
    @curr_anim = @idle_anim
    @arm = nil
  end

  def go_up
    newvel = Vector[@velocity[0], @velocity[1] - 2]
    if (newvel[1] > -MAX_SPEED)
      @velocity = newvel
    end
  end

  def go_down
    newvel = Vector[@velocity[0], @velocity[1] + 2]
    if (newvel[1] < MAX_SPEED)
      @velocity = newvel
    end
  end

  def go_left
    newvel = Vector[@velocity[0] - 2, @velocity[1]]
    if (newvel[0] > -MAX_SPEED)
      @velocity = newvel
    end
  end

  def go_right
    newvel = Vector[@velocity[0] + 2, @velocity[1]]
    if (newvel[0] < MAX_SPEED)
      @velocity = newvel
    end
  end

  def update
    @center = @center + @velocity
    @velocity = @velocity * 0.8
    @boundPolys.each_value do |value|
      value.update
    end

    case @state
    when 0
      @curr_anim = @idle_anim
      @arm = nil
      @curr_anim.flip = @flip
    when 1
      @curr_anim = @walking_anim
      @arm = nil
      @curr_anim.flip = @flip
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
      @curr_anim.flip = @flip
    end

    @curr_anim.update
  end

  def draw
    # note: in the future, make things more consistent so we don't have to recalculate this and can just call super
    curr = Vector[@center[0], @center[1], 1]
    newpos = @transform * curr

    armpos = @arm_transform * @transform * curr

    @curr_anim.draw(newpos[0] - @width / 2, newpos[1] - @height / 2, 1)
    if (!@arm.nil?)
      @arm.draw_rot(armpos[0], armpos[1], 1, @armangle, @armanchor[0], @armanchor[1])
    end
  end

  def overlap(obj2, poly, mtv = Vector[0, 0])
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
      if (obj2.is_a?(Obstacle))
        force(mtv)
      end
    end
  end
end
