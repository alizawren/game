require "gosu"
require_relative "../../collision.rb"
require_relative "../gameObject.rb"

class Obstacle < GameObject
  attr_accessor :bounding
  attr_accessor :vertices
  attr_accessor :z
  attr_accessor :clear

  def initialize(vertices = [], z = 0, clear = false)
    super
    @vertices = vertices
    @bounding = Polygon.new(vertices)
    @z = z
    @clear = clear
  end

  def draw

    for vertex in @vertices
      Gosu.draw_rect(vertex[0], vertex[1], 15, 15, Gosu::Color::WHITE)
    end
  end

  def overlap(obj2, mtv = Vector[0, 0])
  end
end
