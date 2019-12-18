require "matrix"

class Transfrom
  attr_reader :gameObject
  attr_reader :parent
  attr_accessor :localPosition
  attr_accessor :localrotation
  attr_accessor :localScale
  attr_accessor :localSize
  attr_reader :position
  attr_reader :rotation
  attr_reader :scale
  attr_reader :size

  def initialize(gameObject, position: Vector[0.0, 0.0, 0.0], rotation: Vector[0.0, 0.0, 0.0], scale: Vector[0.0, 0.0, 0.0], size: Vector[0.0, 0.0, 0.0])
    @gameObject = gameObject
    @localPosition = position
    @localRotation = rotation
    @localScale = scale
    @localSize = size
    if !gameObject.parent.nil?
      @position = gameObject.parent.position + @localPosition
      @rotation = gameObject.parent.rotation + @localRotation
      @scale = gameObject.parent.scale.to_matrix() * @localScale
    else
      @position = @localPosition.to_matrix() * @localScale
      @rotation = @localRotation
      @scale = @localScale
    end
    @size = @localScale.to_matrix() * @localSize
  end

  def x
    return position[0]
  end

  def y
    return position[1]
  end

  def z
    return position[2]
  end

  def width
    return size[0]
  end

  def height
    return size[1]
  end

  def halfSize
    return Vector[size[0] / 2, size[1] / 2]
  end

  def left
    return position[0] - halfSize[0]
  end

  def right
    return position[0] + halfSize[0]
  end

  def top
    return position[1] - halfSize[1]
  end

  def bottom
    return position[1] + halfSize[1]
  end

  def lefttop
    return Vector[left, top]
  end

  def leftbottom
    return Vector[left, bottom]
  end

  def righttop
    return Vector[right, top]
  end

  def rightbottom
    return Vector[right, bottom]
  end
end
