local multiplayermenu = {
  current_screen = nil,
  current_game = 1, 
  total_games = {
     "pacman",
     "2048"
  }
}

function multiplayermenu.loadMenu(Screen)
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
  color = {r=20, g=10, b=0}
  margin = 5
  multiplayermenu.drawBorder(Screen, ((Screen:get_width())/2)-225, screen:get_height()/20+10, 450, screen:get_height()/4, margin, color)
end


return multiplayermenu