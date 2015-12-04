#!bin/python

import sqlite3
from flask import g, app, Flask
from contextlib import closing

app = Flask(__name__)

DATABASE = 'database.db'
DATABASE_SCHEMA = 'database.schema'

TESTING = 0
TEST_SCHEMA = 'test.schema'


# SUPPORT METHODS

def dict_factory(cursor, row):
    d = {}
    if row is None:
        return d
    for idx, col in enumerate(cursor.description):
        d[col[0]] = row[idx]
    return d


def log(func_name, msg):
    print 'MSG:     DATABASE_HANDLER:    ' + func_name + '   :   ' + msg
    return True


def log_error(func_name, msg):
    print 'ERROR:   DATABASE_HANDLER:    ' + func_name + '   :   ' + msg
    return True


# DATABASE HANDLING

def init_db():
    with app.app_context():
        db = get_db()
        with app.open_resource(DATABASE_SCHEMA, mode='r') as f:
            db.cursor().executescript(f.read())
        db.commit()
        if TESTING == 1:
            with app.open_resource(TEST_SCHEMA, mode='r') as f:
                db.cursor().executescript(f.read())
            db.commit()
    return True


def get_db():
    with app.app_context():
        db = None
        try:
            db = getattr(g, 'db', None)
        except:
            print "Det gick fel :("
        if db is None:
            db = g.db = connect_db()
    return db


def connect_db():
    return sqlite3.connect(DATABASE)


def close_db():
    """Close database."""
    db = getattr(g, 'db', None)
    if db is not None:
        db.close()
    return None


def get_db_cursor():
    return get_db().cursor()


def persist_db():
    get_db().commit()
    return None


# USER HANDLING
# DATABASE TABLE user_list

def add_user(mac, playerid):
    """Add new user to database.
    Args:
        mac: MAC address of player. To differentiate between units.
        playerid: User specific ID to seperate player from other players
            using the same unit.

    Returns:
        The integer value of the global_id of the added user.
        Will return the integer value -1 if user could not be added. 

    Raises:
        Raises generic python error.

    History (date user: text):
        2015-12-04 bjowi227: Approved.
    """
    c = get_db()
    try:
        c.execute("INSERT INTO user_list (mac"
                  ", user_id)"
                  " VALUES (?,?)"
                  , (mac, playerid,))

        gid = c.cursor().lastrowid
        c.commit()
    except:
        get_db().rollback()
        raise
    if gid is None:
        return -1
    return gid

def get_user(mac, playerid):
    """Get user information from database.
    Args:
        mac: MAC address of player. To differentiate between units.
        playerid: Local id of player.
    Returns:
        The integer value of the global_id variable.
        If the user is not found, the integer value -1 will be returned.
    Raises:
        Will NOT raise an error.
    History (date user: text):
        2015-12-03 bjowi227: Corrected return variable.
        2015-12-04 bjowi227: Updated exception handling.
    """

    cursor = get_db_cursor()
    try:
        cursor.execute("SELECT global_id"
                       " FROM user_list"
                       " WHERE mac = ?"
                       " AND user_id = ?", (mac, playerid,))
        cfo = cursor.fetchone()
    except sqlite3.Error as e:
        log_error('get_user', e.args[0])
        cfo = None
    if cfo is None:
        return -1
    return cfo[0]


def get_unit_user(global_id):
    """Get user information from database.

    Args:
        global_id: Integer value corresponding to tuple global_id in
        the user_list table.

    Returns:
        A dict containing the mac and user_id of the player.
        See database table user_list for more information.
        If no user is found a dict with the correct tuples will be
        returned with the value of None.

    Raises:
        Will NOT raise an error.

    History (date user: text):
        2015-12-03 bjowi227: Created first version of function.
        2015-12-04 bjowi227: Updated exception handling.
    """

    cursor = get_db_cursor()
    try:
        cursor.execute("SELECT mac"
                       ", user_id"
                       " FROM user_list"
                       " WHERE global_id = ?"
                       , (global_id,))
        cfo = cursor.fetchone()
    except sqlite3.Error as e:
        log_error('get_unit_user', e.args[0])
        cfo = None
    if cfo is None:
        return {'mac': None
                ,'user_id': None}
    return dict_factory(cursor, cfo)

# GAME HANDLING
# DATABASE TABLE games

