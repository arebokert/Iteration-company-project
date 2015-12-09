import json
import database_handler as dbh
from flask import jsonify


def log(func_name, msg):
    print 'MSG:     Game4096_multiplayer:    ' + func_name + '   :   ' + msg
    return True


def log_error(func_name, msg):
    print 'ERROR:   Game4096_multiplayer:    ' + func_name + '   :   ' + msg
    return True


def makeJson(obj):
    return json.dumps(obj)
    # return jsonify(obj)


def join_match(jsonObj):
    """Handle request from player to start new of join existing match.
    Args:
        jsonObj: JSON object containg {mac, playerId}
    Returns:
        Will return the match_id as a positive integer. Will return the
        integer value -1 if something went wrong in the database, -2 if data
        sent was wrong or corrupt.
    Raises:
    History (date user: text):
        2015-12-09 bjowi227: Created.
    """
    data = json.loads(jsonObj)
    # Check data for consistency
    if not isinstance( data['playerId'], int ):
        msg = "Received parameter playerId is not an integer."
        log_error("join_match", msg)
        return makeJson({"matchId":-2})

    # Join or create new match.
    match = dbh.start_new_4096_match(data['mac'], data['playerId'])
    return makeJson({"matchId":match})


def submit_box(jsonObj):
    """Handle a send request incoming from a player.
    Shall add the players latest status to a variable. Only one
    status shall be available at any given time.
    Args:
        jsonObj: JSON object containg {matchId, flag, mac, playerId, box, score}
    Returns:
        Will return a boolean value. True if everything went ok, 
        otherwise false.
    Raises:
    History (date user: text):
        2015-12-03 bjowi227: Created.
        2015-12-06 bjowi227: Implemented function.
    """
    data = json.loads(jsonObj)
    # Check data for consistency
    if not isinstance( data['matchId'], int ) or\
            not isinstance( data['playerId'], int ):
        msg = "Received parameter matchId or playerId is not an integer."
        log_error("submit_box", msg)
        return makeJson({"response": False})

    # Get player information
    player = dbh.get_user_safe(data['mac'], data['playerId'])
    match = data['matchId']

    if data['flag'] == 1:
        msg = "Normal move update. Update box."
        log("submit_box", msg)
        dbh.update_4096_box(match, player, data['box'])
        dbh.set_4096_score(match, player, data['score'])
        dbh.update_4096_flag(match, player, 1)
    elif data['flag'] == 2:
        msg = "The player has quit the game, set other player as winner."
        log("submit_box", msg)
        pn = dbh.get_matchplayer(match, player)
        if pn == 1:
            op = dbh.get_user_in_match(match, 2)
        elif pn == 2:
            op = dbh.get_user_in_match(match, 1)
        else:
            log_error("submit_box", "Something went wrong in submit score for 4096.")
            return makeJson({"response": False})
        dbh.set_winner('4096', match, op)
        dbh.update_4096_flag(match, player, 2)
    elif data['flag'] == 4:
        msg = "Player has filled their squares and cannot do anything."
        log("submit_box", msg)
        dbh.update_4096_box(match, player, data['box'])
        dbh.set_4096_score(match, player, data['score'])
        dbh.update_4096_flag(match, player, 4)
    elif data['flag'] == 5:
        msg = "Player has won the game."
        log("submit_box", msg)
        dbh.update_4096_box(match, player, data['box'])
        dbh.set_4096_score(match, player, data['score'])
        dbh.update_4096_flag(match, player, 5)
        dbh.set_winner('4096', match, player)
    else:
        return makeJson({"response": False})
    return makeJson({"response": True})


def request_box(jsonObj):
    """Handle a data request from a player.
    Args:
        jsonObj: JSON object containg {mac, playerId, matchId }
    Returns:
        Shall return a JSON object with the relevant data. The object
        shall be able to contain {flag, box, score}
        flag: 
            = 1 if opponent has updated their box since the last request.
            = 2 if the opponent has quit the game.
            = 3 if the opponent has not yet updated their box since the
                last request.
            = 4 if the other player has filled all their squared and is
                unable to make another move.
        Opponent box and score shall NOT be sent if flag == 3 or
            flag == 2.
        The value 4 for flag will be sent only once. It will be followed
            by flag == 2 or flag == 3 (if the opponent left).
    Raises:
    History (date user: text):
        2015-12-03 bjowi227: Created.
        2015-12-06 bjowi227: Implemented function.
    """
    data = json.loads(jsonObj)
    op_box = []
    op_score = 0
    status_flag = 3

    # Check data for consistency
    if not isinstance( data['matchId'], int ) or\
            not isinstance( data['playerId'], int ):
        msg = "Received parameter matchId or playerId is not an integer."
        log_error("request_box", msg)
        return makeJson({"flag": status_flag, "box": op_box, "score": op_score})

    # Get global_id for player
    player = dbh.get_user_safe(data['mac'], data['playerId'])

    match = data['matchId']

    # Get global_id of opponent.
    pn = dbh.get_matchplayer(match, player)
    op_id = 0
    if pn == 1:
        op_id = dbh.get_user_in_match(match, 2)
    elif pn == 2:
        op_id = dbh.get_user_in_match(match, 1)
    elif pn == -1 or pn == 0:
        # The player was not part of the match.
        log_error("request_box", "Player not part of specified match.")
        return makeJson({"flag": status_flag, "box": op_box, "score": op_score})

    if op_id == 0:
        # An opponent has not yet joined the game.
        log_error("request_box", "Opponent could not be found at this time.")
        return makeJson({"flag": status_flag, "box": op_box, "score": op_score})

    # Check the flag of the opponent.
    status_flag = dbh.get_4096_flag(match, op_id)
    if status_flag == 1:
        # Opponent has updated their box.
        op_box = dbh.get_4096_box(match, op_id)
        op_score = dbh.get_4096_score(match, op_id)
        dbh.update_4096_flag(match, op_id, 3)
    elif status_flag == 2:
        # Opponent has quit the game.
        op_score = 0
    elif status_flag == 3:
        # Opponent has not updated their box.
        op_score = 0
    elif status_flag == 4:
        # Opponent has filled their box.
        op_box = dbh.get_4096_box(match, op_id)
        op_score = dbh.get_4096_score(match, op_id)
        dbh.update_4096_flag(match, op_id, 3)
    elif status_flag == 5:
        # The other player has won.
        op_box = dbh.get_4096_box(match, op_id)
        op_score = dbh.get_4096_score(match, op_id)

    return makeJson({"flag": status_flag, "box": op_box, "score": op_score})
