require_relative "./fixedObject"

class FloatObject < FixedObject
  attr_reader :through
  attr_reader :activateFunc

  def initialize(sceneref, x, y, width, height, imgsrc = nil, id = "", activateFunc = "", through = false)
    super
    @z = FLOAT_LAYER
  end

  def update
    @z = FLOAT_LAYER
  end

  def draw_frame(translate, scale)
  end
end
