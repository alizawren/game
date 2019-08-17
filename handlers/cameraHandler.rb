require_relative "../functions.rb"

class CameraHandler
  def initialize(sceneRef)
    @sceneRef = sceneRef
  end

  def onNotify(dataObj, event)
    case event
    when :focusObjects
      objects = dataObj[:objects]

      @sceneRef.camera.focusObjects = objects
      @sceneRef.camera.state = 2
      # TODO: state should be 1, a transition state
    when :dialogueEnded
      @sceneRef.camera.state = 0
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
