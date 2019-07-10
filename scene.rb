# when making scenes, implement each of the below methods
class Scene 
    def initialize
    end

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

    # optional methods
    def transitionIn
    end

    def transitionOut
    end
end