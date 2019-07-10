require 'gosu'
require_relative './sceneManager.rb'
require_relative './mainMenu.rb'
require_relative './scene1.rb'

class Main < Gosu::Window 
    def initialize
        super 1280, 720 
        self.caption = "Game?"

        @scene1 = Scene1.new
        @menu = MainMenu.new
        SceneManager.changeScene(@menu)
    end

    def update
        SceneManager.update
    end

    def draw
        SceneManager.draw
    end

    def button_down(id)
        SceneManager.button_down(id)

        if id == Gosu::KB_ESCAPE
          SceneManager.changeScene(@menu)
        else
          super
        end
    end
end

Main.new.show