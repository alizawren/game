require "gosu"
require "matrix"
class BoundingPolygon 
  attr_reader :obj 
  attr_accessor :center 
  attr_reader :width 
  attr_reader :height 
  attr_reader :halfsize 
  attr_accessor :color
  def initialize(obj,relativeCenter=Vector[0,0],width=obj.width,height=obj.height)
    @color = Gosu::Color::GREEN 
    @obj = obj 
    @center = obj.center 
    @relativeCenter = relativeCenter
    @width = width 
    @height = height 
    @halfsize = Vector[@width/2,@height/2]
  end
  def size 
    return Vector[@width,@height]
  end
  def center3
    return Vector[@center[0],@center[1],1]
  end
  def topleft
    return Vector[@center[0]-width/2,@center[1]-height/2]
  end
  def topright
    return Vector[@center[0]+width/2,@center[1]-height/2]
  end
  def bottomleft
    return Vector[@center[0]-width/2,@center[1]+height/2]
  end
  def bottomright
    return Vector[@center[0]+width/2,@center[1]+height/2]
  end
  def update
    @center = @obj.center+@relativeCenter
    #do some kind of rotation/transformation of the halfsize
    #to assist collisions 
  end
  def draw(transf)
    vertices = [Vector[@center[0]-@halfsize[0],@center[1]-@halfsize[1]],Vector[@center[0]+@halfsize[0],@center[1]-@halfsize[1]],Vector[@center[0]+@halfsize[0],@center[1]+@halfsize[1]],Vector[@center[0]-@halfsize[0],@center[1]+@halfsize[1]]]
    vertices.each_index do |i|
      currV = nil
      nextV = nil
      if (i == vertices.length - 1)
        # draw last line
        currV = vertices[vertices.length - 1]
        nextV = vertices[0]
      else
        currV = vertices[i]
        nextV = vertices[i + 1]
      end
      currHom = Vector[currV[0], currV[1], 1]
      newCurr = transf * currHom
      currV = Vector[newCurr[0], newCurr[1]]

      nextHom = Vector[nextV[0], nextV[1], 1]
      newNext = transf * nextHom
      nextV = Vector[newNext[0], newNext[1]]
      Gosu.draw_line(currV[0], currV[1], @color, nextV[0], nextV[1], @color, 100)
    end
  end
end

# class BoundingPolygon
#   #REDO THIS TO BE HALF SIZES AND CENTERS INSTEAD OF VERTICES
#   attr_reader :vertices
#   attr_reader :axes
#   attr_accessor :color

#   # required to be initialized with an object
#   def initialize(obj, vertices = [])
#     @color = Gosu::Color::GREEN
#     @obj = obj
#     if vertices.length > 0 && vertices.length < 3
#       raise "ERROR instantiating bounding polygon"
#     end
#     @baseVertices = []
#     for vertex in vertices
#       @baseVertices.push(Vector[vertex[0], vertex[1]])
#     end

#     transformVertices

#     @axes = []
#     for i in 0..@vertices.length - 1
#       v = @vertices[i]
#       nextVertex = @vertices[i + 1 == @vertices.length ? 0 : i + 1]
#       edge = v - nextVertex
#       normal = Vector[edge[1] * -1, edge[0] * -1].normalize()
#       @axes.push(normal)
#     end
#     @baseAxes = @axes
#   end

#   def transformVertices
#     @vertices = []
#     pos = Vector[@obj.center[0], @obj.center[1]]
#     for vert in @baseVertices
#       @vertices.push(vert + pos)
#     end
#   end

#   def update
#     # hom = Vector[@obj.center[0], @obj.center[1], 1]
#     # transformed_center = @obj.transform * hom
#     pos = Vector[@obj.center[0], @obj.center[1]]
#     for i in 0..@vertices.length - 1
#       @vertices[i] = @baseVertices[i] + pos
#     end
#     @axes = []
#     for i in 0..@vertices.length - 1
#       v = @vertices[i]
#       nextVertex = @vertices[i + 1 == @vertices.length ? 0 : i + 1]
#       edge = v - nextVertex
#       normal = Vector[edge[1] * -1, edge[0] * -1].normalize()
#       @axes.push(normal)
#     end
#   end

#   def project(axis)
#     min = axis.dot(@vertices[0])
#     max = min
#     for i in 0..@vertices.length - 1
#       p = axis.dot(@vertices[i])
#       if p < min
#         min = p
#       elsif p > max
#         max = p
#       end
#     end
#     proj = Projection.new(min, max)
#   end

#   def draw(transf)
#     for i in 0..@vertices.length - 1
#       currV = nil
#       nextV = nil
#       if (i == @vertices.length - 1)
#         # draw last line
#         currV = @vertices[@vertices.length - 1]
#         nextV = @vertices[0]
#       else
#         currV = @vertices[i]
#         nextV = @vertices[i + 1]
#       end
#       currHom = Vector[currV[0], currV[1], 1]
#       newCurr = transf * currHom
#       currV = Vector[newCurr[0], newCurr[1]]

#       nextHom = Vector[nextV[0], nextV[1], 1]
#       newNext = transf * nextHom
#       nextV = Vector[newNext[0], newNext[1]]
#       Gosu.draw_line(currV[0], currV[1], @color, nextV[0], nextV[1], @color, 100)
#     end
#   end
# end
