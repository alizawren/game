require_relative "../../gui.rb"
require_relative "../../constants.rb"

class AboutGui < Gui
  def initialize
    super(20, 20)
  end

  def draw
    super
    text = "If you made it this far, congratulations!"
    @font.draw_text(text, @x + MARGIN, @y + MARGIN, @z)
    @selector.draw
  end
end
