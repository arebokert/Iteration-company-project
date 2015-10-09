local class = require("SDK.Lib.classy")
Rect = class("Rect");

function Rect:__init(rect) 
  if rect == nil then
    self.x = 0
    self.y = 0
    self.w = 0
    self.h = 0
  else
    self.x = rect.x or 0
    self.y = rect.y or 0
    self.w = rect.w or rect.width or 0
    self.h = rect.h or rect.height or 0
  end
end





zto = {}




-- call the onStart function once the Love2D app is loaded
function love.load()  
  onStart()
end


function love.run()

  if love.math then
		love.math.setRandomSeed(os.time())
		for i=1,3 do love.math.random() end
	end

  if love.event then
		love.event.pump()
	end

  if love.load then love.load(arg) end

  -- We don't want the first frame's dt to include time taken by love.load.
	if love.timer then love.timer.step() end

  local dt = 0

  -- Main loop time.
  while true do
    -- Process events.
    if love.event then
      love.event.pump()
      for e,a,b,c,d in love.event.poll() do
        if e == "quit" then
          if not love.quit or not love.quit() then
            if love.audio then
              love.audio.stop()
            end
            return
          end
        end
        love.handlers[e](a,b,c,d)
      end
    end
    
    --Fire off any system timers
    for i,t in ipairs(sys.timers) do
      if t.running then
        if t.time_since >= t.interval_millisec then 
          if type(t.callback) == "function" then
            t.callback()
          elseif type(t.callback) == "string" then
            cb_function = loadstring(t.callback .. "()")
            cb_function(t)
          end
          t.time_since = 0
        else
          t.time_since = t.time_since + (dt * 1000)
        end
        sys.timers[i] = t
      end
    end 

    -- Update dt, as we'll be passing it to update
    if love.timer then
      love.timer.step()
      dt = love.timer.getDelta()
    end

    -- Call update and draw
    if love.update then love.update(dt) end -- will pass 0 if love.timer is disabled

    if love.window and love.graphics and love.window.isCreated() then
      love.graphics.clear()
      love.graphics.origin()
      if love.draw then love.draw() end
      love.graphics.present()
    end

    if love.timer then love.timer.sleep(0.001) end
  end

end



love.keyboard.setKeyRepeat(true)

love.graphics.setNewFont(14)


local keyboard_mapping = {
  KEY_0         = "0", 
  KEY_1         = "1", 
  KEY_2         = "2", 
  KEY_3         = "3", 
  KEY_4         = "4", 
  KEY_5         = "5", 
  KEY_6         = "6", 
  KEY_7         = "7", 
  KEY_8         = "8", 
  KEY_9         = "9", 
  KEY_return    = "ok", 
  KEY_up        = "up",
  KEY_down      = "down", 
  KEY_left      = "left", 
  KEY_right     = "right", 
  KEY_r         = "red", 
  KEY_g         = "green", 
  KEY_y         = "yellow", 
  KEY_b         = "blue" , 
  KEY_w         = "white", 
  KEY_i         = "info", 
  KEY_m         = "menu", 
  KEY_capslock  = "guide", 
  KEY_o         = "opt", 
  KEY_h         = "help",  
  KEY_lshift    = "star", 
  KEY_ralt      = "multi", 
  KEY_e         = "exit", 
  KEY_p         = "pause", 
  KEY_t         = "toggle_tv_radio",  
  KEY_c         = "record", 
  KEY_lalt      = "play", 
  KEY_s         = "stop", 
  KEY_f         = "fast_forward", 
  KEY_tab       = "rewind", 
  KEY_l         = "skip_forward", 
  KEY_u         = "skip_reverse", 
  KEY_z         = "jump_to_end", 
  KEY_a         = "jump_to_beginning", 
  KEY_d         = "toggle_pause_play", 
  KEY_v         = "vod", 
  KEY_delete    = "back", 
  KEY_backspace = "backspace", 
  KEY_rshift    = "hash", 
  KEY_x         = "ttx", 
  KEY_q         = "record_list", 
  KEY_k         = "play_list", 
  KEY_m         = "mute"
  }


function love.keypressed(key, isrepeat)
  if keyboard_mapping["KEY_"..key] then
    if isrepeat then
      onKey(keyboard_mapping["KEY_"..key], "repeat")
    else
      onKey(keyboard_mapping["KEY_"..key], "down")
    end
  end
end

---
-- Detects when a key is released
-- A function that detects when a key is released. Passes the released key to the user defined onKey() function. 
-- Uses the game engine Love2D to realize the function. 
-- @param key the key pressed
function love.keyreleased(key)
  if keyboard_mapping["KEY_"..key] then
    onKey(keyboard_mapping["KEY_"..key], "up")
  end
end