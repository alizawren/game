require_relative "../functions.rb"

class GuiHandler
  def initialize(sceneRef)
    @sceneRef = sceneRef
  end

  def onNotify(dataObj, event)
    case event
    when :guiOpen
      @sceneRef.guiMode = true
    when :guiClose
      @sceneRef.guiMode = false
    end
  end

  def update
  end

  def draw
  end

  def button_down(id, close_callback)
    case id
    when Gosu::MS_LEFT
    end
  end
end
