-- The GameplanGraphics class. 
GameplanGraphics = {}

-- A block for walls. Colors and size
-- @block: Size of block in pixels
function GameplanGraphics.createWall(block)
    local w = gfx.new_surface(block, block)
    w:clear({r=118, g=18, b=36})
    return w
end

-- A block for aisles. Colors and size
-- @block: Size of block in pixles.
function GameplanGraphics.createAisle(block)
    local a = gfx.new_surface(block, block)
    a:clear({r=0, g=0, b=0})
    return a
end

-- A surface for yellow dots. Color and size
-- @psize: Size of yellow dot in pixles
--
function GameplanGraphics.createYellowDot(psize)
    local dot = gfx.new_surface(psize, psize)
    dot:clear({r=222, g=228, b=51})
    return dot
end

-- A function that calculates what the distance from the left border of the cell to where the yellow dot is suppsoed to
-- be painted
-- @block: The size in pixles of one block in the gameplan
-- @dotSize: the wanted size of the dots
function GameplanGraphics.yellowDotOffset(block, dotSize)
  local offset = math.ceil((block - dotSize)/2)
  return offset
end

-- A surface for the door. Color and size
-- @block: Block size in pixles
function GameplanGraphics.createDoor(block) 
  local door = gfx.new_surface(block, math.ceil(block/4))
  door:clear({r=200,g=80,b=51})
  return door
end

-- Load all ghost and pacman pictures at start of pacman for use later
--
function GameplanGraphics.loadSprites()
  sprites = {}
  sprites['pacmanleft0'] = gfx.loadpng("views/pacman/data/pacmanleft0.png")
  sprites['pacmanleft1'] = gfx.loadpng("views/pacman/data/pacmanleft1.png")
  sprites['pacmanup0'] = gfx.loadpng("views/pacman/data/pacmanup0.png")
  sprites['pacmanup1'] = gfx.loadpng("views/pacman/data/pacmanup1.png")
  sprites['pacmandown0'] = gfx.loadpng("views/pacman/data/pacmandown0.png")
  sprites['pacmandown1'] = gfx.loadpng("views/pacman/data/pacmandown1.png")
  sprites['pacmanright0'] = gfx.loadpng("views/pacman/data/pacmanright0.png")
  sprites['pacmanright1'] = gfx.loadpng("views/pacman/data/pacmanright1.png")
  sprites['blinkyleft0'] = gfx.loadpng("views/pacman/data/blinkyleft0.png")
  sprites['blinkyleft1'] = gfx.loadpng("views/pacman/data/blinkyleft1.png")
  sprites['blinkyup0'] = gfx.loadpng("views/pacman/data/blinkyup0.png")
  sprites['blinkyup1'] = gfx.loadpng("views/pacman/data/blinkyup1.png")
  sprites['blinkydown0'] = gfx.loadpng("views/pacman/data/blinkydown0.png")
  sprites['blinkydown1'] = gfx.loadpng("views/pacman/data/blinkydown1.png")
  sprites['blinkyright0'] = gfx.loadpng("views/pacman/data/blinkyright0.png")
  sprites['blinkyright1'] = gfx.loadpng("views/pacman/data/blinkyright1.png")
end

-- 
-- Update direction of player picture depending on direction
--
-- @type player: The player that's supposed to be updated
function GameplanGraphics.updatePlayerRotation(player)     
  if player.type == "pacman" then
    player.picture0 = sprites[player.type..player.direction..'0']
    player.picture1 = sprites[player.type..player.direction..'1']
  else
    player.picture0 = sprites[player.ghostname..player.direction..'0']
    player.picture1 = sprites[player.ghostname..player.direction..'1']
   end
end

-- 
-- Function that change between different pictures (animation) each time a player moves to new cell
--
-- @type: player 
function GameplanGraphics.updatePlayerGraphic(player)
    GameplanGraphics.updatePlayerRotation(player)
    if player.moveanim == 0 then
      player.bg = player.picture0
      player.bg:premultiply()
      player.moveanim = 1
    elseif player.moveanim == 1 then 
      player.bg = player.picture1
      player.bg:premultiply()
      player.moveanim = 0
    end  
end


return GameplanGraphics