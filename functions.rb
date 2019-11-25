require_relative "./scenes/guis/arsenalGui.rb"

def phoneActivate
  # SceneManager.changeScene(GameScene.new("scenes/scenefiles/scene2.json"))
  SceneManager.scene.eventHandler.onNotify({ jsonfile: "dialogues/phone2.json" }, :createDialogue)
end

def objActivate
  currScene = SceneManager.scene
  currScene.eventHandler.onNotify({ jsonfile: "dialogues/level1.json" }, :createDialogue)
end

def poolActivate
  # SceneManager.createDialogue("dialogues/pool.json")
  currScene = SceneManager.scene
  currScene.eventHandler.onNotify({ jsonfile: "dialogues/pool.json" }, :createDialogue)
end

def arsenalActivate
  # create a GUI for the arsenal
  SceneManager.guiPush(ArsenalGui.new)
  # currScene = SceneManager.getCurrentScene
  # currScene.eventHandler.onNotify({}, :guiOpen)
end

def startLevel
  SceneManager.changeScene(GameScene.new("scenes/scenefiles/scene2.json"))
end

def gameOver
  SceneManager.changeScene(MainMenu.new)
end

def aerConvo
  SceneManager.scene.eventHandler.onNotify({ jsonfile: "dialogues/aer.json" }, :createDialogue)
end
