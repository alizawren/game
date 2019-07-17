require "matrix"
require "./constants.rb"

class Camera
  attr_reader :transform

  def initialize
    @transform = Matrix.I(3)
  end

  # expects to have the center of the player and center of bg passed in
  def update(playerCenter, bgCenter)
    # x = (playerX + bgX) / 2
    # y = (playerY + bgY) / 2
    pos = (playerCenter + bgCenter) / 2
    @transform = Matrix[[1, 0, CANVAS_WIDTH / 2 - pos[0]], [0, 1, CANVAS_HEIGHT / 2 - pos[1]], [0, 0, 1]]
  end
end
