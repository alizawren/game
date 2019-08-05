require_relative "../../eventHandler.rb"
require_relative "./normalDialogue.rb"
require_relative "./optionsDialogue.rb"

class DialogueHandler < EventHandler
  attr_reader :active

  def initialize(sceneRef)
    @active = false
    @sceneRef = sceneRef
    @dialogues = []
  end

  def onNotify(dataObj, event)
    case event
    when :createDialogue
      createDialogue(dataObj)
      @active = true
    else
    end
  end

  def createDialogue(dataObj)
    file = File.read(dataObj[:jsonfile])
    data = JSON.parse(file)

    for val in data["sequence"]
      for dialogue in val["dialogues"]
        obj = nil
        # parse source
        source = nil
        case dialogue["source"]
        when "player"
          source = @sceneRef.player
        end

        case dialogue["type"]
        when "normal"
          obj = NormalDialogue.new(dialogue["text"], source, @sceneRef.cameratransform)
          @dialogues.push(obj)
        when "options"
          for i in 0..dialogue["choices"].length - 1
            choice = dialogue["choices"][i]
            obj = NormalDialogue.new(choice, source, @sceneRef.cameratransform, true, i: i)
            @dialogues.push(obj)
          end
          #   obj = OptionsDialogue.new(dialogue["choices"], source)
        end
      end
    end
  end

  def update
    for dialogue in @dialogues
      dialogue.update(@sceneRef.cameratransform)
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
            @dialogues = []
            @active = false
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
