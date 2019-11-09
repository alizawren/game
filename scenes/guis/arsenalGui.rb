require_relative "./menuGui.rb"
require_relative "./aboutGui.rb"
require_relative "../gameScene.rb"
require_relative "../../WordWrap.rb"

class ArsenalGui < MenuGui
  def initialize
    # super(100, 30)
    super

    @choices = ["Confirm", "Cancel"]
  end

  def update
    startX = CANVAS_WIDTH / 2 - 150
    y = 680

    @selector.x = startX - MARGIN / 2 + @select * 200
    @selector.y = y
    @selector.width = @font.text_width(@choices[@select]) + MARGIN
    @selector.height = @font.height
  end

  def draw
    super
    img = Gosu::Image.new("img/gui/arsenalgui.png")

    img.draw(100, 30, GUI_LAYER)

    drawStats
    drawDescription
    drawChoices

    @selector.draw(@selector.x, @selector.y, @z + 1)
  end

  def drawStats
    @font.draw_text("Stats", 900, 100, @z)
  end

  def drawDescription
    @font.draw_text("Description", 900, 260, @z)

    newFont = Gosu::Font.new(FONT_HEIGHT - 4)
    description = "This is a test GUI. Building a GUI requires a surprising amount of work. This lil box here is meant to display descriptions of the items."
    lines = WordWrap.breakIntoLines(newFont, description, 265)

    for i in 0..lines.length - 1
      line = lines[i]
      newFont.draw_text(line, 870, 290 + newFont.height * i, @z)
    end
  end

  def drawChoices
    startX = CANVAS_WIDTH / 2 - 150
    y = 680
    for i in 0..@choices.length - 1
      @font.draw_text(@choices[i], startX + i * 200, y, @z)
    end
  end

  def button_down(id, close_callback)
    case id
    when Gosu::KB_UP
    when Gosu::KB_DOWN
    when Gosu::KB_LEFT
      @select = (@select + @choices.length - 1) % @choices.length
    when Gosu::KB_RIGHT
      @select = (@select + 1) % @choices.length
    when Gosu::KB_RETURN, Gosu::KB_Z
      case @select
      when 0
        SceneManager.guiPop
      when 1
        SceneManager.guiPop
      else
        SceneManager.guiPop
      end
    end
  end
end
