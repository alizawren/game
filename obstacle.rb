require 'gosu'

class Obstacle
    attr_accessor :vertices
    def initialize(vertices,color=Gosu::Color::WHITE,z=0,clear=false)
        #when you create an obstacle, you pass in its vertices
        #these vertices have to eb relative to the origin of the map
        #optional parameters are color, order (z), and clear/block
        @vertices = vertices;
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
            draw_circle(vertex[0],vertex[1],15,Gosu::Color::WHITE)
        end
end