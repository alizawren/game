require "matrix"
require "./constants.rb"

class Camera
  attr_reader :transform
  attr_reader :pos
  attr_accessor :state
  attr_accessor :focusObjects

  def initialize
    @transform = Matrix.I(3)
    @pos = nil
    # 0 for default (avg of player and bg), 1 for follow path (transition), 2 for focus on objects
    @state = 0
    @path = []
    @focusObjects = []
    @t = 0
  end

  # expects to have the center of the player and center of bg passed in
  #scale rotate then  translate
  def update(playerCenter, bgCenter)
    case @state
    when 0 # default, average of player and bg. (TODO: Take mouse into account... we don't actually care that much about the bg)
      @pos = (playerCenter + bgCenter) / 2
    when 1 # follow a path to focus on objects
      # TODO: not working yet, don't set state to 1
      if @t >= 1
        @state = 2
      else
        @t += 0.06
        newVec = (1 - @t) ** 2 * @path[0] + 2 * (1 - @t) * @t * @path[1] + @t ** 2 * @path[2]
        @pos = Vector[newVec[0], newVec[1]]
      end
    when 2 # focus on average of objects
      avgVec = Vector[0, 0]
      for obj in @focusObjects
        avgVec += obj.center
      end
      avgVec /= @focusObjects.length
      @pos = avgVec
    end

    @transform = Matrix[[1, 0, CANVAS_WIDTH / 2 - @pos[0]], [0, 1, CANVAS_HEIGHT / 2 - @pos[1]], [0, 0, 1]] * Matrix[[1, 0, 0], [0, 1, 0], [0, 0, 1]]
  end

  # def transform(vector)
  #   return @transform * vector
  # end
  # def rtransform(vector)
  #   return @transform.inverse * vector
  # end
end
