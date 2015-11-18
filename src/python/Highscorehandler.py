import json
import database_handler

database_handler.init_db()

# import databasehandler # Make correct 

def add_Highscore(jsonObj):
# Correct code, uncomment when databasehandler works:
# https://docs.python.org/2/library/json.html 

# In connectioninterface, use j = json.loads(JSONStringReceivedThroughSocket)
# 
# return databaseHandler.addHighscore(jsonObj.gameName, jsonObj.score, jsonObj.playername)  Make correct when dbHandler exists.
	return True
	
#Retrieves table of highscores, converts it to json and returns it to the calling function
def retrieveOwnHighscore(jsonObj):
# Correct code, uncomment when databasehandler works:
# return databaseHandler.retrieveOwnHighscore(jsonObj.gameName, jsonObj.playerName)  Make correct when dbHandler exists. 
#
#Alt: j = json.loads(jsonObj), and return databaseHandler.retrieveOwnHighscore(j.gameName, j.playerName)  And same on the rest of the functions
	return "0"
	
def retrieveTopHighscore():
# Correct code, uncomment when databasehandler works:
# return databaseHandler.retrieveTopHighscore()   Make correct when dbHandler exists. Need to jsonify the object somehow or is this done one step up?
	return "0"

