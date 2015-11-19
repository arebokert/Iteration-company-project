import json
import database_handler

database_handler.get_db()
 
# Retrieves the parameters from the sent in jsonObject and sends the highscore to be added to the database to the database handler.
def add_Highscore(jsonObj):
	database_handler.add_highscore(jsonObj['gameName'], jsonObj['macAddress'], jsonObj['playerID'], jsonObj['score'])
	return True


#Retrieves table of highscores for specified user from the database, converts it to json and returns it to the calling function. 
def get_highscore(jsonObj):
	retrieved = database_handler.get_highscore_by_box(jsonObj['gameName'], jsonObj['macAddress'], 10) # change the number of scores
	return json.loads(retrieved)
#alt return json.dumps(retrieved)


# Retrieves table of global highscores for specified user from the database, converts it to json and returns it to the calling function.	
def get_global_highscore():
	retrieved = database_handler.get_global_highscore(jsonObj['gameName'], 10): # change the number of scores if necessary, hardcoded for now. 
	return json.loads(retrieved)
	# return json.dumps(retrieved)

