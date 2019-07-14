require 'gosu'
require 'matrix'
#a projection class to store a 1-d projection
#of a shape onto an axis
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

#a vector containing the shortest vector to push a
#shape outside of another
#Minimum Translation Vector
class MTV
    attr_reader :v
    def initialize(smallest, overlap)
        @smallest = smallest
        @overlap = overlap
        @v = smallest.normalize()*overlap;
    end
end
#checks if two shapes are colliding
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
#checks if 2 shapes are colliding
#if they are, return a vector that
#is the shrotest vector to move
#the polygon out of another
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
