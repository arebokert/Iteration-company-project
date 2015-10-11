ADConfig = require("Config.ADConfig")
ADLogger = require("SDK.Utils.ADLogger")
ADLogger.trace("Applicatio Init")

if ADConfig.isSimulator then
    gfx = require "SDK.Simulator.gfx"
    zto = require "SDK.Simulator.zto"
    surface = require "SDK.Simulator.surface"
    player = require "SDK.Simulator.player"
    freetype = require "SDK.Simulator.freetype"
    sys = require "SDK.Simulator.sys"
end



function increment(N)
  return N + 1
end


Menu = {title = "Main Menu"}

function Menu:new ()
  obj = {}   -- create object if user does not provide one
  setmetatable(obj, self)
  self.__index = self
  return obj
end


function Menu:setOptions(options)
  self.options = options
  self.size = table.getn(options)
  ADLogger.trace("Menu initiated")  
end

function Menu:setActive(a)
  ADLogger.trace("SET ACTIVE")
  ADLogger.trace(a)
  self.active = a
  
  
    ADLogger.trace(a) 
  for i = 1,self.size do
    ADLogger.trace(i)
    activeButton = self.options[i].button
    activeButtonPos = self.options[i].buttonPos
    
    if i == a then
      activeButton:clear({g=102, r=51, b=0})
      self.options[a].hover()
    else 
      activeButton:clear({g=204, r=102, b=0})
    end
      self.container:copyfrom(activeButton, nil , activeButtonPos)
  end    
  
  -- Updating the new container on the screen
  if self.containerPos then
    screen:copyfrom(self.container, nil, self.containerPos)
  else  
    screen:copyfrom(self.container, nil )
  end
  


  gfx.update()
end


function Menu:next() 
  local next = self.active + 1

  if self.active + 1 > self.size then
    next = 1
  end
  
  self:setActive(next)
end

function Menu:prev() 
  local prev = self.active - 1
  if self.active - 1 < 1 then
    prev = self.size
  end
  
  self:setActive(prev)
end

function Menu:action()
  self.options[self.active].action()
end

function Menu:print(container, startx, starty, m)
    self.container = container
    
    margin = m
    width = (container:get_width() - margin*(self.size - 1) - 2*startx)/ self.size
    height = container:get_height() - 2*starty
      
    for i = 1,self.size do 
        opt = self.options[i]
                
        xpos = startx + (i-1)*width + (i-1)*margin
        ypos = starty
        
        opt.button = gfx.new_surface(width, height) 
        opt.buttonPos = {x=xpos,y=ypos}
        opt.button:clear({g=204, r=102, b=200, a=20})
        container:copyfrom(opt.button, nil, opt.buttonPos)
    end  
    
    -- Updating the new container on the screen
    if self.containerPos then
      screen:copyfrom(container, nil, self.containerPos)
    else 
      screen:copyfrom(container, nil )
    end
    
end



function onKey(key, state)
    ADLogger.trace("OnKey("..key..","..state..")")
  
    if key == "yellow" then
      ADLogger.trace("YELLOW BUTTON")
      mainMenu:setActive(2)
      
    end
    
    
    if key == "left" and state == "down" then 
      activeMenu:prev()
    end
    if key == "right" and state == "down" then 
      activeMenu:next()
    end  
    if key == "ok" and state == "down" then
      activeMenu:action()
    end
    if key == "up" and state == "down" and mainMenu.active == 1 then
      activeMenu = secondary
    end
    if key == "down" and state == "down" and mainMenu.active == 1 then
      activeMenu = mainMenu
    end
    if key == "back" and state == "down" and mainMenu.active == 1 then
      activeMenu = mainMenu
    end
    
end



function loadSecondaryMenu()   
    o = {}
    o[1] = {title = "Game", 
                  action = function()
                              -- action
                              return "Return Option1"
                             end, 
                    hover = function()
                              return true         
                            end, 
                    leave = function()
                              return true
                            end}   
    o[2] = {title = "Settings",
                    action = function()
                              -- action
                              return "Return Option2"
                             end, 
                    hover = function()
                              return true         
                            end, 
                    leave = function()
                              return true
                            end}   
    o[3] = {title = "Settings",
                    action = function()
                              -- action
                              return "Return Option2"
                             end, 
                    hover = function()
                              return true         
                            end, 
                    leave = function()
                              return true
                            end}   
    o[4] = {title = "Settings",
                    action = function()
                              -- action
                              return "Return Option2"
                             end, 
                    hover = function()
                              return true         
                            end, 
                    leave = function()
                              return true
                            end}   
    o[5] = {title = "Settings",
                    action = function()
                              -- action
                              return "Return Option2"
                             end, 
                    hover = function()
                              return true         
                            end, 
                    leave = function()
                              return true
                            end}   
    secondary = Menu:new()
