-- The GameplanGraphics class. 
GameplanGraphics = {}

-- A block for walls. Colors and size
function GameplanGraphics.createWall(block)
    local w = gfx.new_surface(block, block)
    w:clear({r=0, g=0, b=150})
    return w
end

-- Gameover screen to be loaded when all lives is run out
function GameplanGraphics.gameOver()
    local gameOver = gfx.loadpng('views/pacman/data/gameover.png')
    screen:copyfrom(gameOver, nil,{x=450, y=250})
    Score.printScore({x=620,y=400})
    gfx.update()
 -- gameOver:destroy() 
end


-- A block for aisles. Colors and size
function GameplanGraphics.createAisle(block)
    local a = gfx.new_surface(block, block)
    a:clear({r=0, g=0, b=0})
    return a
end

-- A surface for yellow dots. Color and size
function GameplanGraphics.createYellowDot(psize)
    local dot = gfx.new_surface(psize, psize)
    dot:clear({r=222, g=228, b=51})
    return dot
end

-- A function that calculates what the distance from the left border of the cell to where the yellow dot is suppsoed to
-- be painted
function GameplanGraphics.yellowDotOffset(block, dotSize)
  local offset = math.ceil((block - dotSize)/2)
  return offset
end

-- A surface for the door. Color and size
function GameplanGraphics.createDoor(block) 
  local door = gfx.new_surface(block, math.ceil(block/4))
  door:clear({r=200,g=80,b=51})
  return door
end



-- 
-- Update direction of player picture depending on direction
--
-- @type: player 
function GameplanGraphics.updatePlayerRotation(player)       
  if player.type == "pacman" then
    player.picture0 = 'views/pacman/data/'..player.type..player.direction..'0'..'.png'
    player.picture1 = 'views/pacman/data/'..player.type..player.direction..'1'..'.png'
  else
    player.picture0 = 'views/pacman/data/'..player.ghostname..player.direction..'0'..'.png'
    player.picture1 = 'views/pacman/data/'..player.ghostname..player.direction..'1'..'.png'
   end
end

-- 
-- Function that change between different pictures (animation) each time a player moves to new cell
--
-- @type: player 
function GameplanGraphics.updatePlayerGraphic(player)
    GameplanGraphics.updatePlayerRotation(player)
    if player.moveanim == 0 then
      player.bg = gfx.loadpng(player.picture0)
      player.moveanim = 1
    elseif player.moveanim == 1 then 
      player.bg = gfx.loadpng(player.picture1)
      player.moveanim = 0
    end  
end


return GameplanGraphics