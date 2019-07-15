require "gosu"
require "matrix"

class Polygon
  attr_reader :vertices
  attr_reader :axes
  attr_accessor :color
  attr_accessor :transform

  def initialize(vertices = [])
    @position = Vector[0, 0]
    @baseVertices = []
    for vertex in vertices
      @baseVertices.push(Vector[vertex[0], vertex[1]])
    end
    @vertices = []
    for vertex in @baseVertices
      @vertices.push(Vector[vertex[0], vertex[1]])
    end

    # for vertex in vertices do
    #     @vertices.push(Vector.elements(vertex));
    # end
    @axes = []
    for i in 0..@vertices.length - 1
      v = @vertices[i]
      nextVertex = @vertices[i + 1 == @vertices.length ? 0 : i + 1]
      edge = v - nextVertex
      normal = Vector[edge[1] * -1, edge[0] * -1].normalize()
      @axes.push(normal)
    end
    @baseAxes = @axes
  end

  def update(x, y)
    # @position[0] = x
    # @position[1] = y
    @position = Vector[x, y]
    for i in 0..@vertices.length - 1
      @vertices[i] = @baseVertices[i] + @position
    end
    @axes = []
    for i in 0..@vertices.length - 1
      v = @vertices[i]
      nextVertex = @vertices[i + 1 == @vertices.length ? 0 : i + 1]
      edge = v - nextVertex
      normal = Vector[edge[1] * -1, edge[0] * -1].normalize()
      @axes.push(normal)
    end
  end

  def project(axis)
    min = axis.dot(@vertices[0])
    max = min
    for i in 0..@vertices.length - 1
      p = axis.dot(@vertices[i])
      if p < min
        min = p
      elsif p > max
        max = p
      end
    end
    proj = Projection.new(min, max)
  end

  def draw_frame
    for vertex in @vertices
      curr = Vector[vertex[0], vertex[1], 1]
      newpos = @transform * curr
      x = newpos[0]
      y = newpos[1]
      Gosu.draw_rect(x, y, 10, 10, Gosu::Color.new(255, 0, 0))
      # Gosu.draw_line()
    end
  end
end
