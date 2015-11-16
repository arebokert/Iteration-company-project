import json

# import databasehandler # Make correct 

def addHighscore(jsonObj):
#TODO implement this
# https://docs.python.org/2/library/json.html 

# In connectioninterface, use j = json.loads(JSONStringReceivedThroughSocket)
# 
# return databaseHandler.addHighscore(jsonObj.gameName, jsonObj.score, jsonObj.playername)  Make correct when dbHandler exists.
	return true
	
	
def retrieveOwnHighscore(jsonObj):
#TODO implement this
# return databaseHandler.retrieveOwnHighscore(jsonObj.gameName, jsonObj.playerName)  Make correct when dbHandler exists. 
#
#Alt: j = json.loads(jsonObj), and return databaseHandler.retrieveOwnHighscore(j.gameName, j.playerName)  And same on the rest of the functions
	return "0"
	
def retrieveTopHighscore():
#TODO implement this
# return databaseHandler.retrieveTopHighscore()   Make correct when dbHandler exists. Need to jsonify the object somehow or is this done one step up?
	return "0"

