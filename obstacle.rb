require 'gosu'
require_relative './collision.rb'

class Obstacle
    attr_accessor :polygon
    def initialize(vertices,color=Gosu::Color::WHITE,z=0,clear=false)
        #when you create an obstacle, you pass in its vertices
        #these vertices have to eb relative to the origin of the map
        #optional parameters are color, order (z), and clear/block
        @vertices = vertices;
        @polygon = Polygon.new(vertices)
        #the vertices are an array of 2d ruby vectors
        @color = color
        @z = z
        @clear = clear
        #image = ???
        #we'll add textures at some point
    end
    def update

    end
    def draw
        #I opted to just draw its vertices for now
        #edges are unnecessary for calculation
        #when we create the actual game,
        #we can stretch the image to match the vertices
        for vertex in @vertices do
            Gosu.draw_rect(vertex[0],vertex[1],15,15,Gosu::Color::WHITE)
        end
        @polygon.draw
    end
end

class Wall < Obstacle
    #walls are just rectangle shaped obstacles
    def initialize(x=0,y=0,width=30,height=30,color=Gosu::Color::WHITE,z=0,clear=false)
        @x=x
        @y=y
        @width=width
        @height=height
        #calculates the vertices and calls on superclass constructor
        super [Vector[@x,@y],Vector[@x+@width,@y],Vector[@x+@width,@y+@height],Vector[@x,@y+@height]],color,z,clear
    end
end