# when making scenes, implement each of the below methods
class Scene 

    # necessary methods
    def update
    end

    def draw
    end

    def load
        # load all of the data and graphics that this scene needs to function.
    end
    def unload
        # unload everything that the garbage collector won’t unload, itself, including graphics
    end

    def button_down(id,close_callback)
    end

    # optional methods
    def transitionIn
    end

    def transitionOut
    end
end