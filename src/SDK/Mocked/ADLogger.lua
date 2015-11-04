-- local Serpent = require("SDK.Lib.serpent")

if not ADLogger then
  ADLogger = {};

  function ADLogger.print(level,message,obj)
  end
  
  function ADLogger.trace(message,obj)
  end
  
  function ADLogger.debug(message,obj)
  end
  
  function ADLogger.warn(message,obj)
  end
  
  function ADLogger.error(message,obj)
  end
  
end

return ADLogger
