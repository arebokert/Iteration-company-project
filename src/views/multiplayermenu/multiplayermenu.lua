model = require "model.multiplayermenu.multiplayermenu"
multiplayermenu = {title = "Multiplayer Menu"}
playerMenu = nil
local a = {}

function multiplayermenu.loadMenu(Screen)
  a = model:fetchPath()
  ADLogger.trace(a[1]["path"])
  playerMenu = Screen
  playerMenu:clear({r=7, g = 19, b=77, a=20}, {x =screen:get_width()/20, y = screen:get_height()/20, w= screen:get_width() *0.9, h = screen:get_height()* 0.56 })
  multiplayermenu.loadRecentResults(Screen)
  multiplayermenu.loadCurrentPlayers(Screen)
  multiplayermenu.loadGameMenu(Screen)
  return Screen
end

function multiplayermenu.writeWord(word, color, size, position, Screen)
  ADLogger.trace(root_path)
  font_path = datapath .. "/font/Gidole-Regular.otf"
  ADLogger.trace(font_path)
  size = size or 50
  color = color or {r = 100, g = 0, b =100}
  word = word or  "hello world" 
  ADLogger.trace(size)
  start_btn = sys.new_freetype(color, size, position,font_path)
  start_btn:draw_over_surface(Screen,word)
end

function multiplayermenu.loadRecentResults(Screen)
  color = {r=20, g=10, b=0}
  margin = 5
  multiplayermenu.drawBorder(Screen, ((screen:get_width()/2)-(screen:get_width()/10*3)/2)-screen:get_width()/5, (screen:get_height())/3, ((screen:get_width())/10)*3, 50, margin, color)
  multiplayermenu.drawBorder(Screen, ((screen:get_width()/2)-(screen:get_width()/10*3)/2)-screen:get_width()/5, ((screen:get_height())/3)*1.3, ((screen:get_width())/10)*3, 50, margin, color)
  multiplayermenu.drawBorder(Screen, ((screen:get_width()/2)-(screen:get_width()/10*3)/2)-screen:get_width()/5, ((screen:get_height())/3)*1.6, ((screen:get_width())/10)*3, 50, margin, color)
end

function multiplayermenu.drawBorder(Screen, startX, startY, width, height, margin, color)
  Screen:clear(color, {x = startX, y = startY, w = width, h = margin})
  Screen:clear(color, {x = startX, y = startY, w = margin, h = height})
  Screen:clear(color, {x = startX, y = startY+height, w = width+margin, h = margin})
  Screen:clear(color, {x = startX+width, y = startY, w = margin, h = height+margin})
end

function multiplayermenu.loadCurrentPlayers(Screen, players)
  color = {r=20, g=10, b=0}
  margin = 5
  currentplayers = players or 0
  multiplayermenu.drawBorder(Screen, ((screen:get_width()/2)-(screen:get_width()/10*3)/2)+screen:get_width()/5, (screen:get_height())/3, screen:get_width()/10*3, 50, margin, color)
  multiplayermenu.writeWord(currentplayers,{r = 100, g = 0, b =100},35,{x=(((screen:get_width()/2)-(screen:get_width()/10*3)/2)+screen:get_width()/5)+25, y= ((screen:get_height())/3)*1.02},Screen)
end

function multiplayermenu.loadGameMenu(Screen)
  local gameNumber = 1
  color = {r=20, g=10, b=0}
  margin = 5
  local bg = gfx.loadjpeg(a[gameNumber+1]["path"] .. 'background-small.jpg')
  playerMenu:copyfrom(bg, nil, {x=((Screen:get_width())/2)+100, y= screen:get_height()/20+37})
  bg:destroy()
  local bg = gfx.loadjpeg(a[gameNumber]["path"] .. 'background.jpg')
  playerMenu:copyfrom(bg, nil, {x=((Screen:get_width())/2)-150, y= screen:get_height()/20+20})
  bg:destroy()
end




return multiplayermenu