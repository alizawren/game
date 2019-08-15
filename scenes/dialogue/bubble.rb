require "gosu"

class Bubble
  attr_reader :isOption
  attr_reader :nextId
  attr_reader :text
  attr_reader :source
  attr_reader :delay

  def initialize(sceneRef, text = "", source = nil, isOption = false, i = 0, nextId = -1, bubbleColor: BUBBLE_COLOR, delay: 10, fps: 30)
    @sceneRef = sceneRef
    @source = source
    @type = "normal"
    @text = text
    @font = Gosu::Font.new(FONT_HEIGHT, :name => FONT_TYPE)
    @show = true

    @width = @font.text_width(@text) + BUBBLE_PADDING * 2
    @height = @font.height + BUBBLE_PADDING * 2

    # options stuff
    @isOption = isOption
    @i = i
    @extra_height_based_on_index = @isOption ? (@i + 1) * (@height + BUBBLE_PADDING) : 0
    @nextId = nextId

    @frame = 0
    @delay = delay
    @loaded = false
    @fps = fps
    @timer = 60 / @fps
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
    @deleteAnimOn = false

    @delete_t = 0
    @delete_vector = []
  end

  def update
    if (@timer == 0)
      @frame += 1
      if @frame >= @text.length + @delay && !@loaded
        #dialogue fully loaded
        if (!@deleteAnimOn)
          @sceneRef.eventHandler.onNotify({ bubble: self }, :bubbleLoaded)
          @loaded = true
        end
      end
      # if @frame >= @duration and @duration > 0
      #   @sceneRef.eventHandler.onNotify({ dialogue: self }, :bubbleTimedOut)
      # end
      @timer = 60 / @fps
    else
      @timer -= 1
    end
    if !@source.nil?
      vec = @sceneRef.cameratransform * Vector[@source.x, @source.y, 1]
      @x = vec[0] + BUBBLE_OFFSET_X
      @y = vec[1] + @extra_height_based_on_index + BUBBLE_OFFSET_Y
    end

    if (@deleteAnimOn)
      if (@delete_t >= 1)
        @sceneRef.eventHandler.onNotify({ bubble: self }, :deleteFromActive)
      else
        @delete_t += 0.06
        # if we're deleting, play our lil animation (quadratic bezier curve)
        newVector = (1 - @delete_t) ** 2 * @delete_vector[0] + 2 * (1 - @delete_t) * @delete_t * @delete_vector[1] + @delete_t ** 2 * @delete_vector[2]

        @x = newVector[0]
        @y = newVector[1]

        @bubbleColor = Gosu::Color.new(255 * (1 - @delete_t), @bubbleColor.red, @bubbleColor.green, @bubbleColor.blue)
      end
    end
  end

  def deleteMe
    # only run this once
    if (!@deleteAnimOn)
      @deleteAnimOn = true
      # instantiate a vector for the bubble to follow
      @delete_vector = [Vector[@x, @y], Vector[@x, @y - 10], Vector[@x, @y + 30]]
    end
  end

  def draw
    if !@show
      return
    end

    # if @deleteAnimOn
    #   if (@height <= 0)
    #     @sceneRef.eventHandler.onNotify({ bubble: self }, :deleteFromActive)
    #   else
    #     @height -= 1
    #   end
    # end
    if !@source.nil?
      Gosu.draw_rect(@x, @y, @width, @height, @bubbleColor, @z)
      @font.draw_text(@text[0, @frame], @x + BUBBLE_PADDING, @y + BUBBLE_PADDING, @z)
    else
      Gosu.draw_rect(@x, @y, @width, @height, @bubbleColor, @z)
      @font.draw_text(@text[0, @frame], @x + BUBBLE_PADDING, @y + BUBBLE_PADDING, @z)
    end
  end

  def contains(x, y)
    if (@deleteAnimOn)
      return false
    end
    if (x < @x + @width && x > @x && y < @y + @height && y > @y)
      return true
    end
    return false
  end
end