def add_game(gamename):
    """ Add a new game to the games table.
    Args:
        gamename: Name of game that is to be added.
    Returns:
        Boolean value true if game could be added, otherwise false.
    Raises:
        Nothing.
    History (date user: text):
        2015-12-04 bjowi227: Updated comments and exception handling.
    """
    c = get_db()
    try:
        c.execute("INSERT INTO games (gamename)"
                  " VALUES (?)"
                  , (gamename,))
        c.commit()
    except sqlite3.Error as e:
        get_db().rollback()
        log_error('add_game', e.args[0])
        return False
    return True


def game_exists(gamename):
    """ Check if a game exists in the database.
    Args:
        gamename: Name of game that is explored.
    Returns:
        Boolean value true if game exists, otherwise false.
    Raises:
        Nothing.
    History (date user: text):
        2015-12-04 bjowi227: Changed return statement to be faster.
    """
    cursor = get_db_cursor()
    try:
        cursor.execute("SELECT gamename"
                       " FROM games"
                       " WHERE gamename = ?", (gamename,))
        cfo = cursor.fetchone()
    except sqlite3.Error as e:
        log_error('game_exists', e.args[0])
        cfo = None
    #if cfo is None:
    #    return False
    #return True
    return cfo is not None

# MATCH HANDLING
# DATABASE TABLE matches
# DATABASE TABLE round

def get_match_history(gamename, mac, playerid, number_of_matches):
    """ Get history of the most recent matches for a player.
    Args:
        gamename: Specific game that the action is related to.
        mac: MAC-address for the player.
        playerid: An integer that specifies id for player of a set-top-box.
        number_of_matches: An integer that describes the number of matches
            that is desired to be retreived, e.g. 10 or 3.
    Returns:
        A dict containing the top X match_id.
    Raises:
        Nothing.
    History (date user: text):
        2015-12-03 bjowi227: Updated SQL query and return part.
        2015-12-04 bjowi227: Updated exception handling.
    """

    if isinstance( number_of_matches, int ):
        nom = number_of_matches
    else:
        nom = 3

    global_id = get_user(mac, playerid)
    if global_id == -1:
        global_id = add_user(mac, playerid)

    cursor = get_db_cursor()
    try:    
        cursor.execute("SELECT matches.match_id AS match_id"
                       ", matches.start_time AS start_time"
                       ", matches.winner AS winner"
                       " FROM matches"
                       " LEFT JOIN user_list"
                       " ON matches.player_one_id=user_list.global_id"
                       " OR matches.player_two_id=user_list.global_id"
                       " WHERE matches.gamename = ?"
                       " AND user_list.global_id = ?"
                       " ORDER BY matches.start_time DESC"
                       " LIMIT ?", (gamename, global_id, nom,))
        cfa = cursor.fetchall()
    except sqlite3.Error as e:
        log_error('get_match_history', e.args[0])
        cfa = None
    if cfa is None:
        return {'match_id':None
                ,'start_time': None
                ,'winner': None}
    result = []
    for row in cfa:
        result.append(dict_factory(cursor, row))
    return result


def create_match(gamename, mac, playerid):
    """ create new row in matches and add player one 

    Args:
        gamename: Specific game that the action is related to.
        mac: MAC-address for the player.
        playerid: An integer that specifies id for player of a set-top-box.

    Returns:
        Id of the match as an integer.
        Integer value -1 if player could not be inserted.

    Raises:
        Nothing.

    History (date user: text):
        2015-12-03 bjowi227: Changed name to create_match. Fixed INSERT query.
        2015-12-04 bjowi227: Corrected execute statement.
    """

    global_id = get_user(mac, playerid)
    if global_id == -1:
        global_id = add_user(mac, playerid)

    c = get_db()
    try:
        c.execute(
            "INSERT INTO matches (gamename"
            ", player_one_id)"
            " VALUES (?,?)"
            , (gamename, global_id,))
        last_id = c.cursor().lastrowid
        c.commit()
    except sqlite3.Error as e:
        get_db().rollback()
        log_error('create_match', e.args[0])
        return -1

    return last_id