--    secondary:setOptions(o)
    secondary.options = o
    secondary.size = 5
    
    secondaryMenuContainer = gfx.new_surface(880, 300)
    secondary.containerPos = {x = 200, y=120}
    secondaryMenuContainer:clear({g=40, r=40, b=40} ) 
    
    secondary:print(secondaryMenuContainer, 20, 80, 40) 
    secondary:setActive(1)
end


function loadMainMenu()

    options = {}
    options[1] = {title = "Game", 
                  action = function()
                              loadSecondaryMenu()
                              activeMenu = secondary
                              --rect = gfx.new_surface(200, 200)
                              --rect:clear( {g=0, r=0, b=255} ) 
                              --rectPos = {x = 500, y=100}                        
                              --screen:copyfrom(rect, nil, rectPos) 
                              gfx.update()     
                              return "Return Option1"
                           end, 
                  hover = function()
                            local bg = gfx.loadjpeg('data/bg1280-720.jpg')
                            screen:copyfrom(bg, nil) 
                            bg:destroy()
                            --loadSecondaryMenu()                        
                            gfx.update()          
                          end, 
                  leave = function()
                            local bg = gfx.loadjpeg('data/bg1280-720.jpg')
                            screen:copyfrom(bg, nil) 
                            bg:destroy()
                            gfx.update() 
                            return true
                          end}   
    options[2] = {title = "Settings",
                    action = function()
                              rect = gfx.new_surface(200, 200)
                              rect:clear( {g=0, r=255, b=0} ) 
                              rectPos = {x = 500, y=100}                        
                              screen:copyfrom(rect, nil, rectPos) 
                              gfx.update()                              
                              return "Return Option2"
                           end, 
                  hover = function()
                            screen:clear({g=100, r=0, b=0})
                            gfx.update()          
                          end, 
                  leave = function()
                            return true
                          end}   
    options[3] = {title = "Settings",
                    action = function()
                              rect = gfx.new_surface(200, 200)
                              rect:clear( {g=255, r=0, b=0} ) 
                              rectPos = {x = 500, y=100}                        
                              screen:copyfrom(rect, nil, rectPos) 
                              gfx.update()                              
                              return "Return Option3"
                           end, 
                  hover = function()
                            screen:clear({g=0, r=0, b=140})
                            gfx.update()          
                          end, 
                  leave = function()
                            return true
                          end}   
    options[4] = {title = "Account",
                    action = function()
                              rect = gfx.new_surface(200, 200)
                              rect:clear( {g=0, r=0, b=0} ) 
                              rectPos = {x = 500, y=100}                        
                              screen:copyfrom(rect, nil, rectPos) 
                              gfx.update()  
                              return "Return Option4"
                           end, 
                  hover = function()
                            screen:clear({g=0, r=100, b=0})                           
                            gfx.update()          
                          end, 
                  leave = function()
                            return true
                          end}    
                           
    mainMenu = Menu:new() 
    mainMenuContainer = gfx.new_surface(1280, 220)
    mainMenuContainer:clear( {g=50, r=50, b=50} )    

    mainMenu.containerPos = {x = 0, y=500}                        
    --screen:copyfrom(mainMenuContainer, nil, mainMenu.containerPos)
    
    
    mainMenu.options = options
    --mainMenu.size = table.getn(options)
    mainMenu.size = 4
    
    mainMenu:print(mainMenuContainer, 140, 60, 120)     
    
    mainMenu:setActive(1)
    
    gfx.update()
end


    
function onStart()

    ADLogger.trace("onStart")
    if ADConfig.isSimulator then
        if arg[#arg] == "-debug" then require("mobdebug").start() end
    end
    
    -- screen:destroy()
    -- screen = gfx.new_surface(1280, 720)
    screen:clear({g=120, r=10, b=20})
--    local bg_pos = {x = 0, y=0} 
    local bg = gfx.loadjpeg('data/bg1280-720.jpg')
    screen:copyfrom(bg, nil) 
        bg:destroy()
--    loadMainMenu()
--    activeMenu = mainMenu
--    gfx.update()


-- OK    mainMenu = Menu:new()
    loadMainMenu()
    activeMenu = mainMenu
    gfx.update()
    
     
    --screen:copyfrom(mainMenuContainer, nil, mainMenuContainer.pos,true)   

    --gfx.update()
end



