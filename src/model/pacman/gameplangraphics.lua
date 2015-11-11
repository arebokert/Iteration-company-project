-- The GameplanGraphics class. 
GameplanGraphics = {}


function GameplanGraphics.createWall(block)
    local w = gfx.new_surface(block, block)
    w:clear({r=0, g=0, b=200})
    return w
end


function GameplanGraphics.createAisle(block)
    local a = gfx.new_surface(block, block)
    a:clear({r=0, g=0, b=0})
    return a
end


function GameplanGraphics.createYellowDot(psize)
    local dot = gfx.new_surface(psize, psize)
    dot:clear({r=255, g=255, b=51})
    return dot
end


function GameplanGraphics.yellowDotOffset(block, dotSize)
  local offset = math.ceil((block - dotSize)/2)
  return offset
end


function GameplanGraphics.createDoor(block) 
  local door = gfx.new_surface(block, block)
  door:clear({r=200,g=80,b=51})
  return door
end

return GameplanGraphics

