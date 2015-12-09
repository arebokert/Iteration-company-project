-- Class: menuclass
-- Serves as a model/logical operator for the showmenuclass.

Menu = {title = "Main Menu"}

-- Creates a new menu object
-- @return obj - the menu object that was created
function Menu:new ()
    obj = {}   -- create object if user does not provide one
    setmetatable(obj, self)
    self.__index = self
    return obj
end

-- function: setOptions(table)
-- Sets the options of the menu.
--
-- @param  options -  a table containing the options to be added to the menu
function Menu:setOptions(options)
    self.options = options
    self.size = #options -- # is the length operator in Lua
    ADLogger.trace("Menu initiated")
end

-- function: setActive(a)
-- Updates the lower menu (considered to be the main menu) when a key is pressed.
-- Reloads pictures accordingly in order to highlight the new active button.
-- Also checks for an internet connection in order to make some features unavailable.
--
-- @param  a - an integer representing which item in the menu to be active
function Menu:setActive(a)
    ADLogger.trace("SET ACTIVE")
    self.active = a

    self.container:clear()

    for i = 1,self.size do
        if (((i == a) and (a ~=3)) or ((i == a) and (a == 3) and (hasInternet==true))) then
			activeButtonPos = self.options[i].buttonPos
            activeButton = gfx.loadpng(self.options[i].button_marked)
            self.options[a].hover()
    		else
    			activeButtonPos = self.options[i].buttonPos
    			activeButton = gfx.loadpng(self.options[i].button)
    		end
    		if ((i ~= a) and (a == 3) and (hasInternet==false)) then
    			activeButtonPos = self.options[i].buttonPos
    			activeButton = gfx.loadpng(self.options[i].button)
    		end
    		if ((i == a) and (a == 3) and (hasInternet==false)) then
    			activeButtonPos = self.options[i].buttonPos
    			activeButton = gfx.loadpng(self.options[i].button)
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

-- function: getActive()
-- Returns the active choice of the mainmenu.
function Menu:getActive()
  return self.active
end

-- function: next()
-- Called by pressing the 'right' key, activates the next menu-choice by calling
-- setActive() with the 'next' parameter.
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

-- function: prev()
-- Mirrors the next()-method, called by pressing the 'left' key.
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

-- function: action()
-- Calls the stored action()-method of the mainmenu's active choice. Most often giving contrl to the submenu
-- loaded by the hover()-method below.
function Menu:action()
    self.options[self.active].action()
end

-- function: hover()
-- Calls the stored hover()-method of the mainmenu's active choice, essentially loading a new submenu
-- upon navigating.
function Menu:hover()
    self.options[self.active].hover()
end

-- function: print()
-- Prints the menu on the screen and updates the view.
--
-- @param container - a surface created in the view, used as a reference here.
-- @param startx - x-parameter used to position elements.
-- @param starty - y-parameter for placing the contents of the menu.
-- @param m - an integer used in the operations required to position buttons.
function Menu:print(container, startx, starty, m)
    ADLogger.trace("Before mainmenu: ")
    if self.container then
      self.container:destroy()
    end
    self.container = container
    margin = m
    width = (container:get_width() - margin*(self.size - 1) - 2*startx)/ self.size
    height = container:get_height() - 2*starty

    for i = 1,self.size do

        opt = self.options[i]

        xpos = startx + (i-1)*width + (i-1)*margin
        ypos = starty

        opt.buttonPos = {x=xpos,y=ypos }
        local temppic = gfx.loadpng(self.options[i].button)
        container:copyfrom(temppic, nil, opt.buttonPos)
        temppic:destroy()
    end

    -- Updating the new container on the appSurface
    if self.containerPos then
        appSurface:copyfrom(container, nil, self.containerPos)
    else
        appSurface:copyfrom(container, nil)
    end
end

-- function:  destroy()
-- Destroys 'self.container' in order to free up the memory used.
function Menu:destroyContainer()
    if self.container then
      self.container:destroy()
    end
end

return Menu