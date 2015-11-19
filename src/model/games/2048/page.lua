Game = require("game")
Page = {current_page ="main_page", current_pos_y =100, current_pos_x =100}

function Page.showMainPage()
  screen:fill({r=10,g=5,b=50})
  
  screen:clear({r=80,g=20,b=20},{x=400,y=180,w=450,h=100})
  Page.current_pos_y = 180
  --Page.showPageText()
  --ADLogger.trace("showInsidePage")
end

function Page.showPageText()

  start_btn = sys.new_freetype({g=100,r=100,b=100}, 50, {x=500,y=200},"data/font/grasping.ttf")
  start_btn:draw_over_surface(screen,"Start Game")
  
  option_btn = sys.new_freetype({g=100,r=100,b=100}, 50, {x=500,y=300},"data/font/grasping.ttf")
  option_btn:draw_over_surface(screen,"Options")
  
  highScore_btn = sys.new_freetype({g=100,r=100,b=100}, 50, {x=500,y=400},"data/font/grasping.ttf")
  highScore_btn:draw_over_surface(screen,"High Score")
  
  exit_btn = sys.new_freetype({g=100,r=100,b=100}, 50, {x=500,y=500},"data/font/grasping.ttf")
  exit_btn:draw_over_surface(screen,"Exit")
  gfx.update()
end
--show game page
function Page.showGamePage()
   screen:fill({r=10,g=5,b=50})
   screen:clear({r=0,g=205,b=204},{x=400,y=100,w = 415, h=415})
   -- draw rows
   for i =1, 4 do
     screen:clear({r=255,g=255,b=255},{x=400+(i-1)*100,y=100,w = 5, h=415})
   end
   
   for i =1, 4 do
     screen:clear({r=255,g=255,b=255},{x=400,y=100+(i-1)*100,w = 415, h=5})
   end
   
   screen:clear({r=255,g=255,b=255},{x=815,y=100,w = 5, h=420})
   screen:clear({r=255,g=255,b=255},{x=400,y=515,w = 420, h=4})
   
   gfx.update()
end

-- change sound, change model, reset score
function Page.showOptionPage()
end

function Page.showHighScorePage()
end

function Page.showExitPage()
  screen:fill({g=5,r=10,b=50})
  exit_btn = sys.new_freetype({g=100,r=100,b=100}, 50, {x=300,y=200},"data/font/grasping.ttf")
  exit_btn:draw_over_surface(screen,"Are you sure?")
  yes_btn = sys.new_freetype({g=100,r=100,b=100}, 50, {x=300,y=300},"data/font/grasping.ttf")
  yes_btn:draw_over_surface(screen,"Yes")
  cancel_btn = sys.new_freetype({g=100,r=100,b=100}, 50, {x=500,y=300},"data/font/grasping.ttf")
  cancel_btn:draw_over_surface(screen,"No")
  gfx.update()
end

function Page.showScorePage()
  screen:fill({g=5, r=10, b=50})
  high_score = sys.new_freetype({{g=100,r=100,b=100}, 50, {x=300,y=200},"data/font/grasping.ttf"})
  high_score:draw_over_surface()
end

function Page.registerKey(key, state)
  current_page = Page.current_page
  if current_page == "game_page" then
    Game.registerKey(key, state)
  elseif current_page == "main_page" then
    Page.mainPageKeyPress(key, state)
  elseif current_page == "option_page" then
  
  elseif current_page == "exit_page" then
  
  end
end

function Page.exitPageKeyPress(key,state)

end

function Page.optionPageKeyPress(key, state)

end

function Page.mainPageKeyPress(key, state)
  if state == "down" then
    if key == "up" then
      screen:clear({r=10,g=5,b=50},{x=400,y=Page.current_pos_y,w=450,h=100})
      if Page.current_pos_y <= 180 then
        Page.current_pos_y = 480
      else
        Page.current_pos_y = Page.current_pos_y- 100
      end
      screen:clear({r=80,g=20,b=20},{x=400,y=Page.current_pos_y,w=450,h=100})
      Page.showPageText()
    elseif key == "down" then
      screen:clear({r=10,g=5,b=50},{x=400,y=Page.current_pos_y,w=450,h=100})
      if Page.current_pos_y >= 480 then
        Page.current_pos_y = 180
      else
        Page.current_pos_y = Page.current_pos_y+ 100
      end
      screen:clear({r=80,g=20,b=20},{x=400,y=Page.current_pos_y,w=450,h=100})
      Page.showPageText()
    elseif key == "ok" then
      if Page.current_pos_y == 180 then
          Page.current_page = "game_page"
          Page.showGamePage()
          Game.startGame()
      elseif Page.current_pos_y == 280 then
          Page.showOptionPage()
      elseif Page.current_pos_y == 380 then
          Page.showHighScorePage()
      elseif Page.current_pos_y == 480 then
          Page.showExitPage()
      end  
    elseif key == "exit" then
        Page.showExit()
    end
  end 
end

return Page