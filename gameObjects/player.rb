require_relative "../rectangle.rb"
require_relative "../constants"
require_relative "./gameObject.rb"
require_relative "../animation.rb"

MAX_SPEED = 5

class Player < GameObject
  attr_accessor :state
  attr_accessor :flip

  def initialize(center)
    super
    @color = Gosu::Color::WHITE
    @width = 128 * 0.8
    @height = 128 * 0.8

    # @boundPoly = Rectangle.new(@x, @y, @width, @height)
    @hitPoly = BoundingPolygon.new(self, [Vector[-@width / 2, -@height / 2], Vector[@width / 2, -@height / 2], Vector[@width / 2, @height / 2], Vector[-@width / 2, @height / 2]])

    @idle_anim = Animation.new("img/scia/idle.png", @width, @height)
    @walking_anim = Animation.new("img/scia/walking.png", @width, @height)

    @state = 0 # 0 for idle, 1 for walking
    @flip = 0 # 0 for facing right, 1 for facing left
    @curr_anim = @idle_anim
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
    @hitPoly.update

    # issue with this: if you are turning from left to right, vel MUST be 0 at some point (Mean Value Theorem) but we don't want to
    # be standing suddenly. Instead, look into state machines
    if (@velocity[0].abs < 1.0 && @velocity[1].abs < 1.0)
      @state = 0
    else
      @state = 1
    end

    case @state
    when 0
      @curr_anim = @idle_anim
    when 1
      @curr_anim = @walking_anim
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
    x = newpos[0]
    y = newpos[1]

    @curr_anim.draw(x - @width / 2, y - @height / 2)
  end

  def overlap(obj2, mtv = Vector[0, 0])
    if (obj2.is_a?(Enemy))
      # replace with a "restartScene" call
      # SceneManager.restartScene
      go_to(Vector[50, 50])
    end
    if (obj2.is_a?(Obstacle))
      force(-mtv)
    end
  end
end
