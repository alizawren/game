# require_relative "../../eventHandler.rb"
require_relative "./bubble.rb"
# require_relative "./optionsDialogue.rb"

class DialogueHandler
  attr_reader :active

  def initialize(sceneRef)
    @active = false
    @sceneRef = sceneRef

    @timer = -1
    @timeoutId = -1

    @dialogueData = nil
    @id = 0
    @dialogues = []
  end

  def onNotify(dataObj, event)
    case event
    when :createDialogue
      createDialogue(dataObj)
      @active = true
    when :dialogueTimeOut
    else
    end
  end

  def createDialogue(dataObj)
    file = File.read(dataObj[:jsonfile])
    data = JSON.parse(file)
    @dialogueData = data
    nextSequence
  end

  def nextSequence
    @dialogues = []
    for val in @dialogueData["sequence"]
      if (val["id"] == @id)
        for dialogue in val["bubbles"]
          obj = nil
          # parse source
          source = nil
          case dialogue["source"]
          when "player"
            source = @sceneRef.player
          end

          case dialogue["type"]
          when "normal"
            text = !dialogue["text"].nil? ? dialogue["text"] : ""
            wait = dialogue["wait"] ? dialogue["wait"] : 0
            obj = Bubble.new(@sceneRef, text, source, val["id"], wait: wait)
            @dialogues.push(obj)
          when "options"
            wait = dialogue["wait"] ? dialogue["wait"] : 0
            for i in 0..dialogue["choices"].length - 1
              choice = dialogue["choices"][i]
              text = !choice["text"].nil? ? choice["text"] : ""
              nextId = choice["nextId"] ? choice["nextId"] : -1
              if (choice["wait"])
                wait = choice["wait"]
              end
              obj = Bubble.new(@sceneRef, text, source, val["id"], true, i, nextId, wait: wait)
              @dialogues.push(obj)
            end
            #   obj = OptionsDialogue.new(dialogue["choices"], source)
          end
        end
        duration = val["duration"] ? val["duration"] : -1
        @timeoutId = val["timeoutId"]
        @timer = duration
        return
      end
    end
    @active = false
  end

  def update
    for dialogue in @dialogues
      dialogue.update
    end
    if (@timer == 0)
      # dialogue time out
      @id = @timeoutId
      nextSequence
    elsif (@timer > 0)
      @timer -= 1
    end
  end

  def draw
    for dialogue in @dialogues
      dialogue.draw
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

      if (!@dialogues.empty?)
        # do stuff with choices
        for dialogue in @dialogues
          #   if (dialogue.is_a?(OptionsDialogue) and dialogue.contains(@sceneRef.cameratransform, mouse_x, mouse_y))
          #     @dialogues = []
          #     @active = false
          #   end
          if (dialogue.isOption and dialogue.contains(mouse_x, mouse_y))
            # onNotify({:dialogue: dialogue},:optionClicked)
            # @dialogues = []
            # @active = false
            if (dialogue.nextId < 0)
              @id += 1
            else
              @id = dialogue.nextId
            end
            nextSequence
          end
        end
      end

      # might want to repurpose the below code

      #   for interactable in @objects["fixed"]
      #     if interactable.contains(@cameratransform, @mouse_x, @mouse_y)
      #       interactable.activate
      #       return
      #     end
      #   end

      #   if (@type == "gamescene")
      #     old_pos = @cameratransform.inverse * Vector[@crosshair.x, @crosshair.y, 1]
      #     # old_pos = Vector[@crosshair.x, @crosshair.y]
      #     bullet = Bullet.new(self, @player.center, (Vector[old_pos[0], old_pos[1]] - @player.center).normalize * BULLET_SPEED)
      #     @objects["projectiles"].push(bullet)
      #   end
    end
  end
end
