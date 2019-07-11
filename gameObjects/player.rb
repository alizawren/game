require_relative "../rectangle.rb"
require_relative "../constants"
require_relative "./gameObject.rb"

MAX_SPEED = 5

class Player < GameObject
  def initialize
    super
    @color = Gosu::Color::WHITE
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
  end

  def move
    super

    @vel_x *= 0.8
    @vel_y *= 0.8
  end

  def draw
    super
  end
end