def insert_player_two(gamename, mac, playerid, match_id):
    """ insert player two into an exisitng match

    Args:
        gamename: Specific game that the action is related to.
        mac: MAC-address for the player.
        playerid: An integer that specifies id for player of a set-top-box.
        match_id: An integer that specifies id for the match that the player shall be inserted in

    Returns:
        Id of the match as an integer.
        Integer value -1 if player could not be inserted.


    Raises:

    History (date user: text):
        2015-12-03 bjowi227: Added commit.
    """
    gid = get_user(mac, playerid)
    c = get_db()
    try:
        c.execute("UPDATE matches "
            " SET player_two_id = ?"
            " WHERE match_id = ?"
            , (gid, match_id,))
        c.commit()
    except sqlite3.Error as e:
        get_db().rollback()
        log_error('insert_player_two', e.args[0])
        return -1
    return match_id


def add_match(gamename, mac, playerid):
    """ Create new match with first player or add a new player to a currently
    empty player spot.

    Args:
        gamename: Specific game that the action is related to.
        mac: MAC-address for the player.
        playerid: An integer that specifies id for player of a set-top-box.

    Returns:
        Integer value -1 if match could not be added.
        Otherwise match_id as integer value.

    Raises:

    History (date user: text):
        2015-12-03
    """
    # Check for empty rows in matches

    cursor = get_db_cursor()
    try:    
        cursor.execute("SELECT match_id"
                       " FROM matches"
                       " WHERE player_two_id is null")
        
        cfo = cursor.fetchone()
    except sqlite3.Error as e:
        log_error('add_match', e.args[0])
        return -1

    # If cfo is None, a new row will have to be created to keep the new match.
    if cfo is None:
        return create_match(gamename, mac, playerid)
    else:
        return insert_player_two(gamename, mac, playerid, cfo.match_id)


def get_user_in_match(match_id, player_no):
    """ Gets the global_id of player one or two of a match.
    Args:
        match_id: Specified match being searched in.
        player_no: Specify player one or player two.

    Returns:
        Integer value -1 if input is incorrect.
        Integer value -2 if match did not exist.
        Integer value 0 if no player was specified in selected slot.

    Raises:
        Nothing.
    History (date user: text):
        2015-12-04 bjowi227: Replaced check_if_player_one with this function.
    """
    cursor = get_db_cursor()
    try:
        if player_no == 1:
            cursor.execute('SELECT player_one_id'
                           ' FROM matches'
                           ' WHERE match_id = ?'
                           , (match_id,))
            cfo = cursor.fetchone()
            log('get_matchplayer', 'Query result: ' + cfo)
        elif player_no == 2:
            cursor.execute('SELECT player_two_id'
                           ' FROM matches'
                           ' WHERE match_id = ?'
                           , (match_id,))
            cfo = cursor.fetchone()
            log('get_matchplayer', 'Query result: ' + cfo)
        else:
        log_error('get_matchplayer', 'Incorrect input of player_no. Must be integer 1 or 2.')
        return -1
    except sqlite3.Error as e:
        log_error('get_matchplayer', e.args[0])
        cfo = None

    if cfo is None:
        return -2
    elif cfo[0] is None:
        return 0
    else:
        return cfo[0]


def get_matchplayer(match_id, global_id):
    """ Get the value telling if the player is player one or two in a match.
    Args:
        match_id: Specified match being searched in.
        global_id: Integer value corresponding to global_id tuple in user_list.

    Returns:
        Integer value 1 or 2 if player was found.
        Integer value 0 if player was not found in the match.
        Integer value -1 if match was not found.

    Raises:
        Nothing.
    History (date user: text):
        2015-12-04 bjowi227: Replaced check_if_player_one with this function.
    """
    cursor = get_db_cursor()
    try:
        cursor.execute("SELECT player_one_id"
                       ", player_two_id"
                       " FROM matches"
                       " WHERE match_id = ?", (match_id,))
        cfo = cursor.fetchone()
    except sqlite3.Error as e:
        log_error('get_matchplayer', e.args[0])
        cfo = None
    if cfo is None:
        return -1
    elif cfo[0] == global_id:
        return 1
    elif cfo[1] == global_id:
        return 2
    else:
        return 0


