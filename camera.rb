require "matrix"
require "./constants.rb"

class Camera
  # attr_reader :transform
  attr_reader :pos
  attr_reader :scale
  attr_accessor :state
  attr_accessor :focusObjects

  def initialize(scale, playerCenter)
    # @transform = Matrix.I(3)
    @pos = playerCenter
    @scale = scale
    # 0 for default (avg of player and bg), 1 for follow path (transition), 2 for focus on objects
    @state = 1
    @path = []
    for i in 0..4
      @path.push(Vector[500,500])
    end
    @focusObjects = []
    @t = 0
  end

  def setPos(playerCenter, mouse)
    # get a new position
    playerPos = playerCenter * @scale + @pos
    position = (playerPos + mouse) / 2
    # position = mouse

    if (@path.length >= 5) 
        @path[4] = position;
    else
      while @path.length < 5
        @path.push(position)
      end
    end
  end

  def basis(i,t)
    case i
    when -2
      return (((-t + 3) * t - 3) * t + 1) / 6
    when -1
      return (((3 * t - 6) * t) * t + 4) / 6
    when 0
      return (((-3 * t + 3) * t + 3) * t + 1) / 6
    when 1
      return (t * t * t) / 6
    else 
      return 0
    end
  
  end


  # expects to have the center of the player and center of bg passed in
  #scale rotate then  translate
  def update(playerCenter, mouse)
    case @state
    when 0 # default, average of player and bg.
      # note, player's coordinates are in world while mouse are in camera, so we transform player
      # NOTE: right now there is jumpiness!!!!
      playerPos = playerCenter * @scale + @pos
      @pos = (playerPos + mouse) / 2
    when 1 # interpolates with bspline

      @t += 0.8;
      if(@t >= 1)
        while (@t >= 1)
            @t -= 1;
        end
        if (@path.length > 1)
          @path.shift
        end
        while(@path.length < 5)
          @path.push(@path[-1])
        end
      end
     
      if (@path.length < 3) 
        return
      end
      
      # @pos = (1 - @t) ** 2 * @path[0] + 2 * (1 - @t) * @t * @path[1] + @t ** 2 * @path[2] 
      @pos = Vector[0,0]
      for i in -2..1
        point = @path[i + 2];
        @pos[0] += point[0] * basis(i,@t)
        @pos[1] += point[1] * basis(i,@t)
      end
    when 2 # focus on average of objects
      avgVec = Vector[0, 0]
      for obj in @focusObjects
        avgVec += obj.center
      end
      avgVec /= @focusObjects.length
      @pos = avgVec * @scale
    end

    # make sure our specified position is placed at the center of the canvas
    @pos = Vector[@pos[0] - (CANVAS_WIDTH / 2), @pos[1] - (CANVAS_HEIGHT / 2)]
  end
end
