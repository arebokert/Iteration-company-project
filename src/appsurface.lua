-- Custom, destructible surface.

appSurface = {title = "appSurface"}
appScreen = nil
-- Creates a new menu object
-- @return obj - the menu object that was created
function appSurface:new()
    obj = {}
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function appSurface:createScreen()
    appScreen = gfx.new_surface(screen:get_width(),screen:get_height())
    ADLogger.trace("New appScreen created!")
    ADLogger.trace("GFX usage after appScreen creation: " .. getMemoryUsage("gfx"))
    ADLogger.trace("RAM usage after appScreen creation: " .. getMemoryUsage("ram"))
end

function appSurface:destroy()
    appScreen:destroy()
    screen:clear()
    appSurface:createScreen()
end

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

function appSurface:copyfrom(surface, dest_rect, pos)
    appScreen:copyfrom(surface, nil, pos)
    screen:copyfrom(appScreen, nil)
        
    ADLogger.trace("GFX usage after appScreen-update: " .. getMemoryUsage("gfx"))
    ADLogger.trace("RAM usage after appScreen-update: " .. getMemoryUsage("ram"))
end

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

function appSurface:get_height()
    return screen:get_height()
end

function appSurface:get_width()
    return screen:get_width()
end

function appSurface:drawOver(ftype, text)
    ftype:draw_over_surface(appScreen, text)
    screen:copyfrom(appScreen, nil)
    gfx.update()
end

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