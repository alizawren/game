require_relative "../functions.rb"

class CameraHandler
  def initialize(sceneRef)
    @sceneRef = sceneRef
  end

  def onNotify(dataObj, event)
    case event
    when :focusObjects
      objects = dataObj[:objects]
<<<<<<< HEAD

      if (objects.length > 0)
=======
      if objects.length > 0
>>>>>>> 15e1fd13137d93a29fc97625cc849490d5ec96fe
        @sceneRef.camera.focusObjects = objects
        @sceneRef.camera.state = 2
      end
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
