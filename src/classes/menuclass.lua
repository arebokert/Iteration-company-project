Menu = {title = "Main Menu"}

function Menu:new ()
    obj = {}   -- create object if user does not provide one
    setmetatable(obj, self)
    self.__index = self
    return obj
end


function Menu:setOptions(options)
    self.options = options
    self.size = #options -- # is the length operator in Lua
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

return Menu