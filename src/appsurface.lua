--- Class: appSurface 
-- This class' purpose is to maintain the gfx-memory used by the
-- application. Not entirely implemented.
-- @param appSurface - class-table
-- @param appScreen - global, destructible 'screen'-replica
-- 
appSurface = {title = "appSurface"}
appScreen = nil

--- function: new()
-- Method to instantiate the class.
-- @return obj - the object that was created
function appSurface:new()
    obj = {}
    setmetatable(obj, self)
    self.__index = self
    return obj
end

--- function: createScreen()
-- Sets the parameters for the global appScreen.
function appSurface:createScreen()
    appScreen = gfx.new_surface(screen:get_width(),screen:get_height())
    ADLogger.trace("New appScreen created!")
end

--- function: destroy()
-- Destroys the appScreen, clears the 'screen' and destroys the lower menu-container,
-- to provide a clean slate at certain transitions.
function appSurface:destroy()
    showmenu.destroyContainer()
    mainMenu:destroyContainer()
        
    appScreen:destroy()
    screen:clear()
end

--- function: copyfrom(surface, dest_rect)
-- Replicates the surface:copyfrom-function, simulating an override to
-- implement the class with greater ease (i.e. replace 'screen' with appSurface)
-- 
-- @param surface - surface object to copy elements from
-- @param dest_rect - standard parameter, most often 'nil'
function appSurface:copyfrom(surface, dest_rect)
    screen:clear()
    
    if not surface then
        ADLogger.trace("Method parameter is nil. :copyfrom-FAIL!")
        return
    end
    
    appScreen:copyfrom(surface, nil)
    screen:copyfrom(appScreen, nil)
        
    ADLogger.trace("GFX usage after appScreen-update: " .. getMemoryUsage("gfx"))
    ADLogger.trace("RAM usage after appScreen-update: " .. getMemoryUsage("ram"))
end

--- function: copyfrom(surface, dest_rect, pos)
-- Duplicate copyfrom()-method, overrides the previous.
function appSurface:copyfrom(surface, dest_rect, pos)
    screen:clear()
    
    appScreen:copyfrom(surface, nil, pos)
    screen:copyfrom(appScreen, nil)
        
    ADLogger.trace("GFX usage after appScreen-update: " .. getMemoryUsage("gfx"))
    ADLogger.trace("RAM usage after appScreen-update: " .. getMemoryUsage("ram"))
end

--- function: destroyMenu()
-- Destroys the various menues, if they're not nil. Used while transitioning between
-- different menues and/or starting games in order to free gfx-memory and thus
-- prevent overflows.
function appSurface:destroyMenu()
    if ab then
        ADLogger.trace("Destroying singlePlayerMenu!")
        ab:destroy()
    end
    ADLogger.trace("RAM usage after destroying singlePlayerMenu: " .. getMemoryUsage("ram"))
    ADLogger.trace("GFX usage after destroying singlePlayerMenu: " .. getMemoryUsage("gfx"))
      
    if highScoreSurface then
        ADLogger.trace("Destroying highScoreMenu!")
        highScoreSurface:destroy()
    end
    ADLogger.trace("RAM usage after destroying highScoreMenu: " .. getMemoryUsage("ram"))
    ADLogger.trace("GFX usage after destroying highScoreMenu: " .. getMemoryUsage("gfx"))
  
    if multiMenu then
        ADLogger.trace("Destroying multiPlayerMenu!")
        multiMenu:destroy()
    end
    ADLogger.trace("RAM usage after destroying multiPlayerMenu: " .. getMemoryUsage("ram"))
    ADLogger.trace("GFX usage after destroying multiPlayerMenu: " .. getMemoryUsage("gfx"))
    
end

--- function: get_height()
-- Replicates the surface:get_height()-function and
-- returns the screen's height.
function appSurface:get_height()
    return screen:get_height()
end

--- function: get_width()
-- Replicates the surface:get_width()-function and
-- returns the screen's width.
function appSurface:get_width()
    return screen:get_width()
end

--- function: drawOver(ftype, text)
-- Solution to print text on the appScreen, generally unused.
-- 
-- @param ftype - freetype used to draw
-- @param text - message to be printed
function appSurface:drawOver(ftype, text)
    ftype:draw_over_surface(appScreen, text)
    screen:copyfrom(appScreen, nil)
    gfx.update()
end

--- function: getMemoryUsage()
-- Global, joint function to return a string containing the RAM-state or gfx-usage
-- of the app. Often referred to in ADLogger.trace() throughout the application.
-- 
-- @param type - user request on what memory should be tracked.
function getMemoryUsage(type)
    if type == "gfx" then
      if tonumber(gfx.get_memory_use()) then
          return tonumber(gfx.get_memory_use())/1000000 .. " MB"
      else
          return "none"
      end
    elseif type == "ram" then
      if collectgarbage("count")/1024 then
          return collectgarbage("count")/1024 .. " MB"
      else
          return "none"
      end
    end
end

return appSurface