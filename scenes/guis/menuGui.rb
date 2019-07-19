require_relative "../../gui.rb"

class MenuGui < Gui 
    def initialize(x = 0, y = 0, width = CANVAS_WIDTH - 2 * x, height = CANVAS_HEIGHT - 2 * y)
        super x,y,width,height 
        # in every GUI there is a selector
        @selector = Rectangle.new(@x, @y, 40, 30, clear: true)
        @select = 0
    end

    def update
        super
    end

    def draw
        super
        @selector.draw(@selector.x, @selector.y, @z + 1)
    end
    
    def button_down(id, close_callback)
        puts ("Button pressed... override me!")
        SceneManager.guiPop() # auto pops to avoid some memory issues if this hasn't been overriden yet. All guis should take care of themselves
    end
end