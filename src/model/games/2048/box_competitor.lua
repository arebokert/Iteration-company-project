--------------------------------------------------------------------
--class: Boxes                                              --------
--description: load the 2048 each number box                --------
--last modified Nov 22, 2015                                --------
--------------------------------------------------------------------
local Boxes_competitor = {
  current_score = 0, 
  tag = {},   -- end game tag
  current_zero = 16,  -- default 16 numbers = 0
  box_table = {       -- default numbers in the table
               0,0,0,0,
               0,0,0,0,
               0,0,0,0,
               0,0,0,0
              },
  box_img = {},       -- store the imgs of box
  each_square_2048 = 0,  -- set size of square box
  square_2048_margin = 0, -- set size of square box add margin
  box_start_x = 0,        -- start_x of box ( all the 16numbers)
  box_start_y = 0         -- start_y of box ( all the 16numbers) 
}

--------------------------------------------------------------------
--function: init                                            --------
--@param each_square, the size of each_square               --------
--@param box_start_x, the x of start point                  --------
--@param box_start_y, the y of start point                  --------
--description: init 16 number box                           --------
--last modified Nov 22, 2015                                --------
--------------------------------------------------------------------
function Boxes_competitor.init(each_square, box_start_x, box_start_y,flag)
   Boxes_competitor.loadAllImg()
   Boxes_competitor.setPosition(each_square, box_start_x, box_start_y)
   Boxes_competitor.showScore()
   Boxes_competitor.showMove()
    
end

function Boxes_competitor.refresh()
   Boxes_competitor.showScore()
   Boxes_competitor.showMove()
end

function Boxes_competitor.clear()
  for j = 1, 16 do  
    Boxes_competitor.box_table[j] = 0
  end
end

--------------------------------------------------------------------
--function: setPosition                                     --------
--@param each_square, the size of each_square               --------
--@param box_start_x, the x of start point                  --------
--@param box_start_y, the y of start point                  --------
--description: init the position of 2048                    --------
--last modified Nov 22, 2015                                --------
--------------------------------------------------------------------
function Boxes_competitor.setPosition(each_square, box_start_x, box_start_y)
  Boxes_competitor.each_square_2048 = each_square
  Boxes_competitor.square_2048_margin = Boxes_competitor.each_square_2048 + 5
  Boxes_competitor.box_start_x = box_start_x
  Boxes_competitor.box_start_y = box_start_y
  
end

--------------------------------------------------------------------
--function: showScore                                       --------
--description: show the scores of 2048                      --------
--last modified Nov 22, 2015                                --------
--------------------------------------------------------------------
function Boxes_competitor.showScore()
  local score_font = sys.new_freetype({g=100,r=100,b=100}, 32, {x=screen_competitor:get_width()*0.4,y=screen_competitor:get_height()*0.1},root_path .."views/mainmenu/data/font/Gidole-Regular.otf")
  score_font:draw_over_surface(screen_competitor,"Score:")
  screen_competitor:clear({r=245,g=245,b=245}, {x=screen_competitor:get_width()*0.4 +100,y=screen_competitor:get_height()*0.1, w=50, h =50})
  local score = sys.new_freetype({g=10,r=10,b=10}, 32, {x=screen_competitor:get_width()*0.4+100,y=screen_competitor:get_height()*0.1},root_path .. "views/mainmenu/data/font/Gidole-Regular.otf")
  score:draw_over_surface(screen_competitor,Boxes_competitor.current_score)
  
end

--------------------------------------------------------------------
--function: loadAllImg                                      --------
--description: load all imgs of numbers to box_img          --------
--last modified Nov 22, 2015                                --------
--------------------------------------------------------------------
function Boxes_competitor.loadAllImg()
  Boxes_competitor.box_img[0] = gfx.loadpng("views/2048/data/cell_img/empty.png")
  Boxes_competitor.box_img[2] = gfx.loadpng("views/2048/data/cell_img/2.png")
  Boxes_competitor.box_img[4] = gfx.loadpng("views/2048/data/cell_img/4.png")
  Boxes_competitor.box_img[8] = gfx.loadpng("views/2048/data/cell_img/8.png")
  Boxes_competitor.box_img[16] = gfx.loadpng("views/2048/data/cell_img/16.png")
  Boxes_competitor.box_img[32] = gfx.loadpng("views/2048/data/cell_img/32.png")
  Boxes_competitor.box_img[64] = gfx.loadpng("views/2048/data/cell_img/64.png")
  Boxes_competitor.box_img[128] = gfx.loadpng("views/2048/data/cell_img/128.png")
  Boxes_competitor.box_img[256] = gfx.loadpng("views/2048/data/cell_img/256.png")
  Boxes_competitor.box_img[512] = gfx.loadpng("views/2048/data/cell_img/512.png")
  Boxes_competitor.box_img[1024] = gfx.loadpng("views/2048/data/cell_img/1024.png")
  Boxes_competitor.box_img[2048] = gfx.loadpng("views/2048/data/cell_img/2048.png")
end

--------------------------------------------------------------------
--function: showMove                                        --------
--description: show the move of numbers after key function  --------
--last modified Nov 22, 2015                                --------
--------------------------------------------------------------------
function Boxes_competitor.showMove()
 local box_img = nil
  for j = 0, 3 do
    for i = 1, 4 do
      local bg_pos = {x = i*Boxes_competitor.square_2048_margin+Boxes_competitor.box_start_x, y=j*Boxes_competitor.square_2048_margin+Boxes_competitor.box_start_y, w= Boxes_competitor.each_square_2048, h = Boxes_competitor.each_square_2048}
      local box_value = Boxes_competitor.box_table[i+j*4]
      if(box_value== 0) then
        box_img = Boxes_competitor.box_img[0]
      else
        box_img = Boxes_competitor.box_img[box_value]
      end
      
      screen_competitor:copyfrom(box_img, nil,bg_pos,true)
    end
  end
  Boxes_competitor.showScore() 
  screen:copyfrom(screen_competitor,nil,{x=screen:get_width()*0.5,y=0})
  gfx.update() 
end

return Boxes_competitor