def get_matchplayer_by_unit(match_id, mac, playerid):
    """ Get the value telling if the player is player one or two in a match.
    Args:
        match_id: Specified match being searched in.
        mac: MAC-address for the player.
        playerid: An integer that specifies id for player of a set-top-box.

    Returns:
        Integer value 1 or 2 if player was found.
        Integer value 0 if player was not found in the match.
        Integer value -1 if match was not found.

    Raises:
        Nothing.
    History (date user: text):
        2015-12-04 bjowi227: Replaced check_if_player_one with this function.
    """
    global_id = get_user(mac, playerid)
    if global_id == -1:
        return -1
    else:
        return get_matchplayer(match_id, global_id)


def update_round_score(score, match_id, game_number, field_name):
    """ Update score in specified tuple.

    Args:
        score: Score as integer value.
        match_id: Id of match.
        game_number: The new round number.
        field_name: String value of tuple to be updated.

    Returns:
        Boolean value True if tuple was updated.
        False if the field_name parameter was not correct.

    Raises:
        Nothing.

    History (date user: text):
        2015-12-04 bjowi227: Created.
    """
    # Check if field_name is correct. If not, return false.
    accepted_types = ['player_one_score'
                      , 'player_two_score']
    if field_name not in accepted_types:
        return False

    c = get_db()
    try:
        c.execute(
            "UPDATE round SET " + field_name + " = ?"
            " WHERE match_id = ?"
            " AND game_number = ?"
            , (score, match_id, game_number,))
    except sqlite3.Error as e:
        get_db().rollback()
        log_error('update_round_score', e.args[0])
        return False

    return True


def insert_round_score(score, match_id, game_number, field_name):
    """ Insert score into specified database tuple.

    Args:
        score: Score as integer value.
        match_id: Id of match.
        game_number: The new round number.
        field_name: String value of tuple to be updated.

    Returns:
        Boolean value True if a new row was created.
        False if the field_name parameter was not correct.

    Raises:
        Nothing

    History (date user: text):
        2015-12-04 bjowi227: Changed comments and SQL query.
    """

    # Check if field_name is correct. If not, return false.
    accepted_types = ['player_one_score'
                      , 'player_two_score']
    if field_name not in accepted_types:
        return False

    c = get_db()
    try:
        c.execute(
            "INSERT INTO round (match_id"
            ", game_number"
            ", " + field_name + ")"
            " VALUES (?,?,?)"
            , (match_id, game_number, score,))
    except sqlite3.Error as e:
        get_db().rollback()
        log_error('insert_round_score', e.args[0])
        return False

    return True


def add_round_score(gamename, match_id, mac, playerid, score):
    """ Add game score to a round.
    The specified player will have their score added to the match.

    Args:
        gamename: Specific game that the action is related to.
        match: Integer that is describes the ID of a match.
        mac: MAC-address for the player.
        playerid: An integer that specifies id for player of a set-top-box.
        score: The score to be stored in integer form.

    Returns:
        Boolean True if score was added.

    Raises:

    History (date user: text):
        2015-12-04 bjowi227: Made changed to query. Change function call and added logs.
    """

    global_id = get_user(mac, playerid)
    if global_id == -1:
        log('add_round_score', 'Player not found. Creating new player.')
        global_id = add_user(mac, playerid)
    else:
        log('add_round_score', 'Player found.')

    cursor = get_db_cursor()
    try:
        cursor.execute("SELECT matches.player_one_id"
                       ", matches.player_two_id"
                       ", round.player_one_score"
                       ", round.player_two_score"
                       ", round.match_id"
                       ", round.game_number"
                       " FROM round"
                       " FULL OUTER JOIN matches"
                       " ON round.match_id=matches.match_id"
                       " WHERE matches.gamename = ?"
                       " AND matches.match_id = ?"
                       , (gamename, match_id,))
        cfa = cursor.fetchall()
    except sqlite3.Error as e:
        log_error('add_round_score', e.args[0])
        cfa = None

    if cfa is None:
        log_error('add_round_score', 'Match was not found. {match_id=' + match_id + '}')
        return False

    # Check the latest round player by the players.
    p1r = -1
    p2r = -1
    for row in cfa:
        if row[2] is not None:
            p1r = row[5]
        if row[3] is not None:
            p2r = row[5]

    if cfa[0][0] == global_id:
        field_name = 'player_one_score'
        rn = p1r + 1
    elif cfo[0][1] == global_id:
        field_name = 'player_one_score'
        rn = p2r + 1
    else:
        log_error('add_round_score'
                  , 'Specified player was not participant of given match. {global_id=' + global_id + ', match_id=' + match_id + '}')
        return False
    if rn == 0:
        log('add_round_score', 'No previous rounds in match. Creating first round.')
        log('add_round_score', '{score=' + score + ', match_id=' + match_id)
        log('add_round_score', ', rn=' + 1 + 'field_name=' + field_name + '}')
        return insert_round_score(score, match_id, 1, field_name)
    else:
        log('add_round_score', 'Updating round with player score.')
        log('add_round_score', '{score=' + score + ', match_id=' + match_id)
        log('add_round_score', ', rn=' + rn + 'field_name=' + field_name + '}')
        return update_round_score(score, match_id, rn, field_name)


