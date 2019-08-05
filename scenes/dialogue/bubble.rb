require "gosu"

class Bubble
  attr_reader :isOption
  attr_reader :nextId
  attr_accessor :wait
  attr_reader :isMain

  def initialize(sceneRef, text = "", source = nil, sequenceId = 0, isMain = false, isOption = false, i = 0, nextId = -1, bubbleColor: BUBBLE_COLOR, duration: -1, wait: 0, fps: 30, show: false)
    @sceneRef = sceneRef
    @source = source
    @type = "normal"
    @text = text
    @sequenceId = sequenceId
    @font = Gosu::Font.new(FONT_HEIGHT, :name => FONT_TYPE)
    @show = show

    @width = @font.text_width(@text) + BUBBLE_PADDING * 2
    @height = @font.height + BUBBLE_PADDING * 2

    @isMain = isMain

    # options stuff
    @isOption = isOption
    @i = i
    @extra_height_based_on_index = @isOption ? (@i + 1) * (@height + BUBBLE_PADDING) : 0
    @nextId = nextId

    @frame = 0
    @duration = duration
    @wait = @isMain ? 0 : wait # if -1, doesn't show. Note that being the main bubble overrides wait
    @fps = fps
    @timer = 60 / @fps
    @timer2 = 0 # TEMPORARY, we really want just one timer
    if !@source.nil?
      vec = @sceneRef.cameratransform * Vector[@source.x, @source.y, 1]
      @x = vec[0] + BUBBLE_OFFSET_X
      @y = vec[1] + @extra_height_based_on_index + BUBBLE_OFFSET_Y
    else
      @x = 100
      @y = CANVAS_HEIGHT - 200 + @extra_height_based_on_index
    end
    @z = TEXT_LAYER

    @bubbleColor = @isOption ? BUBBLE_COLOR_OPTION : bubbleColor
  end

  def update
    if (@timer2 >= @wait && @wait >= 0)
      @show = true
      if (@timer == 0)
        @frame += 1
        if @frame >= @text.length
          #dialogue fully loaded
          @sceneRef.eventHandler.onNotify({ isMain: @isMain }, :bubbleLoaded)
        end
        if @frame >= @duration and @duration > 0
          @sceneRef.eventHandler.onNotify({ dialogue: self }, :bubbleTimedOut)
        end
        @timer = 60 / @fps
      else
        @timer -= 1
      end
      if !@source.nil?
        vec = @sceneRef.cameratransform * Vector[@source.x, @source.y, 1]
        @x = vec[0] + BUBBLE_OFFSET_X
        @y = vec[1] + @extra_height_based_on_index + BUBBLE_OFFSET_Y
      end
    else
      @timer2 += 1
    end
  end

  def draw
    if !@show
      return
    end
    if !@source.nil?
      Gosu.draw_rect(@x, @y, @width, @height, @bubbleColor, @z)
      @font.draw_text(@text[0, @frame], @x + BUBBLE_PADDING, @y + BUBBLE_PADDING, @z)
    else
      Gosu.draw_rect(@x, @y, @width, @height, @bubbleColor, @z)
      @font.draw_text(@text[0, @frame], @x + BUBBLE_PADDING, @y + BUBBLE_PADDING, @z)
    end
  end

  def contains(x, y)
    if (x < @x + @width && x > @x && y < @y + @height && y > @y)
      return true
    end
    return false
  end
end
