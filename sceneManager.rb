# see https://rivermanmedia.com/object-oriented-game-programming-the-gui-stack/ for more guistack info

class SceneManager
  @@guiStack = [] # only use push/pop methods bruh
  @@currScene = nil

  # def self.initialize
  #   @currScene = nil
  # end

  def self.update(mouse_x, mouse_y)
    if (!@@currScene.nil?)
      @@currScene.update(mouse_x, mouse_y)
    end
    #we're only updating the last gui????
    # yes
    if (@@guiStack.length > 0)
      @@guiStack[-1].update
    end
  end

  def self.draw
    if (!@@currScene.nil?)
      @@currScene.draw
    end
    for gui in @@guiStack
      gui.draw
    end
  end

  def self.guiPush(gui)
    gui.z = GUI_LAYER + @@guiStack.length
    @@guiStack.push(gui)
  end

  def self.guiPop
    @@guiStack.pop()
    if (!@@currScene.nil? and @@guiStack.length == 0)
      @@currScene.eventHandler.onNotify({}, :guiClose)
    end
  end

  def self.guiClear
    @@guiStack = []
    if (!@@currScene.nil? and @@currScene.is_a?(GameScene))
      @@currScene.eventHandler.onNotify({}, :guiClose)
    end
  end

  def self.button_down(id, close_callback)
    if (!@@currScene.nil?)
      @@currScene.button_down(id, close_callback)
    end
    if (@@guiStack.length > 0)
      @@guiStack[-1].button_down(id, close_callback)
    end
  end

  def self.changeScene(newScene)
    if (!@@currScene.nil?)
      @@currScene.unload()
    end
    newScene.load()
    @@currScene = newScene
  end

  def self.restartScene
    if (!@@currScene.nil?)
      @@currScene.unload()
      @@currScene.load()
    end
  end

  def self.getCurrentScene
    return @@currScene
  end

  # def self.createDialogue(param)
  #   @currScene.createDialogue(param)
  # end
end