def get_number_of_rounds(gamename, match_id):
    """ Get the number of completed rounds of a match.

    Args:
        gamename: Specific game that the action is related to.
        match_id: Integer that is describes the ID of a match.

    Returns:
        An integer describing the amount of completed rounds in one match.

    Raises:

    History (date user: text):
        2015-12-04 bjowi227: Made minor corrections.
    """
    if not game_exists(gamename):
        return -1
    cursor = get_db_cursor()
    try:
        #TODO: Implement check of gamename aswell, will require JOIN
        cursor.execute("SELECT Count(match_id) AS result"
                       " FROM round"
                       " WHERE match_id = ?"
                       " AND player_one_score not null"
                       " AND player_two_score not null"
                       , (match_id,))
        cfo = cursor.fetchone()
    except sqlite3.Error as e:
        log_error('get_number_of_rounds', e.args[0])
        cfo = None
    if cfo is None:
        return 0
    return cfo[0]


def get_match_score(gamename, match):
    """ Get the scores of all games of a match.

    Args:
        gamename: Specific game that the action is related to.
        match: Integer that is describes the ID of a match.

    Returns:
        Rows of all games played with corresponding scores and player.
        Returned in the format as a dict.

    Raises:

    History (date user: text):
        2015-12-04 bjowi227: Created function.
        
    """
    cursor = get_db_cursor()
    try:
        #TODO: Implement check of gamename aswell, will require JOIN
        cursor.execute("SELECT game_number"
                       ", player_one_score"
                       ", player_two_score"
                       " FROM round"
                       " WHERE match_id = ?"
                       , (match,))
        cfa = cursor.fetchall()
    except sqlite3.Error as e:
        log_error('get_match_score', e.args[0])
        cfa = None
    if cfa is None:
        return {'game_number': None
                , 'plauer_one_score': None
                , 'player_two_score': None}
    result = []
    for row in cfa:
        result.append(dict_factory(cursor, row))
    return result


def get_match_total_score(gamename, match_id):
    """ Get the sum of scores for each player in a match.

    Args:
        gamename: Specific game that the action is related to.
        match_id: Integer that is describes the ID of a match.

    Returns:
        A dictionary with the row of both players score. 

    Raises:

    History (date user: text):
        2015-12-04 bjowi227: Approved
    """

    cursor = get_db_cursor()
    try:    
        cursor.execute("SELECT Sum(player_one_score)"
                       ", Sum(player_two_score)"
                       " FROM round"
                       " WHERE match_id = ?"
                       , (match_id,))
        cfo = cursor.fetchone()
    except sqlite3.Error as e:
        log_error('get_match_total_score', e.args[0])
        cfo = None
    if cfo is None:
        return {'player_one_score': None
                , 'player_two_score': None}
    return dict_factory(cursor, cfo)


def set_winner(gamename, match_id, global_id):
    """ Set the winner of a specified match.

    This function does not actually calculate if the selection of winner is
    correct or not.

    Args:
        gamename: Specific game that the action is related to.
        match: Integer that is describes the ID of a match.
        global_id: global_id of player that is to be set to winner.

    Returns:
        Boolean value True if table was updated, otherwise False.

    Raises:

    History (date user: text):
        2015-12-04 bjowi227: Implemented
    """
    c = get_db()
    try:
        c.execute(
            "UPDATE matches "
            " SET winner = ?"
            " WHERE match_id = ?"
            " AND gamename = ?"
            , (global_id, match_id, gamename,))
    except sqlite3.Error as e:
        get_db().rollback()
        log_error('set_winner', e.args[0])
        raise

    return True


