---- Coords -----
---- Absolute position starts at (1,1)
---- Relative position starts at (0,0)
---- Cell grid position starts at (1,1)  

require("model.pacman.dumper")
require("model.pacman.collisionhandler")
GameplanGraphics = require("model.pacman.gameplangraphics")

-- Define a shortcut function for testing
function dump(...)
    print(DataDumper(...), "\n---")
end


-- The Gameplan class. 
Gameplan = {}


--
-- Create an instance of a gameplan. 
--
function Gameplan:new ()
    obj = {}   -- create object if user does not provide one
    setmetatable(obj, self)
    self.__index = self
    return obj
end


--
-- Load the pacman map. 
--
function Gameplan:loadMap(map)
    -- If map is not specified, default is "map1.txt"
    if map == nil then
      map = 'map1.txt'
    end
    
    -- The map file
    local filename = root_path .. 'model/pacman/' .. map
    local file = io.open(filename, "r")
    local tabellines = {}
    local i = 0
    
    -- Read the map-file and save to an ixj-array. If no file is found, return false. 
    if file then
        for line in file:lines() do
            i = i + 1
            tabellines[i] = line
        end
        io.close(file)
    else
        error('file not found')
        -- No file found, return false. 
        return false
    end
    
    self.map = tabellines
    self.ycells = i
    self.xcells = string.len(tabellines[1])
    -- File is saved to a table, return true. 
    return true
end



-- 
-- Function to add a player to a gameplan. 
--
function Gameplan:addPlayer(player)
    if self.players == nil then
        self.players = {}
    end
    table.insert(self.players, player)
end


--
-- Set direction of pacman. Obs! Hardcoded as player 1, needs to be adjusted. 
--
function Gameplan:setPacmanDirection(dir)
    pacman_direction = dir
    self.players[1].direction = dir
end


-- Print a yellow dot to a cell
--@param cell: The cell-value in cell coordiantes
function Gameplan:printYellowDot(cell)
    local dotoffset = math.ceil((self.block - self.dsize)/2)  
    local dotpos = {x = (cell.x-1)*self.block + dotoffset, y = (cell.y-1)*self.block + dotoffset}--position of yellow dot
    local absPos = self:relativeToAbsolutePosition(dotpos.x, dotpos.y)
    screen:copyfrom(background["d"], nil, absPos) --print yellow dot
end


function Gameplan:displayMap(container, map)
    self.logicalMap = {}
    map = self.map
    container_width = 1000
    container_height = 600
    container = gfx.new_surface(container_width, container_height)
    self.containerpos = {x = 140, y = 60}


    self.block = container_width / self.xcells
    self.dsize = math.ceil(self.block / 7)

    background = {}
    -- 1 <=> wall
    background["1"] = GameplanGraphics.createWall(self.block)
    -- 0 <=> aisle
    background["0"] = GameplanGraphics.createAisle(self.block)
    -- 0 <=> yellow dot
    background["d"] = GameplanGraphics.createYellowDot(self.dsize)

    for key, value in pairs(map) do
        collectgarbage()
        self.logicalMap[key] = {}
        for i = 1, #value do
            
              local pos = {x = (i-1)*self.block, y = (key-1)*self.block }
              local dotoffset = math.ceil((self.block - self.dsize)/2)
              local dotpos = {x = (i-1)*self.block + dotoffset, y = (key-1)*self.block + dotoffset}--position of yellow dot
              local c = value:sub(i,i)
            if c == "1" or c == "0" then
                container:copyfrom(background[c], nil, pos)
                if c == "0" then
                  container:copyfrom(background["d"], nil, dotpos) --print yellow dot
                end
            elseif c == "D" then
              self:paintdoor({x=i, y=key})
            elseif c == "S" then
                -- STARTPOSITION
                pacman = Player:new("pacman")   -- Initiate object
                -- Start position for pacman
                pacman:setPos(pos.x, pos.y)
                pacman.bg = gfx.new_surface(self.block,self.block)
                --pacman.bg:clear({r=255,g=255,b=51})
                pacman.bg = gfx.loadpng('views/pacman/data/pacman25px.png')
                -- BAD SOLUTION!!!
                container:copyfrom(background["0"], nil, pos)
                pacman.bg:premultiply()
                container:copyfrom(pacman.bg, nil, pacman:getPos())
                pacman.direction = "right"
                self:addPlayer(pacman)
            elseif c == "B" then
                -- BAD SOLUTION!!!
                blinky = Player:new("ghost")
                blinky:setPos(pos.x, pos.y)
                blinky.bg = gfx.new_surface(self.block,self.block)
                -- blinky.bg:clear({r=0,g=255,b=51})
                blinky.bg = gfx.loadpng('views/pacman/data/ghost25.png')
                container:copyfrom(background["0"], nil, pos)
                blinky.bg:premultiply()
                container:copyfrom(blinky.bg, nil, blinky:getPos())
                blinky.direction = "left"
                self:addPlayer(blinky)
            end
            self.logicalMap[key][i] = c
        end
        -- Instantiates a matrix representing which cells have yellow dots
        --yellowdotmatrix = {}
        --yellowdotmatrix = yellowDotStatus(map)

    end
    yellowdotmatrix = yellowDotStatus(map)
    screen:copyfrom(container, nil, self.containerpos)

    -- Update GFX
    gfx.update()
end

function Gameplan:paintdoor(cell) 
  door = gfx.new_surface(self.block,self.block)
  door:clear({r=200,g=80,b=51})
  screen:copyfrom(door, nil, self:cellToXY(cell))
