# see https://rivermanmedia.com/object-oriented-game-programming-the-gui-stack/ for more guistack info

# note: in the future, we may worry about garbage collection and add load/unload functions

module SceneManager
  @guiStack = []
  @scene = nil

  def self.run
    @scene = TitleScene.new
  end

  def self.update(mouse_x, mouse_y)
    if @guiStack.length > 0
      @guiStack[-1].update
    else
      if !@scene.nil?
        @scene.update(mouse_x, mouse_y)
      end
    end
  end

  def self.draw
    # draw all scenes
    if !@scene.nil?
      @scene.draw
    end
    for gui in @guiStack
      gui.draw
    end
  end

  def self.button_down(id, close_callback)
    # only update current scene
    if @guiStack.length > 0
      @guiStack[-1].button_down(id, close_callback)
    else
      if !@scene.nil?
        @scene.button_down(id, close_callback)
      end
    end
  end

  def self.guiPush(gui)
    gui.z = GUI_LAYER + @guiStack.length
    @guiStack.push(gui)
  end

  def self.guiPop
    @guiStack.pop
  end

  def self.clear
    @guiStack.clear
  end

  def self.changeScene(scene)
    @scene = scene
  end

  def self.scene
    @scene
  end
end
