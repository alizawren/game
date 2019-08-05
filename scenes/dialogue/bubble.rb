require "gosu"

class Bubble
  attr_reader :isOption
  attr_reader :nextId
  attr_accessor :show

  def initialize(sceneRef, text = "", source = nil, sequenceId = 0, isOption = false, i = 0, nextId = -1, bubbleColor: BUBBLE_COLOR, wait: 0, fps: 20, show: false)
    @sceneRef = sceneRef
    @source = source
    @type = "normal"
    @text = text
    @sequenceId = sequenceId
    @font = Gosu::Font.new(FONT_HEIGHT, :name => FONT_TYPE)
    @show = show

    @bubbleColor = bubbleColor

    @width = @font.text_width(@text) + BUBBLE_PADDING * 2
    @height = @font.height + BUBBLE_PADDING * 2

    # options stuff
    @isOption = isOption
    @i = i
    @extra_height_based_on_index = @isOption ? (@i + 1) * (@height + BUBBLE_PADDING) : 0
    @nextId = nextId

    @frame = 0
    @wait = wait # NOTE: we should configure a way of automatically showing this bubble once the MAIN dialogue has finished loading, if wait = -1
    @fps = fps
    @timer = 60 / @fps
    @timer2 = 0 # TEMPORARY, we really want just one timer
    if !@source.nil?
      vec = @sceneRef.cameratransform * Vector[@source.x, @source.y, 1]
      @x = vec[0]
      @y = vec[1] + @extra_height_based_on_index
    else
      @x = 100
      @y = CANVAS_HEIGHT - 200 + @extra_height_based_on_index
    end
    @z = TEXT_LAYER
  end

  def update
    if (@timer2 >= @wait)
      @show = true
      if (@timer == 0)
        if @frame < @text.length
          @frame += 1
        else
          #dialogue fully loaded
          # @show = false
          @sceneRef.eventHandler.onNotify({ sequenceId: @sequenceId }, :dialogueLoaded)
        end
        @timer = 60 / @fps
      else
        @timer -= 1
      end
      if !@source.nil?
        vec = @sceneRef.cameratransform * Vector[@source.x, @source.y, 1]
        @x = vec[0]
        @y = vec[1] + @extra_height_based_on_index
      end
    else
      @timer2 += 1
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
