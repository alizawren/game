# require_relative "../../eventHandler.rb"
require_relative "./bubble.rb"
require_relative "../../functions.rb"
# require_relative "./optionsDialogue.rb"

class DialogueHandler
  def initialize(sceneRef)
    @sceneRef = sceneRef

    @timer = -1
    @timeoutId = -1

    @dialogueData = nil
    @id = 0
    @activeBubbleQueue = []
    @bubbleQueue = []
  end

  def onNotify(dataObj, event)
    case event
    when :createDialogue
      createDialogue(dataObj)
    when :bubbleClicked
      bubble = dataObj[:bubble]
      # push the bubble back in as non option
      newBubbleObj = Bubble.new(@sceneRef, bubble.text, bubble.source, delay: 10)

      if (bubble.nextId.is_a? String)
        func = bubble.nextId.to_sym
        send(func)
        endOfDialogue
        return
      end
      if (bubble.nextId < 0)
        @id += 1
      else
        @id = bubble.nextId
      end

      @bubbleQueue.push(newBubbleObj)
      loadNextSequence
    when :bubbleLoaded
      if (@activeBubbleQueue.last.kind_of?(Array))
      end
      if (@bubbleQueue.length > 0)
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
        @activeBubbleQueue.push(newBubble)
      end
    when :bubbleTimedOut
    when :deleteFromActive
      deleteBubble(dataObj[:bubble].object_id)
    else
    end
  end

  def deleteBubble(id)
    for i in 0..@activeBubbleQueue.length - 1
      if @activeBubbleQueue[i].is_a?(Bubble)
        if @activeBubbleQueue[i].object_id == id
          @activeBubbleQueue.delete_at(i)
          return
        end
      else
        for j in 0..@activeBubbleQueue[i].length - 1
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

    for val in @dialogueData["sequence"]
      if (val["id"] == @id)
        for bubble in val["bubbles"]
          obj = nil
          # parse source
          source = nil
          case bubble["source"]
          when "player"
            source = @sceneRef.player
          end

          bubbleDelay = bubble["delay"] ? bubble["delay"] : 10

          case bubble["type"]
          when "normal"
            text = !bubble["text"].nil? ? bubble["text"] : ""
            obj = Bubble.new(@sceneRef, text, source, delay: bubbleDelay)
            @bubbleQueue.push(obj)
          when "options"
            optionsArr = []
            for i in 0..bubble["choices"].length - 1
              choice = bubble["choices"][i]
              text = !choice["text"].nil? ? choice["text"] : ""
              nextId = choice["nextId"] ? choice["nextId"] : -1
              obj = Bubble.new(@sceneRef, text, source, true, i, nextId, delay: bubbleDelay)
              optionsArr.push(obj)
            end
            @bubbleQueue.push(optionsArr)
            #   obj = OptionsDialogue.new(bubble["choices"], source)
          end
        end
        # by default there is no timeout. specify one to time out a conversation
        timeout = val["timeout"] ? val["timeout"] : -1
        @timeoutId = val["timeoutId"] ? val["timeoutId"] : @id + 1
        @timer = timeout # ?

        firstBubble = @bubbleQueue.shift
        if (!firstBubble.nil?)
          @activeBubbleQueue.push(firstBubble)
        end
        return
      end
    end
    endOfDialogue
  end

  def endOfDialogue
    deleteAllActiveBubbles
    @id = 0
    @dialogueData = nil
    @sceneRef.dialogueMode = false
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
      # TODO: there's a bug here. We need to check if there's
      # no next ID. Currently, the value -1 is taken up to mean
      # "use the next id".... I guess we could use -2?
      @bubbleQueue = []
      loadNextSequence
    elsif (@timer > 0)
      @timer -= 1
    end
  end

  def draw
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
                onNotify({ bubble: bub }, :bubbleClicked)
              end
            end
          end
        end
      end
    end
  end
end
