require "gosu"
require "matrix"

class BoundingPolygon
  attr_reader :vertices
  attr_reader :axes
  attr_accessor :color

  # required to be initialized with an object
  def initialize(obj, vertices = [])
    @color = Gosu::Color::GREEN
    @obj = obj
    if vertices.length > 0 && vertices.length < 3
      raise "ERROR instantiating bounding polygon"
    end
    @baseVertices = []
    for vertex in vertices
      @baseVertices.push(Vector[vertex[0], vertex[1]])
    end
    @vertices = []

    hom = Vector[@obj.center[0], @obj.center[1], 1]
    transformed_center = @obj.transform * hom
    pos = Vector[transformed_center[0], transformed_center[1]]
    for vert in @baseVertices
      @vertices.push(vert + pos)
    end

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
    hom = Vector[@obj.center[0], @obj.center[1], 1]
    transformed_center = @obj.transform * hom
    pos = Vector[transformed_center[0], transformed_center[1]]
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
    for i in 0..@vertices.length - 1
      currV = nil
      nextV = nil
      if (i == @vertices.length - 1)
        # draw last line
        currV = @vertices[@vertices.length - 1]
        nextV = @vertices[0]
      else
        currV = @vertices[i]
        nextV = @vertices[i + 1]
      end
      Gosu.draw_line(currV[0], currV[1], @color, nextV[0], nextV[1], @color, 100)
    end
  end
end
