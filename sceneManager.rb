# require_relative './scene.rb'

class SceneManager
    def self.initialize
        @currScene = nil;
    end

    def self.update
        if (!@currScene.nil?)
            @currScene.update
        end
    end

    def self.draw
        if (!@currScene.nil?)
            @currScene.draw
        end
    end
    
    def self.button_down(id)
        if (!@currScene.nil?)
            @currScene.button_down(id)
        end
    end

    def self.changeScene(newScene)
        if (!@currScene.nil?) 
            @currScene.unload()
        end
        newScene.load()
        @currScene = newScene
    end

end