require "gosu"
require "matrix"

#REDO THIS TO TAKE IN POLYGONS INSTEAD
def checkCollision(poly1,poly2)
  if (poly1.center[0] - poly2.center[0]).abs > poly1.halfsize[0] + poly2.halfsize[0] || (poly1.center[1] - poly2.center[1]).abs > poly1.halfsize[1] + poly2.halfsize[1]
    return false
  end
  return true
end
#REDO THIS TO TAKE IN POLYGONS INSTEAD
def findOverlap(poly1,poly2)
  if (!poly1 || !poly2)
    return false
  end
  overlap = Vector[0, 0]
  if (poly1.center[0] - poly2.center[0]).abs > poly1.halfsize[0] + poly2.halfsize[0] || (poly1.center[1] - poly2.center[1]).abs > poly1.halfsize[1] + poly2.halfsize[1]
    return false
  end
  overlap = Vector[((poly1.center[0]-poly2.center[0]) <=> 0 )*(poly1.halfsize[0]+poly2.halfsize[0]-(poly1.center[0]-poly2.center[0]).abs),
  ((poly1.center[1]-poly2.center[1]) <=> 0)*(poly1.halfsize[1]+poly2.halfsize[1]-(poly1.center[1]-poly2.center[1]).abs)]
  return overlap
end
