require "gosu"

class Bubble
  attr_reader :isOption
  attr_reader :nextId
  attr_reader :text
  attr_reader :source
  attr_reader :delay
  attr_reader :fullText

  def initialize(sceneRef, text = "", source = nil, isOption = false, i = 0, nextId = -1, bubbleColor: BUBBLE_COLOR, icon: "img/icons/talk icon2.png", delay: 20, fps: 45, fullText: "")
    @sceneRef = sceneRef
    @source = source
    @type = "normal"
    @text = text
    @font = Gosu::Font.new(FONT_HEIGHT, :name => FONT_TYPE)
    @isOption = isOption
    @show = true
    @fullText = fullText

    # @width = @font.text_width(@text) + BUBBLE_PADDING * 2
    @maxWidth = @isOption ? DEFAULT_OPTION_BUBBLE_WIDTH : DEFAULT_BUBBLE_WIDTH
    @textLines = breakIntoLines(text, @maxWidth)
    numLines = @textLines.length
    @width = @maxWidth
    # @width = 0
    @height = (@font.height + BUBBLE_PADDING) * numLines + BUBBLE_PADDING
    @lineHeight = @font.height + BUBBLE_PADDING * 2

    # options stuff
    # TODO: INDEX IS NOT ENOUGH. Options may take up multiple lines, in which case this won't work
    @i = i
    @extra_height_based_on_index = @isOption ? (@i + 1) * (@lineHeight + BUBBLE_PADDING) : 0
    @nextId = nextId

    @lineFrame = 0
    @drawFrame = 0
    @frame = 0
    @delay = delay
    @loaded = false
    @fps = fps
    @timer = 60 / @fps
    if !@source.nil?
      cameraInvert = -@sceneRef.camera.pos
      vec = @source.center * @sceneRef.camera.scale + cameraInvert
      @x = vec[0] + BUBBLE_OFFSET_X
      @y = vec[1] + @extra_height_based_on_index + BUBBLE_OFFSET_Y
    else
      @x = MAIN_BUBBLE_OFFSET_X
      @y = MAIN_BUBBLE_OFFSET_Y + @extra_height_based_on_index
    end
    @z = TEXT_LAYER

    @bubbleColor = @isOption ? BUBBLE_COLOR_OPTION : bubbleColor
    @opacity = 255
    @icon = @source.nil? ? Gosu::Image.new(icon, :tileable => true, :retro => true) : nil

    @deleteAnimOn = false

    @delete_t = 0
    @delete_vector = []
  end

  def numLines(text, maxWidth)
    i = 0
    j = 1
    numLines = 1
    while j < text.length
      currTextWidth = @font.text_width(text[i, j])
      if currTextWidth >= maxWidth
        i = j
        numLines += 1
      end
      j += 1
    end
    return numLines
  end

  def breakIntoLines(text, maxWidth)
    lines = []
    widths = []
    words = text.gsub(/\s+/m, " ").strip.split(" ")
    currText = ""
    for word in words
      newText = currText + word
      if @font.text_width(newText) >= maxWidth
        lines.push(currText)
        widths.push(@font.text_width(currText))
        currText = word + " "
      else
        currText = newText + " "
      end
    end
    lines.push(currText)
    widths.push(@font.text_width(currText))
    @maxWidth = widths.max
    return lines
  end

  def update
    if (@timer == 0)
      @frame += 1
      @drawFrame += 1
      # @width = [@font.text_width(@text[0, @frame]), @maxWidth].min + BUBBLE_PADDING * 2
      if @frame >= @text.length + @delay && !@loaded
        #dialogue fully loaded
        if (!@deleteAnimOn)
          @sceneRef.eventHandler.onNotify({ bubble: self }, :bubbleLoaded)
          @loaded = true
        end
      end
      if @lineFrame < @textLines.length
        if @drawFrame >= @textLines[@lineFrame].length
          @drawFrame = 0
          @lineFrame += 1
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
      cameraInvert = -@sceneRef.camera.pos
      vec = @source.center * @sceneRef.camera.scale + cameraInvert
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
        # TODO: vector should not be transformed by camera. Should be transformed afterwards

        @opacity = 255 * (1 - @delete_t)
        @bubbleColor = Gosu::Color.new(@opacity, @bubbleColor.red, @bubbleColor.green, @bubbleColor.blue)
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

    pos = Vector[@x, @y]
    # pos = pos * @sceneRef.camera.scale + @sceneRef.camera.pos

    Gosu.draw_rect(pos[0], pos[1], @width, @height, @bubbleColor, @z)

    @textLines.each_index do |lineIndex|
      line = @textLines[lineIndex]
      if @lineFrame > lineIndex
        # Gosu.draw_rect(@x, @y + lineIndex * (@font.height + BUBBLE_PADDING), @maxWidth + 2 * BUBBLE_PADDING, @lineHeight, @bubbleColor, @z)
        @font.draw_text(line, pos[0] + BUBBLE_PADDING, pos[1] + BUBBLE_PADDING + lineIndex * (@font.height + BUBBLE_PADDING), @z)
      elsif @lineFrame == lineIndex
        # Gosu.draw_rect(@x, @y + lineIndex * (@font.height + BUBBLE_PADDING), [@font.text_width(line[0, @drawFrame]), @maxWidth].min + BUBBLE_PADDING * 2, @lineHeight, @bubbleColor, @z)
        @font.draw_text(line[0, @drawFrame], pos[0] + BUBBLE_PADDING, pos[1] + BUBBLE_PADDING + lineIndex * (@font.height + BUBBLE_PADDING), @z)
      end
    end

    if !@icon.nil?
      @icon.draw(ICON_OFFSET_X, ICON_OFFSET_Y, @z, 2, 2, Gosu::Color.new(@opacity, 255, 255, 255))
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