def set_winner_by_unit(gamename, match_id, mac, playerid):
    """ Set the winner of a specified match.

    This function does not actually calculate if the selection of winner is
    correct or not.

    Args:
        gamename: Specific game that the action is related to.
        match: Integer that is describes the ID of a match.
        mac: MAC-address for the player.
        playerid: An integer that specifies id for player of a set-top-box.

    Returns:
        Boolean value True if table was updated, otherwise False.

    Raises:

    History (date user: text):
        2015-12-03 bjowi227: Fixed SQL query to check the correct tuples.
        2015-12-04 bjowi227: Changed name and separated query to another function.
        
    """

    global_id = get_user(mac, playerid)
    if global_id == -1:
        return False
    return set_winner(gamename, match_id, global_id)


def get_winner(gamename, match_id):
    """ Get the winner of a specified match.

    Args:
        gamename: Specific game that the action is related to.
        match: Integer that is describes the ID of a match.

    Returns:
        Integer that corresponds to the global_id variable in
        database table user_list.

    Raises:

    History (date user: text):
        2015-12-04 bjowi227: Made minor corrections. Approved.
    """

    cursor = get_db_cursor()
    try:    
        cursor.execute(
            "SELECT winner"
            " FROM matches"
            " WHERE match_id = ?"
            " AND gamename = ?"
            , (match_id, gamename,))
        cfo = cursor.fetchone()
    except sqlite3.Error as e:
        get_db().rollback()
        log_error('get_winner', e.args[0])
        cfo = None
    if cfo is None:
        return {'winner': None}
    return cfo[0]


def quit_match(gamename, match_id, mac, playerid):
    """ Delete match with corresponding rounds.

    Args:
        gamename: Specific game that the action is related to.
        match_id: Integer that is describes the ID of a match.

    Returns:
        Boolean value True if match could be deleted.
        False if match could not be deleted. A match might not be
        able to be deleted if it does not exist.

    Raises:

    History (date user: text):
        2015-12-04 bjowi227: Created new support functions to shorten code.
    """
    # Get if the player who quit is player one or two of match.
    player_quitting = get_matchplayer_by_unit(match_id, mac, playerid)

    if player_quitting == -1:
        log_error('quit_match', 'Match not found.')
        return False
    elif player_quitting == 0:
        log_error('quit_match', 'Player not found in match.')
        return False
    elif player_quitting == 1:
        # Quitting player was player one. Player two will be winner.
        winning_player = get_user_in_match(match_id, 2)
    elif player_quitting == 2:
        # Quitting player was player two. Player one will be winner.
        winning_player = get_user_in_match(match_id, 1)
    else:
        log_error('quit_match', 'Something went wrong.')
        return False

    if winning_player == 0:
        #There was no opponent; the player had not been matched to anyone.
        #TODO: Add function to delete the match and any round that might have been played.
        return False
    elif winning_player > 0:
        return set_winner(gamename, match_id, winning_player)
    else:
        # Other error messages should have been checked for earlier.
        log_error('quit_match', 'Something went wrong.')
        return False


# HIGHSCORE HANDLING
# DATABASE TABLE high_scores

def add_highscore(gamename, mac, playerid, score):
    """ Add highscore for specified player.
    Args:
        gamename: Specific game that the action is related to.
        mac: MAC-address for the player.
        playerid: An integer that specifies id for player of a set-top-box.
        score: Score to be saved.
    Returns:
        An integer value depending on the score;
        -1: Error
        1: Nothing out of the ordinary
        2: Top 10 local
        3: Top 10 global
    Raises:
        Nothing.
    History (date user: text):
        2015-12-04 bjowi227: Approved.
    """

    if not game_exists(gamename):
        add_game(gamename)

    global_id = get_user(mac, playerid)
    if global_id == -1:
        global_id = add_user(mac, playerid)

    c = get_db()
    try:
        c.execute("INSERT INTO high_scores (gamename"
                  ", player_id"
                  ", score)"
                  " VALUES (?,?,?)"
                  , (gamename, global_id, score,))
        c.commit()
    except sqlite3.Error as e:
        get_db().rollback()
        log_error('add_highscore', e.args[0])
        return -1
    #TODO: Add calculation if score was global or local top 10.
    return 1


