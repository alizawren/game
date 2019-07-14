require_relative "../rectangle.rb"
require_relative "../constants"
require_relative "./gameObject.rb"
require_relative "../animation.rb"

MAX_SPEED = 5

class Player < GameObject
  attr_accessor :state
  attr_accessor :flip

  def initialize
    super
    @color = Gosu::Color::WHITE
    @width = 128 * 0.8
    @height = 128 * 0.8
    @bounding = Rectangle.new(@x, @y, @width, @height)

    @idle_anim = Animation.new("img/scia/idle.png", @x, @y, @width, @height)
    @walking_anim = Animation.new("img/scia/walking.png", @x, @y, @width, @height)

    @state = 0 # 0 for idle, 1 for walking
    @flip = 0 # 0 for facing right, 1 for facing left
    @curr_anim = @idle_anim
  end

  def go_up
    if (@vel_y - 2 > -MAX_SPEED)
      @vel_y -= 2
    end
  end

  def go_down
    if (@vel_y + 2 < MAX_SPEED)
      @vel_y += 2
    end
  end

  def go_left
    if (@vel_x - 2 > -MAX_SPEED)
      @vel_x -= 2
    end
  end

  def go_right
    if (@vel_x + 2 < MAX_SPEED)
      @vel_x += 2
    end
  end

  def update
    super
    # issue with this: if you are turning from left to right, vel MUST be 0 at some point (Mean Value Theorem) but we don't want to
    # be standing suddenly. Instead, look into state machines
    if (@vel_x.abs < 1.0 && @vel_y.abs < 1.0)
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

  def move
    super
    @vel_x *= 0.8
    @vel_y *= 0.8
  end

  def draw
    # note: in the future, make things more consistent so we don't have to recalculate this and can just call super
    curr = Vector[@x, @y, 1]
    newpos = @transform * curr
    x = newpos[0]
    y = newpos[1]

    @curr_anim.draw(x, y)
  end
  def overlap(obj2,mtv=Vector[0,0])
    if(obj2.is_a?(Enemy))
      go_to(50,50)
    end
    if(obj2.is_a?(Obstacle))
      force(-mtv)
    end
  end
end
