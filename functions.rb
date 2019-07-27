def phoneActivate
  SceneManager.changeScene(GameScene.new("scenes/scenefiles/scene2.json"))
end

def objActivate
  puts "object clicked"
end

def poolActivate
  SceneManager.createDialogue("dialogues/pool.json")
end
