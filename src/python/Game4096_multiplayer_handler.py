import json
import database_handler as dbh
from flask import jsonify


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
        2015-12-06 bjowi227: Implemented function.
    """
    data = json.loads(jsonObj)
    # Get player information
    player = dbh.get_user_safe(data['mac'], data['playerid'])

    # Get match, or create new match.
    response = dbh.get_match_history("4096", data['mac'], data['playerid'], 1)
    match = response['match_id']
    if match is None or response['winner'] is not None:
        # No match was found or match was found but has ended, create new match.
        match = dbh.start_new_4096_match(data['mac'], data['playerid'])

    if data['flag'] == 1:
        # Normal move update. Update box.
        dbh.update_4096_box(match, player, data['box'])
        dbh.set_4096_score(match, player, data['score'])
        dbh.update_4096_flag(match, player, 1)
    elif data['flag'] == 2:
        # The player has quit the game, set other player as winner.
        pn = dbh.get_matchplayer(match, player)
        if pn == 1:
            op = dbh.get_user_in_match(match, 2)
        elif pn == 2:
            op = dbh.get_user_in_match(match, 1)
        else:
            print "Something went wrong in submit score for 4096."
            return False
        dbh.set_winner('4096', match, op)
        dbh.update_4096_flag(match, player, 2)
    elif data['flag'] == 4:
        # Player has filled their squares and cannot do anything.
        dbh.update_4096_box(match, player, data['box'])
        dbh.set_4096_score(match, player, data['score'])
        dbh.update_4096_flag(match, player, 4)
    else:
        return False
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
    # Get player information
    player = dbh.get_user_safe(data['mac'], data['playerid'])

    # Get match, or create new match.
    response = dbh.get_match_history("4096", data['mac'], data['playerid'], 1)
    match = response['match_id']
    if match is None or response['winner'] is not None:
        # No match was found or match was found but has ended, create new match.
        match = dbh.start_new_4096_match(data['mac'], data['playerid'])

    op_box = []
    # Get opponent id
    pn = dbh.get_matchplayer(match, player)
    if pn == 1:
        op_id = dbh.get_user_in_match(match, 2)
    elif pn == 2:
        op_id = dbh.get_user_in_match(match, 1)
    else:
        print "Opponent could not be found."
        return jsonify({"flag":3, "box":op_box, "score":0})

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

    return jsonify({"flag":status_flag, "box":op_box, "score":op_score})
