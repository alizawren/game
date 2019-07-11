MAX_OBJECTS = 2 # how many objects a node can hold before it splits (initially 10, 2 for testing)
MAX_LEVELS = 5 # deepest level subnode

class Quadtree
  def initialize(plevel, pbounds)
    @level = plevel # current node level
    @objects = []
    @bounds = pbounds # 2D space node occupies
    @nodes = [] # four subnodes of this node
  end

  # recursively clears all objects from all nodes
  def clear
    @objects = []
    for i in 0..@nodes.length
      @nodes.clear
    end
    @nodes = []
  end

  def split
    subWidth = @bounds.width / 2.0
    subHeight = @bounds.height / 2.0
    x = @bounds.x
    y = @bounds.y

    @nodes.push(Quadtree.new(@level + 1, Rectangle.new(x + subWidth, y, subWidth, subHeight)))
    @nodes.push(Quadtree.new(@level + 1, Rectangle.new(x, y, subWidth, subHeight)))
    @nodes.push(Quadtree.new(@level + 1, Rectangle.new(x, y + subHeight, subWidth, subHeight)))
    @nodes.push(Quadtree.new(@level + 1, Rectangle.new(x + subWidth, y + subHeight, subWidth, subHeight)))
  end

  # helper function
  def getIndex(gameObject)
    index = -1
    verticalMidpoint = @bounds.x + (@bounds.width / 2.0)
    horizontalMidpoint = @bounds.y + (@bounds.height / 2.0)

    # Object can completely fit within the top quadrants
    topQuadrant = (gameObject.y < horizontalMidpoint && gameObject.y + gameObject.height < horizontalMidpoint)
    # Object can completely fit within the bottom quadrants
    bottomQuadrant = (gameObject.y > horizontalMidpoint)

    # Object can completely fit within the left quadrants
    if (gameObject.x < verticalMidpoint && gameObject.x + gameObject.width < verticalMidpoint)
      if (topQuadrant)
        index = 1
      elsif (bottomQuadrant)
        index = 2
      end
      # Object can completely fit within the right quadrants
    elsif (gameObject.x > verticalMidpoint)
      if (topQuadrant)
        index = 0
      elsif (bottomQuadrant)
        index = 3
      end
    end

    return index
  end

  def insert(gameObject)
    # if we've already split, insert it anywhere
    if (@nodes.length > 0)
      index = getIndex(gameObject)

      # it goes into the objects of a further node
      if (index != -1)
        @nodes[index].insert(gameObject)
        return
      end
    end

    # otherwise it goes here
    @objects.push(gameObject)

    # if we've hit max objects, split this into new nodes
    if (@objects.size() > MAX_OBJECTS && @level < MAX_LEVELS)
      if (@nodes.length == 0)
        split
      end

      i = 0
      while (i < @objects.length)
        index = getIndex(@objects[i])
        if (index != -1)
          @nodes[index].insert(@objects[i])
          @objects.delete_at(i)
        else
          i += 1
        end
      end
    end
  end

  # Return all objects that could collide with the given object
  def retrieve(gameObject)
    returnObjects = []
    index = getIndex(gameObject)
    if (index != -1 && @nodes.length > 0)
      newobjects = @nodes[index].retrieve(gameObject)
      for obj in newobjects
        returnObjects.push(obj)
      end
    end
    for obj in @objects
      returnObjects.push(obj)
    end

    return returnObjects
  end

  private :getIndex
end
