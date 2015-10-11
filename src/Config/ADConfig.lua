ADConfig = {};
ADConfig.version = "1.0.1"
ADConfig.isSimulator = false
ADConfig.updatePeriod = 1000
if not screen then 
  ADConfig.isSimulator = true 
else
  love = {}
end
return ADConfig