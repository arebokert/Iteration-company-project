local Serpent = require("SDK.Lib.serpent")
--local Socket = require("SDK.Lib.socket")
local Socket = require("socket")

if not ADLogger then
  ADLogger = {};

  ADLogger.HTTP_LISTENER_IP = "192.168.192.101";
  ADLogger.HTTP_LISTENER_PORT = "12024";

  ADLogger.enabled = true
  ADLogger.modes = {
      CONSOLE = 0,
      HTTP = 1,
      FILE = 2

    }
  ADLogger.levels = {
      TRACE = 0,
      DEBUG = 1,
      WARN = 2,
      ERROR = 3,
      OFF = 4
    }

  ADLogger.labels = {"TRACE : ","DEBUG : ","WARN  : ","ERROR : "}

  ADLogger.logMemory = false

  ADLogger.loglevel = ADLogger.levels.TRACE

  ADLogger.mode = ADLogger.modes.CONSOLE

  -- By default - enable HTTP logging on STBs
  --if gfx and ADLogger.loglevel < ADLogger.levels.OFF then
  --  ADLogger.mode = ADLogger.modes.HTTP
  --  ADLogger.logMemory = true
  --else


  -- end

  --ADLogger.mode = ADLogger.modes.CONSOLE


  if ADLogger.mode == ADLogger.modes.HTTP then
    ADLogger.udp = Socket.udp()
    ADLogger.udp:settimeout(0)
    ADLogger.udp:setpeername(ADLogger.HTTP_LISTENER_IP, ADLogger.HTTP_LISTENER_PORT)
  end


  function ADLogger.print(level,message,obj)
    local callingFunction = debug.getinfo(3)

    if callingFunction and callingFunction.name then
      callingFunction = callingFunction.name
    else
      callingFunction = "Anonymous"
    end
    local memoryMsg = ""
    if ADLogger.logMemory then
      memoryMsg = string.format(" %d[%d]",gfx.get_memory_use(), gfx.get_memory_limit())
    end

    if ADLogger.loglevel <= level then
      local output_text = ADLogger.labels[level+1].." : "..callingFunction.." : "..message..memoryMsg
      if ADLogger.mode == ADLogger.modes.CONSOLE then
        print(output_text)
        if obj then
          print(Serpent.dump(obj))
        end
      elseif ADLogger.mode == ADLogger.modes.HTTP then
        ADLogger.udp:send(output_text) -- the magic line in question.
        if obj then
          ADLogger.udp:send(Serpent.dump(obj))
        end
      end

    end

  end

  function ADLogger.trace(message,obj)
    ADLogger.print(ADLogger.levels.TRACE,message,obj)
  end
  function ADLogger.debug(message,obj)
    ADLogger.print(ADLogger.levels.DEBUG,message,obj)
  end
  function ADLogger.warn(message,obj)
    ADLogger.print(ADLogger.levels.WARN,message,obj)
  end
  function ADLogger.error(message,obj)
    ADLogger.print(ADLogger.levels.ERROR,message,obj)
  end
else
  ADLogger.warn("Attempted to re-load Logger")
end

return ADLogger
