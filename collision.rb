require 'gosu'
require 'json'
require 'matrix'
class Polygon
    attr_reader :vertices 
    attr_reader :axes
    def initialize(vertices)
        @position = Vector[0,0]
        @baseVertices = []
        for vertex in vertices do
            @baseVertices.push(Vector[vertex[0],vertex[1]])
        end
        @vertices = []
        for vertex in @baseVertices do
            @vertices.push(Vector[vertex[0],vertex[1]])
        end
        
        # for vertex in vertices do
        #     @vertices.push(Vector.elements(vertex));
        # end
        @axes = []
        for i in 0..@vertices.length-1 do
            v = @vertices[i]
            nextVertex = @vertices[i+1 == @vertices.length ? 0 : i + 1];
            edge = v-nextVertex
            normal = Vector[edge[1]*-1,edge[0]*-1].normalize()
            @axes.push(normal)
        end
        @baseAxes = @axes
    end
    def update(x,y)
        @position[0] = x
        @position[1] = y
        for i in 0..@vertices.length-1 do
            @vertices[i] = @baseVertices[i]+@position
        end
        @axes = []
        for i in 0..@vertices.length-1 do
            v = @vertices[i]
            nextVertex = @vertices[i+1 == @vertices.length ? 0 : i + 1];
            edge = v-nextVertex
            normal = Vector[edge[1]*-1,edge[0]*-1].normalize()
            @axes.push(normal)
        end
    end
    def project(axis)
        min = axis.dot(@vertices[0])
        max = min
        for i in 0..@vertices.length-1 do
            p = axis.dot(@vertices[i])
            if p < min
                min = p
            elsif p > max
                max = p
            end
        end
        proj = Projection.new(min,max);
    end
    def draw
        for vertex in @vertices do
            Gosu.draw_rect(vertex[0],vertex[1],10,10,Gosu::Color.new(255,0,0))
        end
    end

end

class Projection
    attr_reader :min
    attr_reader :max
    def initialize(min,max)
        @min = min
        @max = max
    end
    def overlap(p2)
        if @max >= p2.min && @min <= p2.max
            return true
        end
        return false
    end
    def getOverlap(p2)
        # if @max > p2.max
        #     return p2.max-@min
        # else
        #     return @max-p2.min
        # end
        return p2.max-@min
        return 0
    end
end

class MTV
    attr_reader :v
    def initialize(smallest, overlap)
        @smallest = smallest
        @overlap = overlap
        @v = smallest.normalize()*overlap;
    end
end

def checkCollision(polygon1,polygon2)
    for i in 0..polygon1.axes.length-1 do
        p1 = polygon1.project(polygon1.axes[i])
        p2 = polygon2.project(polygon1.axes[i])
        if !p1.overlap(p2)
            return false
        end
    end
    for i in 0..polygon2.axes.length-1 do
        p1 = polygon1.project(polygon2.axes[i])
        p2 = polygon2.project(polygon2.axes[i])
        if !p1.overlap(p2)
            return false
        end
    end
    return true
end

def findOverlap(polygon1,polygon2)
    overlap = 999_999_999
    smallest = NIL
    for i in 0..polygon1.axes.length-1 do
        p1 = polygon1.project(polygon1.axes[i])
        p2 = polygon2.project(polygon1.axes[i])
        
        if !p1.overlap(p2)
            return false
        else 
            
            o = p1.getOverlap(p2)
            if o < overlap
                overlap = o
                smallest = polygon1.axes[i]
            end
        end
    end
    for i in 0..polygon2.axes.length-1 do
        p1 = polygon1.project(polygon2.axes[i])
        p2 = polygon2.project(polygon2.axes[i])
        if !p1.overlap(p2)
            return false
        else 
            o = p1.getOverlap(p2)
            if o < overlap
                overlap = o
                smallest = polygon2.axes[i]
            end
        end
    end
    return MTV.new(smallest,overlap)
end
