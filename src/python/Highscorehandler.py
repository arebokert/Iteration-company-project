import json
import database_handler

 
# Retrieves the parameters from the sent in jsonObject and sends the highscore to be added to the database to the database handler.
def add_Highscore(jsonObj):
	data = json.loads(jsonObj)
	database_handler.add_highscore(data['gameName'], data['macAddress'], data['playerID'], data['score'])    
	return jsonObj


#Retrieves table of highscores for specified user from the database, converts it to json and returns it to the calling function. 
def get_highscore(jsonObj):
	data = json.loads(jsonObj)
	retrieved = database_handler.get_highscore_by_box(data['gameName'], data['macAddress'], data['numberOfHighscores']) # change the number of scores
	return json.dumps(retrieved)


# Retrieves table of global highscores for specified user from the database, converts it to json and returns it to the calling function.	
def get_global_highscore(jsonObj):
	data = json.loads(jsonObj)
	retrieved = database_handler.get_global_highscore(data['gameName'], data['numberOfHighscores']) # change the number of scores if necessary, hardcoded for now.
	return json.dumps(retrieved)

