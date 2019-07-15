require "gosu"
require_relative "../../collision.rb"
require_relative "../gameObject.rb"

class Obstacle < GameObject
  def draw
    draw_frame
  end
end
