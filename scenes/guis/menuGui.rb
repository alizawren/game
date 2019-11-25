require_relative "./gui.rb"

class MenuGui < Gui
  def initialize(x = 0, y = 0, width = CANVAS_WIDTH - 2 * x, height = CANVAS_HEIGHT - 2 * y)
    super x, y, width, height

    @choices = []
    @selector = Rectangle.new(@x, @y, 40, 30, clear: true)
    @select = 0
  end

  def addChoice(choice, method)
    @choices.push(choice)
    # @choices[choice] = method
  end

  def update
    super
  end

  def draw
    super
    for i in 0..@choices.length - 1
      @font.draw_text(@choices[i], CANVAS_WIDTH / 2 - @font.text_width(@choices[i]) / 2, TEXT_Y + i * (@font.height + MARGIN), @z)
    end

    @selector.draw(@selector.x, @selector.y, @z + 1)
  end

  def button_down(id, close_callback)
    if @choices.length == 0
      return
    end

    case id
    when Gosu::KB_UP
      @select = (@select + @choices.length - 1) % @choices.length
    when Gosu::KB_DOWN
      @select = (@select + 1) % @choices.length
    end
  end
end