end


function Gameplan:repaint(player, oldPos)
    if oldPos == nil then
        return false
    end
    local absOldPos = self:relativeToAbsolutePosition(oldPos.x,oldPos.y)
    screen:copyfrom(background["0"], nil, absOldPos)

    if player.type ~= "pacman" then
        -- If player not pacman, print yellow dot.
        local cell = self:xyToCell(oldPos.x, oldPos.y)
        if player.direction == "left" then
            cell = self:xyToCell(oldPos.x + self.block -1, oldPos.y)
        elseif player.direction == "up" then
            cell = self:xyToCell(oldPos.x, oldPos.y + self.block -1)
        end
        if checkDotStatus(cell) == true then
          self:printYellowDot(cell)
        end  
    end

    local absPos = self:relativeToAbsolutePosition(player:getPos().x,player:getPos().y)
    screen:copyfrom(player.bg, nil, absPos)
    gfx.update()
end


function Gameplan:relativeToAbsolutePosition(x, y)
    local pos = {}
    pos.x = x + self.containerpos.x
    pos.y = y + self.containerpos.y
    return pos
end


function Gameplan:checkMap(cell)
    return self.logicalMap[cell.y][cell.x]
end


function Gameplan:cellToXY(cell)
    local x = (cell.x-1) * self.block
    local y = (cell.y-1) * self.block
    local pos = {x=x, y=y}
    return pos
end


function Gameplan:xyToCell(x,y)
    -- RELATIVE COORDINATES
    local xcell = math.ceil( (x+1)/self.block )
    local ycell = math.ceil( (y+1)/self.block )
    local pos = {x=xcell, y=ycell}
    return pos
end

function Gameplan:possibleMovement(direction, new_pos)
    local target = {}
    target.x = new_pos.x
    target.y = new_pos.y

    local new_cell = self:xyToCell(target.x, target.y)
    local new_cell2 = self:xyToCell(target.x, target.y)

    if direction == "right" then
        new_cell = self:xyToCell(target.x + self.block - 1, target.y)
        new_cell2 = self:xyToCell(target.x + self.block - 1, target.y + self.block - 1 )
    elseif direction == "down" then
        new_cell = self:xyToCell(target.x, target.y + self.block -1)
        new_cell2 = self:xyToCell(target.x + self.block - 1, target.y + self.block - 1 )
    elseif direction == "left" then
        new_cell = self:xyToCell(target.x, target.y)
        new_cell2 = self:xyToCell(target.x, target.y + self.block - 1 )
    elseif direction == "up" then
        new_cell = self:xyToCell(target.x, target.y)
        new_cell2 = self:xyToCell(target.x + self.block -1, target.y)
    end

    local new_cell_content = self:checkMap(new_cell)
    local new_cell2_content = self:checkMap(new_cell2)

    if new_cell_content ~= "1" and new_cell2_content ~= "1" then
        return true
    else
        return false
    end
end

function Gameplan:getPossibleMovements(position)
    local directions = {left = false, right = false, up = false, down = false}
    local pos = {}
    pos.x = position.x
    pos.y = position.y
    local step = 5
    for k, v in pairs(directions) do
        if k == "left" then
            pos.x = position.x - step
        elseif k == "right" then
            pos.x = position.x + step
        elseif k == "up" then
            pos.y = position.y + step
        elseif k == "down" then
            pos.y = position.y - step
        end
        directions[k] = self:possibleMovement(k, pos)
    end

    return directions
end



function Gameplan:refresh()

    for k,player in pairs(self.players) do
        local new_pos = player:movement()


        if player.type ~= "pacman" then
            local dir = self:getPossibleMovements(player:getPos())
        end

        -- New cell is an aisle, OK!
        if self:possibleMovement(player.direction, new_pos) == true then
            local oldPos = player:getPos()
            player:setPos(new_pos.x, new_pos.y)
            self:repaint(player, oldPos)
            if player.type == "pacman" then
               updateDotStatus(self:xyToCell(new_pos.x,new_pos.y))
            end
        end
        if self:possibleMovement(player.direction, new_pos) == false  then
            -- New cell is a wall, not ok!
            if player.type ~= "pacman" then
                player:Randomdirection()
            end
        end
    end

    return not checkCollision(self.players[1],self.players[2])
end



function Gameplan:dumpPlayerPos()
    -- dump(self.players)
    for k,player in pairs(self.players) do
        local pos = player:getPos()
        ADLogger.trace("PLAYERS:")
        dump(pos)
        local absPos = self:relativeToAbsolutePosition(pos.x, pos.y)
        dump(absPos)
        local cell = self:xyToCell(pos.x, pos.y)
        dump(cell)
        ADLogger.trace("END PLAYER")
    end
end


-- Creates a matrix that describes if a cell has a yellow dot or not 
--  True means that it has a yellow dot
-- Should be run when map is instantiated
function yellowDotStatus(map)
    dotmatrix = {}
    for key, value in pairs(map) do
        dotmatrix[key] = {}
        for i = 1, #value do
            local c = value:sub(i,i)
            if c == "0" then
                dotmatrix[key][i] = true
            else
                dotmatrix[key][i] = false
            end
        end
    end
    return dotmatrix
end

-- Updates cells to not have a yellow dot
function updateDotStatus(pos)
    yellowdotmatrix[pos.y][pos.x] = "false"
end

-- Checks if a cell has a yellow dot
function checkDotStatus(pos)
    return yellowdotmatrix[pos.y][pos.x]
end

return Gameplan
