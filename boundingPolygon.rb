require "gosu"
require "matrix"

class BoundingPolygon
  attr_reader :vertices
  attr_reader :axes
  attr_accessor :color
  attr_accessor :transform

  # required to be initialized with an object
  def initialize(obj, vertices = [])
    @obj = obj
    if vertices.length > 0 && vertices.length < 3
      raise "ERROR instantiating bounding polygon"
    end
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

  def update
    pos = @obj.center
    for i in 0..@vertices.length - 1
      @vertices[i] = @baseVertices[i] + pos
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

  def draw
    transformed_vertices = []
    for vertex in @vertices
      curr = Vector[vertex[0], vertex[1], 1]
      newpos = @transform * curr
      x = newpos[0]
      y = newpos[1]
      transformed_vertices.push(Vector[x, y])
    end

    color = Gosu::Color::GREEN

    for i in 0..transformed_vertices.length - 2
      currV = transformed_vertices[i]
      nextV = transformed_vertices[i + 1]
      Gosu.draw_line(currV[0], currV[1], color, nextV[0], nextV[1], color)
    end
    # draw last line
    currV = transformed_vertices[transformed_vertices.length - 1]
    nextV = transformed_vertices[0]
    Gosu.draw_line(currV[0], currV[1], color, nextV[0], nextV[1], color)
  end

  # def draw_frame
  #   transformed_vertices = []
  #   for vertex in @vertices
  #     curr = Vector[vertex[0], vertex[1], 1]
  #     newpos = @transform * curr
  #     x = newpos[0]
  #     y = newpos[1]
  #     transformed_vertices.push(Vertex[x, y])
  #   end

  #   for vertex in @vertices
  #     Gosu.draw_rect(vertex[0], vertex[1], 10, 10, Gosu::Color.new(255, 0, 0))
  #   end
  # end
end
