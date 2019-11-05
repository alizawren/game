require "set"
require_relative "../bubble.rb"
require_relative "../functions.rb"

class DialogueHandler
  def initialize(sceneRef)
    @sceneRef = sceneRef

    @timer = -1
    @timeoutId = -1
    @timeout = -1

    @dialogueData = nil
    @dialogueId = ""
    @id = 0
    @activeBubbleQueue = []
    @bubbleQueue = []

    @activeIcon = nil

    @endFlag
  end

  def onNotify(dataObj, event)
    case event
    when :createDialogue
      createDialogue(dataObj)
    when :bubbleClicked
      bubble = dataObj[:bubble]
      # push the bubble back in as non option
      text = bubble.text
      if (bubble.fullText and bubble.fullText.length > 0)
        text = bubble.fullText
      end
      newBubbleObj = Bubble.new(@sceneRef, text, bubble.source, delay: 10)

      if (bubble.nextId.is_a? String)
        func = bubble.nextId.to_sym
        send(func)
        endOfDialogue
        return
      end
      @id = bubble.nextId

      @bubbleQueue.push(newBubbleObj)
      loadNextSequence
    when :bubbleLoaded
      bubble = dataObj[:bubble]
      if (@bubbleQueue.length > 0)
        # if the next bubble comes from the same source, delete this one on load
        nextBubble = @bubbleQueue.first
        if (nextBubble.kind_of?(Array))
          if (bubble.source == nextBubble.first.source)
            bubble.deleteMe
          end
        elsif (bubble.source == nextBubble.source)
          bubble.deleteMe
        end

        if (@activeBubbleQueue.length > 1)
          oldBubble = @activeBubbleQueue.first
          if (oldBubble.kind_of?(Array))
            if (oldBubble.length < 1)
            end
            for bub in oldBubble
              bub.deleteMe
            end
          else
            oldBubble.deleteMe
          end
        end
        newBubble = @bubbleQueue.shift
        if (newBubble.is_a? Bubble)
          newBubble.active
        end
        @activeBubbleQueue.push(newBubble)
      end
    when :changeIcon
      @activeIcon = Gosu::Image.new(dataObj[:icon], :tileable => true, :retro => true)
    when :deleteFromActive
      deleteBubble(dataObj[:bubble].object_id)
      if @endFlag
        @sceneRef.eventHandler.onNotify({ dialogueId: @dialogueId }, :dialogueEnded)
        @endFlag = false
      end
    when :dialogueEnded
      @id = 0
      @dialogueData = nil
      @dialogueId = ""
      @sceneRef.dialogueMode = false
      @activeIcon = nil
    else
    end
  end

  def deleteBubble(id)
    @activeBubbleQueue.each_index do |i|
      if @activeBubbleQueue[i].is_a?(Bubble)
        if @activeBubbleQueue[i].object_id == id
          @activeBubbleQueue.delete_at(i)
          return
        end
      else
        @activeBubbleQueue[i].each_index do |j|
          if @activeBubbleQueue[i][j].object_id == id
            @activeBubbleQueue.delete_at(i)
            return
          end
        end
      end
    end
  end

  def createDialogue(dataObj)
    @bubbleQueue = []
    @activeBubbleQueue = []
    @sceneRef.dialogueMode = true
    file = File.read(dataObj[:jsonfile])
    data = JSON.parse(file)
    @dialogueData = data

    # send a notification that these are the sources we should focus on
    sources = Set[]
    if (@dialogueData["sources"])
      for srcid in @dialogueData["sources"]
        @sceneRef.objects.each_value do |objectList|
          for srcObj in objectList
            if !srcObj.nil?
              if (srcObj.id == srcid)
                sources.add(srcObj)
              end
            end
          end
        end
      end
    end
    @sceneRef.eventHandler.onNotify({ objects: sources }, :focusObjects)

    loadNextSequence
  end

  def deleteAllActiveBubbles
    for oldBubble in @activeBubbleQueue
      if (oldBubble.is_a?(Bubble))
        oldBubble.deleteMe
      else
        for bub in oldBubble
          bub.deleteMe
        end
      end
    end
  end

  def loadNextSequence
    deleteAllActiveBubbles

    if (@dialogueData["dialogueId"])
      @dialogueId = @dialogueData["dialogueId"]
    end

    # icon = !@dialogueData["icon"].nil? ? @dialogueData["icon"] : "img/icons/info_icon.png"

    for val in @dialogueData["sequence"]
      if (val["id"] == @id)
        for bubble in val["bubbles"]
          obj = nil
          # parse source
          source = nil
          case bubble["source"]
          when "player"
            source = @sceneRef.player
          else
            @sceneRef.objects.each_value do |objectList|
              for srcObj in objectList
                if !srcObj.nil? && !bubble["source"].nil?
                  if (srcObj.id == bubble["source"])
                    source = srcObj
                  end
                end
              end
            end
          end

          bubbleDelay = bubble["delay"] ? bubble["delay"] : 20

          case bubble["type"]
          when "normal"
            text = !bubble["text"].nil? ? bubble["text"] : ""
            if (bubble["icon"])
              icon = bubble["icon"]
            end

            obj = Bubble.new(@sceneRef, text, source, delay: bubbleDelay, icon: icon)
            @bubbleQueue.push(obj)
          when "options"
            optionsArr = []
            bubble["choices"].each_index do |i|
              choice = bubble["choices"][i]
              text = !choice["text"].nil? ? choice["text"] : ""
              fullText = !choice["fullText"].nil? ? choice["fullText"] : ""
              # by default nextId being -1 means it will search for immediate next id
              nextId = choice["nextId"] ? choice["nextId"] : -1
              obj = Bubble.new(@sceneRef, text, source, true, i, nextId, delay: bubbleDelay, fullText: fullText)
              optionsArr.push(obj)
            end
            @bubbleQueue.push(optionsArr)
          end
        end
        # by default there is no timeout (value of -1). specify one to time out a conversation. TODO: make a default timeout of 100 or something
        @timeout = val["timeout"] ? val["timeout"] : -1
        @timeoutId = val["timeoutId"] ? val["timeoutId"] : -1
        @timer = @timeout # TODO: turn on only after last bubble shows. if option clicked, reset

        firstBubble = @bubbleQueue.shift
        if (!firstBubble.nil?)
          if (firstBubble.is_a? Bubble)
            firstBubble.active
          end
          @activeBubbleQueue.push(firstBubble)
        end

        return
      end
    end
    endOfDialogue
  end

  def endOfDialogue
    deleteAllActiveBubbles
    @endFlag = true
  end

  def update
    for bubble in @activeBubbleQueue
      if (bubble.is_a?(Bubble))
        bubble.update
      else
        for bub in bubble
          bub.update
        end
      end
    end
    # TODO: we want to be able to configure the timer to turn on
    # only after the last bubble has shown. This way we don't need
    # to do complex calculations... (multiplying by # of bubbles in
    # conversation, etc...)
    if (@timer == 0)
      # dialogue time out
      @timer -= 1
      @id = @timeoutId
      if (@id.is_a? String)
        func = @id.to_sym
        send(func)
        endOfDialogue
        return
      end
      @bubbleQueue = []
      loadNextSequence
    elsif (@timer > 0)
      @timer -= 1
    end
  end

  def draw
    if !@activeIcon.nil?
      @activeIcon.draw(ICON_OFFSET_X, ICON_OFFSET_Y, TEXT_LAYER, 2, 2, Gosu::Color.new(255, 255, 255, 255))
    end
    for bubble in @activeBubbleQueue
      if (bubble.is_a?(Bubble))
        bubble.draw
      else
        for bub in bubble
          bub.draw
        end
      end
    end
  end

  def button_down(id, close_callback)
    case id
    when Gosu::MS_LEFT
      mouse_x = @sceneRef.mouse_x
      mouse_y = @sceneRef.mouse_y

      if (mouse_x.nil? or mouse_y.nil?)
        return
      end

      if (!@activeBubbleQueue.empty?)
        # do stuff with choices
        for bubble in @activeBubbleQueue
          if (bubble.kind_of?(Array))
            for bub in bubble
              if (bub.contains(mouse_x, mouse_y))
                # could change to @sceneRef.eventHandler.onNotify
                onNotify({ bubble: bub }, :bubbleClicked)
              end
            end
          end
        end
      end
    end
  end
end
