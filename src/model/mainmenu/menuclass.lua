Menu = {title = "Main Menu"}

-- Creates a new menu object
-- @return obj - the menu object that was created
function Menu:new ()
    obj = {}   -- create object if user does not provide one
    setmetatable(obj, self)
    self.__index = self
    return obj
end

-- Sets the options of the menu
-- @param  options -  a table containing the options to be added to the menu
function Menu:setOptions(options)
    self.options = options
    self.size = #options -- # is the length operator in Lua
    ADLogger.trace("Menu initiated")
end

-- Loads a highscore-table from file, if it does not exist it returns an empty (new) table.
-- @param  a - an integer representing which item in the menu to be active
function Menu:setActive(a)
    ADLogger.trace("SET ACTIVE")
    self.active = a

    self.container:clear()

    for i = 1,self.size do
        if (((i == a) and (a ~=3)) or ((i == a) and (a == 3) and (hasInternet==true))) then
			activeButtonPos = self.options[i].buttonPos
            activeButton = gfx.loadpng(self.options[i].button_marked)
            activeButton:premultiply()
            self.options[a].hover()
    		else
    			activeButtonPos = self.options[i].buttonPos
    			activeButton = gfx.loadpng(self.options[i].button)
    			activeButton:premultiply()
    		end
    		if ((i ~= a) and (a == 3) and (hasInternet==false)) then
    			activeButtonPos = self.options[i].buttonPos
    			activeButton = gfx.loadpng(self.options[i].button)
    			activeButton:premultiply()
    		end
    		if ((i == a) and (a == 3) and (hasInternet==false)) then
    			activeButtonPos = self.options[i].buttonPos
    			activeButton = gfx.loadpng(self.options[i].button)
    			activeButton:premultiply()
    			a = a+1
    		end
        self.container:copyfrom(activeButton, nil , activeButtonPos)
        activeButton:destroy()
    end

    -- Updating the new container on the appSurface
    if self.containerPos then
        appSurface:copyfrom(self.container, nil, self.containerPos)
    else
        appSurface:copyfrom(self.container, nil)
    end
    
    gfx.update()
end

function Menu:getActive()
  return self.active
end

function Menu:next()
    local next = self.active + 1
	if ((next == 3) and (hasInternet==false)) then
		next = next+1
	end
    if (self.active + 1) > self.size then
        next = 1
    end

    self:setActive(next)
end

function Menu:prev()
    local prev = self.active - 1
    if ((prev == 3) and (hasInternet==false)) then
		prev = prev-1
	end
	if self.active - 1 < 1 then
        prev = self.size
    end

    self:setActive(prev)
end

function Menu:action()
    self.options[self.active].action()
end

function Menu:hover()
    self.options[self.active].hover()
end

function Menu:printSub(container)
    self.container = container
    width = container:get_width()
    height = container:get_height()
    appSurface:copyfrom(container, nil, self.containerPos)
end

function Menu:print(container, startx, starty, m)
    ADLogger.trace("BP 1")
    ADLogger.trace("Before mainmenu: ")
    if self.container then
      self.container:destroy()
    end
    self.container = container
    ADLogger.trace("BP 2")
    margin = m
    ADLogger.trace("BP 3")
    width = (container:get_width() - margin*(self.size - 1) - 2*startx)/ self.size
    ADLogger.trace("BP 4")
    height = container:get_height() - 2*starty
    ADLogger.trace("BP 5")

    for i = 1,self.size do

        opt = self.options[i]

        xpos = startx + (i-1)*width + (i-1)*margin
        ypos = starty

        opt.buttonPos = {x=xpos,y=ypos }
        local temppic = gfx.loadpng(self.options[i].button)
        temppic:premultiply()
        container:copyfrom(temppic, nil, opt.buttonPos)
        temppic:destroy()
        --collectgarbage()
    end

    -- Updating the new container on the appSurface
    if self.containerPos then
        appSurface:copyfrom(container, nil, self.containerPos)
    else
        appSurface:copyfrom(container, nil)
    end
end

function Menu:destroyContainer()
    if self.container then
      self.container:destroy()
    end
end

return Menu