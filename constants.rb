require "gosu"

#canvas constants
CANVAS_WIDTH = 1280
CANVAS_HEIGHT = 720

# gui constants
FONT_TYPE = "fonts/fixedsys.ttf"
FONT_HEIGHT = 24
MARGIN = 12

#game constants
BULLET_SPEED = 20
# layers
SHADOW_LAYER = 2
PLAYER_LAYER = 3
ENEMY_LAYER = 3
PLAYER_ARM_LAYER = 4
ABOVE_PLAYER = 5
BELOW_PLAYER = 1
BG_LAYER = 0
PARALLAX_LAYER = -1000
CROSSHAIR_LAYER = 200
TEXT_LAYER = 100

OPAQUE = Gosu::Color::WHITE
SHADOW_COLOR = Gosu::Color.new(128, 255, 255, 255)

BUBBLE_COLOR = Gosu::Color::BLUE
BUBBLE_COLOR_OPTION = Gosu::Color::GREEN
BUBBLE_PADDING = 5
BUBBLE_OFFSET_X = 40
BUBBLE_OFFSET_Y = -100
DEFAULT_BUBBLE_WIDTH = 400
DEFAULT_OPTION_BUBBLE_WIDTH = 800
