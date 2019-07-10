require 'gosu'
require 'json'
require 'matrix'
class Polygon
    def initialize(vertices)
        @vertices = [];
        for vertex in vertices do
            @vertices.push(Vector.elements(vertex));
        end
        @axes = [];
        for i in 0..@vertices.length-1 do
            v = @vertices[i]
            nextVertex = @vertices[i+1 == @vertices.length ? 0 : i + 1];
            edge = v-nextVertex
            normal = Vector[edge[1]*-1,edge[0]*-1].normalize()
            @axes.push(normal)
        end
    end
    def vertices
        @vertices
    end
    def axes
        @axes
    end
    def project(    )
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
end

class Projection
    def initialize(min,max)
        @min = min
        @max = max
    end
    def min
        @min
    end
    def max
        @max
    end
    def overlap(p2)
        if @max > p2.min && @min < p2.max
            return true
        end
        return false
    end
end

class MTV
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
        if ! p1.overlap(p2)
            return false
        end
    end
    for i in 0..polygon2.axes.length-1 do
        p1 = polygon1.project(polygon2.axes[i])
        p2 = polygon2.project(polygon2.axes[i])
        if ! p1.overlap(p2)
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

class SAT < Gosu::Window
    def initialize
        super 800,800
        self.caption = "SAT"

        @vertices1 = JSON.load File.new("./data/vertices0.json")
        @vertices2 = JSON.load File.new("./data/vertices2.json")
        
        @polygon1 = Polygon.new(@vertices1)
        @polygon2 = Polygon.new(@vertices2)

        if checkCollision(@polygon1,@polygon2)
            puts "coll"
        else
            puts "not coll"
        end
        
    end
    
    def update
        # update stuff

    end 

    def draw
        # weiro
        for vertex in @polygon1.vertices do
            draw_rect(vertex[0],vertex[1],10,10,Gosu::Color.new(255,0,0))
        end
        for vertex in @polygon2.vertices do
            draw_rect(vertex[0],vertex[1],10,10,Gosu::Color.new(0,255,0))
        end
    end
end

SAT.new.show