def get_highscore_by_player(gamename, mac, playerid, number_of_results):
    """ Get highscore related to specific player.

    Args:
        gamename: Specific game that the action is related to.
        mac: MAC-address for the player.
        playerid: An integer that specifies id for player of a set-top-box.
        number_of_scores: An integer that describes the number of scores that
            is desired, e.g. 10 or 3.

    Returns:
        An array of dictionaries with the top N results for the player. Each 
        dictionary row contains the score and the player_id linked to this
        score.

    Raises:

    History (date user: text):
        2015-12-04 bjowi227: Approved.
    """
    if isinstance( number_of_results, int ):
        nor = number_of_results
    else:
        nor = 10

    cursor = get_db_cursor()
    try:
        cursor.execute("SELECT user_list.user_id AS user_id"
                       ", high_scores.score AS score"
                       " FROM high_scores"
                       " LEFT JOIN user_list"
                       " ON high_scores.player_id=user_list.global_id"
                       " WHERE high_scores.gamename = ?"
                       " AND user_list.mac = ?"
                       " AND user_list.user_id = ?"
                       " ORDER BY score DESC"
                       " LIMIT ?"
                       , (gamename, mac, playerid, nor,))
        cfa = cursor.fetchall()
    except sqlite3.Error as e:
        log_error('get_highscore_by_player', e.args[0])
        cfa = None
    if cfa is None:
        return {'user_id': None
                , 'score': None}
    result = []
    for row in cfa:
        result.append(dict_factory(cursor, row))
    return result


def get_highscore_by_box(gamename, mac, number_of_scores):
    """ Get all highscores for players of a specific set-top-box.

    Args:
        gamename: Specific game that the action is related to.
        mac: MAC-address for the player.
        number_of_scores: An integer that describes the number of scores that
            is desired, e.g. 10 or 3.

    Returns:
        An array of dictionaries with the top N results for the box. Each 
        dictionary row contains the score and the player_id linked to this
        score.

    Raises:

    History (date user: text):
        2015-12-04 bjowi227: Approved
    """
    if isinstance( number_of_scores, int ):
        nor = number_of_scores
    else:
        nor = 10

    cursor = get_db_cursor()
    try:
        cursor.execute("SELECT user_list.user_id AS user_id"
                       ", high_scores.score AS score"
                       " FROM high_scores"
                       " LEFT JOIN user_list"
                       " ON high_scores.player_id=user_list.global_id"
                       " WHERE high_scores.gamename = ?"
                       " AND user_list.mac = ?"
                       " ORDER BY high_scores.score DESC"
                       " LIMIT ?"
                       , (gamename, mac, nor,))
        cfa = cursor.fetchall()
    except sqlite3.Error as e:
        log_error('get_highscore_by_box', e.args[0])
        cfa = None
    if cfa is None:
        return {'user_id': None
                , 'score': None}
    result = []
    for row in cfa:
        result.append(dict_factory(cursor, row))
    return result  


def get_global_highscore(gamename, number_of_scores):
    """ Get the top number of scores for specific game. Not depedent 
    on player.

    Args:
        gamename: Specific game that the action is related to.
        number_of_scores: An integer that describes the number of scores that
            is desired, e.g. 10 or 3.

    Returns:
        An array of dictionaries.

    Raises:

    History (date user: text):
        2015-12-04 bjowi227: Approved
    """

    if isinstance( number_of_scores, int ):
        nor = number_of_scores
    else:
        nor = 10

    cursor = get_db_cursor()
    try:
        cursor.execute("SELECT user_list.mac AS mac"
                       ", user_list.user_id AS user_id"
                       ", high_scores.score AS score"
                       " FROM high_scores"
                       " LEFT JOIN user_list"
                       " ON high_scores.player_id=user_list.global_id"
                       " WHERE high_scores.gamename = ?"
                       " ORDER BY high_scores.score DESC"
                       " LIMIT ?"
                       , (gamename, nor,))
        cfa = cursor.fetchall()
    except sqlite3.Error as e:
        log_error('get_global_highscore', e.args[0])
        cfa = None
    if cfa is None:
        return {'mac': None
                , 'user_id': None
                , 'score': None}
    result = []
    for row in cfa:
        result.append(dict_factory(cursor, row))
    return result 