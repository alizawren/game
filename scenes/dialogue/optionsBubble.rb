require_relative "../../constants.rb"

class OptionsBubble
  def initialize(source, choices = ["..."], fps = 20)
    @source = source
    @choices = choices
    @font = Gosu::Font.new(FONT_HEIGHT, :name => FONT_TYPE)
    @x = 0
    @y = 0
    @z = TEXT_LAYER
    @width = @font.text_width(@choices[0]) + MARGIN * 2
    @height = @font.height + MARGIN * 2

    @frame = 0
    @fps = fps
    @timer = 60 / @fps
  end

  def update
    @text = @choices[1]
    if (@timer == 0)
      if @frame < @text.length
        @frame += 1
      end
      @timer = 60 / @fps
    else
      @timer -= 1
    end
    curr = Vector[@source.x + @source.width, @source.y - @source.height / 2, 1]
    newpos = @source.transform * curr
    x = newpos[0]
    y = newpos[1]
    @x = x
    @y = y
  end

  def contains(cameratransf, x, y)
    return true
    mouseHom = Vector[x, y, 1]
    worldMouse = cameratransf.inverse * mouseHom
    x = worldMouse[0]
    y = worldMouse[1]

    if (x <= @x + @width && x >= @x && y <= @y + @height && y >= @y)
      return true
    else
      return false
    end
  end

  def draw(transf)
    vec = transf * Vector[@x, @y, 1]
    for i in 0..@choices.length - 1
      @font.draw_text(@choices[i][0, @frame], vec[0] + MARGIN, vec[1] + (i + 1) * (FONT_HEIGHT + MARGIN), @z)
    end
  end

  def button_down(id, close_callback)
    case id
    when Gosu::KB_UP
      @select = (@select + @choices.length - 1) % @choices.length
    when Gosu::KB_DOWN
      @select = (@select + 1) % @choices.length
    when Gosu::KB_RETURN, Gosu::KB_Z
      case @select
      when 0
        SceneManager.guiPop()
      end
    end
  end
end
