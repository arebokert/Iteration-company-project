local class = require("SDK.Lib.classy")

-- I am very unsure about this file, what should be included or not in the Mocked API. 

Rect = class("SDK.Mocked.Rect"); -- not sure about adding "SDK.Mocked."

function Rect:__init(rect)
end

-- zto = {}

function love.load()
end

function love.run()
end

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
end

function love.keyreleased(key)
end



