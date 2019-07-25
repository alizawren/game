require "gosu"
require_relative "./obstacle.rb"

class Wall < Obstacle
  #walls are just rectangle shaped obstacles
  def initialize(x, y, width = 30, height = 30, color = Gosu::Color::WHITE)
    @center = Vector[x + width / 2, y + height / 2]
    @width = width
    @height = height
    vertices = [Vector[-@width / 2, -@height / 2], Vector[@width / 2, -@height / 2], Vector[@width / 2, @height / 2], Vector[-@width / 2, @height / 2]]
    super(@center, vertices)
  end
end
