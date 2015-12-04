import json


def submit_box(jsonObj):
	"""Handle a send request incoming from a player.

	Shall add the players latest status to a variable. Only one
	status shall be available at any given time.

    Args:
        jsonObj: JSON object containg {flag, mac, playerid, box, score}

    Returns:
        Will return a boolean value. True if everything went ok, 
        otherwise false. 

    Raises:
        

    History (date user: text):
        2015-12-03 bjowi227: Created.
    """
	return True




def request_box(jsonObj):
	"""Handle a data request from a player.

    Args:
        jsonObj: JSON object containg {mac, playerid}

    Returns:
        Shall return a JSON object with the relevant data. The object
        shall be able to contain {flag, box, score}
        flag: 
        	= 1 if opponent has updated their box since the last request.
        	= 2 if the opponent has quit the game.
        	= 3 if the opponent has not yet updated their box since the
        		last request.
    		= 4 if the other player has filled all their squared and is
    			unable to make another move, i.e. lost.
		Opponent box and score shall NOT be sent if flag == 3 or
			flag == 2. 
		The value 4 for flag will be sent only once. It will be followed
			by flag == 2 or flag == 3 (if the opponent left).

    Raises:
        

    History (date user: text):
        2015-12-03 bjowi227: Created.
    """
	return True