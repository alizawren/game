class Animation
  attr_accessor :flip

  def initialize(spriteSheet, width = 128, height = 128, tileWidth = 128, tileHeight = 128, fps = 10)
    @width = width
    @height = height
    @img_array = Gosu::Image.load_tiles(spriteSheet, tileWidth, tileHeight)

    @frame = 0
    @fps = fps
    @timer = 60 / @fps

    @flip = 0 # 0 for facing right, 1 for facing left
  end

  def update
    if (@timer == 0)
      @frame = (@frame + 1) % @img_array.length
      @timer = 60 / @fps
    else
      @timer -= 1
    end
  end

  def draw(x, y, z = 1)
    # @img_array[@frame].draw(x, y, 1)

    color = Gosu::Color::WHITE
    if (@flip == 0)
      @img_array[@frame].draw_as_quad(x, y, color, x + @width, y, color, x + @width, y + @height, color, x, y + @height, color, z)
      #   @img_array[@frame].draw(x, y, 1, 1)
    else
      @img_array[@frame].draw_as_quad(x + @width, y, color, x, y, color, x + @width, y + @height, color, x, y + @height, color, z)
      #   @img_array[@frame].draw(x, y, 1, -1)
    end
  end
end
