require "gosu"

class Bubble
  attr_reader :isOption

  def initialize(text = "", source = nil, transform = Matrix.I(3), isOption = false, bubbleColor = BUBBLE_COLOR, i: 0, duration: 100, fps: 20, show: true)
    @source = source
    @type = "normal"
    @text = text
    @font = Gosu::Font.new(FONT_HEIGHT, :name => FONT_TYPE)
    @show = show

    @bubbleColor = bubbleColor

    @width = @font.text_width(@text) + BUBBLE_PADDING * 2
    @height = @font.height + BUBBLE_PADDING * 2

    @isOption = isOption
    @i = i
    @extra_height_based_on_index = @isOption ? (@i + 1) * (@height + BUBBLE_PADDING) : 0

    @frame = 0
    @duration = duration
    @fps = fps
    @timer = 60 / @fps
    if !@source.nil?
      vec = transform * Vector[@source.x, @source.y, 1]
      @x = vec[0]
      @y = vec[1] + @extra_height_based_on_index
    else
      @x = 100
      @y = CANVAS_HEIGHT - 200 + @extra_height_based_on_index
    end
    @z = TEXT_LAYER
  end

  def update(transform = Matrix.I(3))
    if (@timer == 0)
      if @frame < @text.length + @duration
        @frame += 1
      else
        @show = false
      end
      @timer = 60 / @fps
    else
      @timer -= 1
    end
    if !@source.nil?
      vec = transform * Vector[@source.x, @source.y, 1]
      @x = vec[0]
      @y = vec[1] + @extra_height_based_on_index
    end
  end

  def draw
    # Gosu::draw_rect(@x,@y,@width,@height,Gosu::Color::WHITE)
    if !@source.nil?
      if @show
        # vec = transform * Vector[@x, @y, 1]

        Gosu.draw_rect(@x, @y, @width, @height, @bubbleColor, @z)
        @font.draw_text(@text[0, @frame], @x + BUBBLE_PADDING, @y + BUBBLE_PADDING, @z)
      end
    else
      @font.draw_text(@text[0, @frame], @x, @y, @z)
    end
  end

  def contains(x, y)
    if (x < @x + @width && x > @x && y < @y + @height && y > @y)
      return true
    end
    return false
  end
end
