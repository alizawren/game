require_relative "scenes/dialogue/dialogueHandler.rb"

# an Event listener class. Should be inherited to define methods
class EventHandler
  def initialize(sceneRef)
    @handlers = []
    @sceneRef = sceneRef
  end

  def onNotify(dataObj, event)
    for handler in @handlers
      handler.onNotify(dataObj, event)
    end
  end

  def update
    for handler in @handlers
      handler.update
    end
  end

  def draw
    for handler in @handlers
      handler.draw
    end
  end

  def button_down(id, close_callback)
    for handler in @handlers
      handler.button_down(id, close_callback)
    end
  end

  def addHandler(type)
    case type
    when "dialogue"
      @handlers.push(DialogueHandler.new(@sceneRef))
    end
  end

  def unload
    @handlers = []
  end
end
