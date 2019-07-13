require_relative "./sceneManager" # GUI has ability to change scenes
require_relative "./constants.rb"
require "gosu"

# class to be inherited
# see https://rivermanmedia.com/object-oriented-game-programming-the-gui-stack/ for more info

class Gui
  attr_accessor :z

  def initialize(x = 0, y = 0, width: CANVAS_WIDTH - 2 * x, height: CANVAS_HEIGHT - 2 * y)
    @borderColor = Gosu::Color::WHITE
    @bgColor = Gosu::Color::BLACK

    @x = x
    @y = y
    @width = width
    @height = height

    # default font
    @font = Gosu::Font.new(FONT_HEIGHT)

    # in every GUI there is a selector
    @selector = Rectangle.new(@x, @y, 40, 30, clear: true)
    @select = 0
  end

  def update
  end

  def draw
    if (@x > 0 || @y > 0)
      Gosu.draw_rect(@x, @y, @width, @height, @bgColor, @z)

      Gosu.draw_line(@x, @y, @borderColor, @x + @width, @y, @borderColor, @z)
      Gosu.draw_line(@x, @y, @borderColor, @x, @y + @height, @borderColor, @z)
      Gosu.draw_line(@x + @width, @y, @borderColor, @x + @width, @y + @height, @borderColor, @z)
      Gosu.draw_line(@x, @y + @height, @borderColor, @x + @width, @y + @height, @borderColor, @z)
    end

    @selector.draw(@selector.x, @selector.y, @z + 1)
  end

  def button_down(id, close_callback)
    puts ("Button pressed... override me!")
    SceneManager.guiPop() # auto pops to avoid some memory issues if this hasn't been overriden yet. All guis should take care of themselves
  end
end
