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
    @bubbles = []
  end

  def onNotify(dataObj, event)
    case event
    when :createDialogue
      createDialogue(dataObj)
    when :bubbleLoaded
      if (dataObj[:isMain])
        for bubble in @bubbles
          bubble.wait = 0
        end
      else
        noMain = false
        for bubble in @bubbles
          if (bubble.wait < 0)
            noMain = true
          end
        end
        for bubble in @bubbles
          if (bubble.isMain)
            noMain = false
          end
        end
        if noMain
          for bubble in @bubbles
            bubble.wait = 0
          end
        end
      end
    when :bubbleTimedOut
      deleteBubble(dataObj[:dialogue].object_id)
    else
    end
  end

  def deleteBubble(id)
    for i in 0..@bubbles.length - 1
      if @bubbles[i].object_id == id
        @bubbles.delete_at(i)
        break
      end
    end
  end

  def createDialogue(dataObj)
    @sceneRef.dialogueMode = true
    file = File.read(dataObj[:jsonfile])
    data = JSON.parse(file)
    @dialogueData = data
    nextSequence
  end

  def nextSequence
    @bubbles = []

    for val in @dialogueData["sequence"]
      if (val["id"] == @id)
        wait = val["wait"] ? val["wait"] : 0
        if (wait == "auto")
          wait = -1
        end
        for bubble in val["bubbles"]
          obj = nil
          # parse source
          source = nil
          case bubble["source"]
          when "player"
            source = @sceneRef.player
          end

          # get wait
          if (bubble["wait"])
            wait = bubble["wait"]
            if (wait == "auto")
              wait = -1
            end
          end

          bubbleDuration = bubble["duration"] ? bubble["duration"] : -1
          case bubble["type"]
          when "normal"
            text = !bubble["text"].nil? ? bubble["text"] : ""
            isMain = bubble["isMain"] ? bubble["isMain"] : false
            obj = Bubble.new(@sceneRef, text, source, val["id"], isMain, duration: bubbleDuration, wait: wait)
            @bubbles.push(obj)
          when "options"
            for i in 0..bubble["choices"].length - 1
              choice = bubble["choices"][i]
              text = !choice["text"].nil? ? choice["text"] : ""
              nextId = choice["nextId"] ? choice["nextId"] : -1
              if (choice["wait"])
                wait = choice["wait"]
              end
              obj = Bubble.new(@sceneRef, text, source, val["id"], false, true, i, nextId, duration: bubbleDuration, wait: wait)
              @bubbles.push(obj)
            end
            #   obj = OptionsDialogue.new(bubble["choices"], source)
          end
        end
        duration = val["duration"] ? val["duration"] : -1
        @timeoutId = val["timeoutId"] ? val["timeoutId"] : @id + 1
        @timer = duration
        return
      end
    end
    endOfDialogue
  end

  def endOfDialogue
    @dialogueData = nil
    @id = 0
    @bubbles = []
    @sceneRef.dialogueMode = false
  end

  def update
    for bubble in @bubbles
      bubble.update
    end
    if (@timer == 0)
      # dialogue time out
      @id = @timeoutId
      if (@id.is_a? String)
        func = @id.to_sym
        send(func)
        endOfDialogue
        return
      end
      nextSequence
    elsif (@timer > 0)
      @timer -= 1
    end
  end

  def draw
    for bubble in @bubbles
      bubble.draw
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

      if (!@bubbles.empty?)
        # do stuff with choices
        for bubble in @bubbles
          if (bubble.isOption and bubble.contains(mouse_x, mouse_y))
            # onNotify({:bubble: bubble},:optionClicked)
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
            nextSequence
          end
        end
      end
    end
  end
end
