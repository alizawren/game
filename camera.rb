require "matrix"
require "./constants.rb"

class Camera
  attr_reader :transform

  def initialize
    @transform = Matrix.I(3)
  end

  # expects to have the center of the player and center of bg passed in
  def update(playerX, playerY, bgX, bgY)
    x = (playerX + bgX) / 2
    y = (playerY + bgY) / 2
    @transform = Matrix[[1, 0, CANVAS_WIDTH / 2 - x], [0, 1, CANVAS_HEIGHT / 2 - y], [0, 0, 1]]
  end

  def getTransform
    return @transform
  end
end
