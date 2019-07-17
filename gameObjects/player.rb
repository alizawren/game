require_relative "../rectangle.rb"
require_relative "../constants"
require_relative "./gameObject.rb"
require_relative "../animation.rb"
require_relative "../sceneManager.rb"

MAX_SPEED = 5

class Player < GameObject
  attr_accessor :state
  attr_accessor :flip
  attr_accessor :armangle

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
    @shoot_anim = Animation.new("img/scia/shootright.png", @width, @height)

    @armleft = Gosu::Image.new("img/scia/armleft.bmp")
    @armright = Gosu::Image.new("img/scia/armright.bmp")
    @armup = Gosu::Image.new("img/scia/armup.bmp")
    @armdown = Gosu::Image.new("img/scia/armdown.bmp")
    @armangle = 0
    @arm_transform = Matrix[[1, 0, (64 - 72) * 0.8], [0, 1, (38 - 64) * 0.8], [0, 0, 1]]

    @state = 0 # 0 for idle, 1 for walking, 2 for shooting (tentative)
    @flip = 0 # 0 for facing right, 1 for facing left
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

    # issue with this: if you are turning from left to right, vel MUST be 0 at some point (Mean Value Theorem) but we don't want to
    # be standing suddenly. Instead, look into state machines
    # if (@velocity[0].abs < 1.0 && @velocity[1].abs < 1.0)
    #   @state = 0
    # else
    #   @state = 1
    # end

    case @state
    when 0
      @curr_anim = @idle_anim
      @arm = nil
    when 1
      @curr_anim = @walking_anim
      @arm = nil
    when 2
      @curr_anim = @shoot_anim
      @arm = @armright
    else
      @curr_anim = @idle_anim
    end
    @curr_anim.flip = @flip

    @curr_anim.update
  end

  def draw
    # note: in the future, make things more consistent so we don't have to recalculate this and can just call super
    curr = Vector[@center[0], @center[1], 1]
    newpos = @transform * curr

    armpos = @arm_transform * @transform * curr

    @curr_anim.draw(newpos[0] - @width / 2, newpos[1] - @height / 2, 1)
    if (!@arm.nil?)
      @arm.draw_rot(armpos[0], armpos[1], 1, @armangle - 90, 0.125, 0.45)
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
        force(-mtv)
      end
    end
  end
end
