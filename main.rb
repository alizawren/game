require 'gosu'
require_relative './sceneManager.rb'
require_relative './mainMenu.rb'
require_relative './scene1.rb'

class Main < Gosu::Window 
    def initialize
        super 640, 480
        self.caption = "Game?"

        scene1 = Scene1.new
        menu = MainMenu.new
        SceneManager.changeScene(scene1)
    end

    def update
        SceneManager.update
    end

    def draw
        SceneManager.draw
    end
end

Main.new.show