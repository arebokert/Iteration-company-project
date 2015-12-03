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
    """Create dict from cursor.

    Args:
        cursor:
        row:

    Returns:
        A dictionary where the column in the database column.
        
    Raises:
        
    """
    d = {}
    if row is None:
        return d
    for idx,col in enumerate(cursor.description):
        d[col[0]] = row[idx]
    return d


# DATABASE HANDLING
def init_db():
    """Initiate the database.

    Args:

    Returns:


    Raises:
        
    """
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
    """Get database.

    Args:

    Returns:

    Raises:

    """
    db = None
    try:
        db = getattr(g, 'db', None)
    except:
        print "Det gick fel :("
    if db is None:
        db = g.db = connect_db()
    return db

def connect_db():
    """Connect to database.

    Args:

    Returns:

    Raises:

    """
    return sqlite3.connect(DATABASE)


def close_db():
    """Close database."""
    db = getattr(g, 'db', None)
    if db is not None:
        db.close()
    return None


def get_db_cursor():
    """Return cursor for database.

    Args:

    Returns:

    Raises:
        
    """
    return get_db().cursor()


def persist_db():
    """Commit changes to database.

    Args:

    Returns:

    Raises:
        
    """
    get_db().commit()
    return None

# user_list TABLE
# USER HANDLING
 

    
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
    """
    c = get_db()
    try:
        c.execute("INSERT INTO user_list (mac"
            ", user_id) VALUES (?,?)"
            , (mac, playerid,))
        c.co
        gid = c.lastrowid()
        c.commit()
    except:
        get_db().rollback()
        raise
    if gid is None:
        return -1
    return gid

def remove_user(mac, playerid):
    #LowPrio
    #TODO(azuja469): Implement SQL statements to remove all rows with
    # Foreign keys that are connected to the user being removed.
    """Remove user from database.

    Args:
        mac: MAC address of player. To differentiate between units.
        playerid: User specific ID to seperate player from other players
            using the same unit.

    Returns:
        Will return a boolean to describe if the user could be removed from
        the database or not.

    Raises:
        Will NOT raise an error.
    """
    #TODO: ensure that azuja469 won't crash gitlab with this code

    c = get_db()
    try:
        c.execute("DELETE FROM user_list WHERE mac <> ? AND playerid <> ?", 'mac', 'playerid')
        c.commit()
    except:
        get_db().rollback()
        raise
    return True


def quit_match(mac, playerid, gamename, match_id):

    player_one_quitting = check_if_player_one(playerid, mac, match_id, gamename)

    if player_one_quitting == True:
        cursor = get_db_cursor()
        try:
            cursor.execute("SELECT player_two_id"
                       " FROM matches"
                       " WHERE match_id = ?"
                       " AND gamename = ?", (match_id, gamename,))
            cfo1 = cursor.fetchone()
        except sqlite3.Error as e:
            print 'Database error: ' + e.args[0]
            cfo1 = None
        if cfo1 is None:
            return -1
        return cfo1[0] #Is this one needed??

        cursor = get_db_cursor()
        try:
            cursor.execute("SELECT mac, user_id"
                       " FROM user_list"
                       " WHERE global_id = ?", (cfo1[0],))
            cfo2 = cursor.fetchone()
        except sqlite3.Error as e:
            print 'Database error: ' + e.args[0]
            cfo2 = None
        if cfo2 is None:
            return -1
        return cfo[0] #Is this one needed??

        return set_winner(gamename, match_id, cfo2[0], cfo2[1])
    else:
        cursor = get_db_cursor()
        try:
            cursor.execute("SELECT player_one_id"
                       " FROM matches"
                       " WHERE match_id = ?"
                       " AND gamename = ?", (match_id, gamename,))
            cfo1 = cursor.fetchone()
        except sqlite3.Error as e:
            print 'Database error: ' + e.args[0]
            cfo1 = None
        if cfo1 is None:
            return -1
        return cfo1[0] #Is this one needed??

        cursor = get_db_cursor()
        try:
            cursor.execute("SELECT mac, user_id"
                       " FROM user_list"
                       " WHERE global_id = ?", (cfo1[0],))
            cfo2 = cursor.fetchone()
        except sqlite3.Error as e:
            print 'Database error: ' + e.args[0]
            cfo2 = None
        if cfo2 is None:
            return -1
        return cfo[0] #Is this one needed??

        return set_winner(gamename, match_id, cfo2[0], cfo2[1])

        





    c = get_db()
    try:
        c.execute("DELETE FROM user_list WHERE mac <> ? AND playerid <> ?", 'mac', 'playerid')
        c.commit()
    except:
        get_db().rollback()
        raise
    return True

def get_user(mac, playerid):
    """Get user information from database.

    Args:
        mac: MAC address of player. To differentiate between units.

    Returns:
        The integer value of the global_id variable.
        If the user is not found, the integer value -1 will be returned.
    Raises:
        Will NOT raise an error.
    """

    cursor = get_db_cursor()
    try:
        cursor.execute("SELECT global_id"
                       " FROM user_list"
                       " WHERE mac = ?"
                       " AND user_id = ?", (mac, playerid,))
        cfo = cursor.fetchone()
    except sqlite3.Error as e:
        print 'Database error: ' + e.args[0]
        cfo = None
    if cfo is None:
        return -1
    return cfo[0]

def add_game(gamename):
    """ Add a new game to the games table.

    Args:
        gamename: Name of game that is to be added

    Returns:
        Boolean value true if game could be added, otherwise false.

    Raises:
        
    """
    c = get_db()
    try:
        c.execute("INSERT INTO games (gamename)"
            " VALUES (?)"
            , (gamename,))
        c.commit()
    except:
        get_db().rollback()
        return False
    return True

def game_exists(gamename):
    """ Check if a game exists in the database.

    Args:
        gamename: Name of game that is explored.

    Returns:
        Boolean value true if game exists, otherwise false.

    Raises:
        
    """
    cursor = get_db_cursor()
    try:
        cursor.execute("SELECT gamename"
                       " FROM games"
                       " WHERE gamename = ?", (gamename,))
        cfo = cursor.fetchone()
    except sqlite3.Error as e:
        print 'Database error: ' + e.args[0]
        cfo = None
    if cfo is None:
        return False
    return True


# MATCH HANDLING
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
        
    """

    if isinstance( number_of_matches, int ):
        nom = number_of_matches
    else:
        nom = 3
    cursor = get_db_cursor()
    try:    
        cursor.execute("SELECT match_id"
                       ", winner"
                       " FROM matches"
                       " WHERE gamename = ?", (mac,))
        #TODO(bjowi227): Fix the database query.
        cfo = cursor.fetchone()
    except sqlite3.Error as e:
        print 'Database error: ' + e.args[0]
        cfo = None
    if cfo is None:
        return {'mac':None
                ,'user_id': None}
                #TODO(bjowi227): Fix the return values.
    return dict_factory(cursor, cfo);

def insert_player_one(gamename, mac, playerid):
    #TODO(bjowi): Should only player id be taken as input (not mac)? 
    """ create new row in matches and add player one 

    Args:
        gamename: Specific game that the action is related to.
        mac: MAC-address for the player.
        playerid: An integer that specifies id for player of a set-top-box.

    Returns: id of the match as an integer


    Raises:
        
    """
    #TODO(azuja469): Fix inputs to match new table schema (player_one_mac 
        # does not exist)

    c = get_db()
    try:
        c.execute(
            "INSERT INTO matches (gamename"
            ", player_one_id)"
            " VALUES (?,?,?)"
            , (gamename, playerid,))
    except:
        get_db().rollback()
        raise

    cursor = get_db_cursor()
    try:    
        cursor.execute("SELECT match_id"
                       " FROM matches"
                       " WHERE player_two_mac = null")
        
        cfo = cursor.fetchone()
    except:
        get_db().rollback()
        raise

    return cfo.match_id

def insert_player_two(gamename, mac, playerid, match_id,):

   """ insert player two into an exisitng match 

    Args:
        gamename: Specific game that the action is related to.
        mac: MAC-address for the player.
        playerid: An integer that specifies id for player of a set-top-box.
        match_id: An integer that specifies id for the match that the player shall be inserted in

    Returns: id of the match as an integer


    Raises:
        
    """
   gid = get_user(mac, playerid)
   c = get_db()
   try:
       c.execute(
           "UPDATE matches "
           "SET player_two_id = ?"
           "WHERE match_id = ?"
           , (gid, match_id,))
   except:
       get_db().rollback()
       raise
   return match_id

def add_match(gamename, mac, playerid):
    """ Create new match with first player or add a new player to a currently
    empty player spot.

    Args:
        gamename: Specific game that the action is related to.
        mac: MAC-address for the player.
        playerid: An integer that specifies id for player of a set-top-box.

    Returns:


    Raises:
        
    """
    # Check for empty rows in matches

    cursor = get_db_cursor()
    try:    
        cursor.execute("SELECT match_id"
                       " FROM matches"
                       " WHERE player_two_id is null")
        
        cfo = cursor.fetchone()
    except:
        get_db().rollback()
        raise
    #TODO(bjowi): Fix error handling.

    if cfo is None:
        return insert_player_one(gamename, mac, playerid)
    else:
        return insert_player_two(gamename, mac, playerid, cfo.match_id)


def check_if_player_one(playerid, mac, match_id, gamename): 

    global_id = get_user(mac, playerid)
    if global_id == -1:
        global_id = add_user(mac, playerid)

    cursor = get_db_cursor()
    try:
        cursor.execute("SELECT matches.player_one_id, matches.player_two_id, round.player_one_score"
                       ", round.player_two_score, round.match_id, round.game_number"
                       " FROM matches"
                       " INNER JOIN round"
                       " ON round.match_id=matches.match_id"
                       " WHERE matches.gamename = ?"
                       " AND matches.match_id = ?"
                       , (gamename, match_id,))
        cfa = cursor.fetchall()
    except sqlite3.Error as e:
        print 'Database error: ' + e.args[0]
        cfa = None
    if cfa is None:
        return {'user_id': None
                , 'score': None}
    result = []
    for row in cfa:
        result.append(dict_factory(cursor, row))
    return result

    if cfa[0].player_one_id == global_id:
        player1=True
    else:
        player1=False
    return player1

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


    Raises:
        
    """

#TODO implement correctly. Choose correct SQL statements and make a comparison 
#to select if the score shall be added to player one or two in database
#TODO(erida995, bjowi): Get user -> decide if player one or player 2. Look at 
# function add_match for ideas. Bjorn, please check this function. Daveby has
# started on it, but has not implemented insert_round_score or 
# update_round_score fully. 


    global_id = get_user(mac, playerid)
    if global_id == -1:
        global_id = add_user(mac, playerid)

    cursor = get_db_cursor()
    try:
        cursor.execute("SELECT matches.player_one_id, matches.player_two_id, round.player_one_score"
                       ", round.player_two_score, round.match_id, round.game_number"
                       " FROM matches"
                       " INNER JOIN round"
                       " ON round.match_id=matches.match_id"
                       " WHERE matches.gamename = ?"
                       " AND matches.match_id = ?"
                       , (gamename, match_id,))
        cfa = cursor.fetchall()
    except sqlite3.Error as e:
        print 'Database error: ' + e.args[0]
        cfa = None
    if cfa is None:
        return {'user_id': None
                , 'score': None}
    result = []
    for row in cfa:
        result.append(dict_factory(cursor, row))
    return result

    if cfa[0].player_one_id == global_id:
        player1=True
    else:
        player1=False
    if player1 == True:
        updated=False
        for row in cfa:
            if cfa.player_one_id == null:
                update_round_score(gamename, global_id, score, match_id, row.game_number)
                updated=True
            if updated==False:
                insert_round_score(gamename, global_id, score, match_id, row.game_number)
    if player1 == False:
        updated=False
        for row in cfa:
            if cfa.player_two_id == null:
                update_round_score(gamename, global_id, score, match_id, row.game_number)
                updated=True
            if updated==False:
                insert_round_score(gamename, global_id, score, match_id, row.game_number)


def insert_round_score(score, match_id, game_number, field_name):
    #TODO(bjowi): get this function to work. implement so that this functions know if the player
    #is player 1 or player 2.  
    """ cretate or update round table with score
    #Comments not up to date.
    Args:
        gamename: Specific game that the action is related to.
        mac: MAC-address for the player.
        playerid: An integer that specifies id for player of a set-top-box.

    Returns: id of the match as an integer


    Raises:
        
    """
    c = get_db()
    try:
        c.execute(
            "INSERT INTO round (match_id"
            ", game_number"
            ", player_one_score)"  
            " VALUES (?,?,?)"
            , (match_id, game_number, score,))
    except:
        get_db().rollback()
        raise 


def get_number_of_rounds(gamename, match_id):
    """ Get the number of completed rounds of a match.

    Args:
        gamename: Specific game that the action is related to.
        match_id: Integer that is describes the ID of a match.

    Returns:
        An integer describing the amount of completed rounds in one match.

    Raises:
        
    """
    #TODO(erida995): Implement function. 
    #IS THIS OKAY??? Really not sure /erida995

    cursor = get_db_cursor()
    try:    
        cursor.execute("SELECT Count(match_id) AS result"
                       " FROM round"
                       " WHERE match_id = ?"
                       " AND player_one_score not null"
                       " AND player_two_score not null"
                       , (match_id,))
        cfo = cursor.fetchone()
    except:
        get_db().rollback()
        raise
    return cfo.result


def get_match_score(gamename, match):
    """ Get the scores of all games of a match.

    Args:
        gamename: Specific game that the action is related to.
        match: Integer that is describes the ID of a match.

    Returns:
        Rows of all games played with corresponding scores and player.
        Returned in the format as a dict.

    Raises:
        
    """

    #TODO(bjowi): Implement function. Write correct comments.



def get_match_total_score(gamename, match_id):
    """ Get the sum of scores for each player in a match.

    Args:
        gamename: Specific game that the action is related to.
        match_id: Integer that is describes the ID of a match.

    Returns:
        A dictionary with the row of both players score. 

    Raises:
        
    """
    #TODO(erida995): Implement function. Write correct comments.

    cursor = get_db_cursor()
    try:    
        cursor.execute("SELECT Sum(player_one_score)"
                        " , Sum(player_two_score)"
                        " FROM round"
                        " WHERE match_id = ?"
                        , (match_id,))
        cfo = cursor.fetchone()
    except:
        get_db().rollback()
        raise
    return dict_factory(cursor, cfo)

def set_winner(gamename, match_id, mac, playerid):
    """ Set the winner of a specified match.

    This function does not actually calculate if the selection of winner is
    correct or not.

    Args:
        gamename: Specific game that the action is related to.
        match: Integer that is describes the ID of a match.
        mac: MAC-address for the player.
        playerid: An integer that specifies id for player of a set-top-box.

    Returns:


    Raises:
        
    """
    #TODO(bjowi227): Add get user search for correct SQL statements.
    c = get_db()
    try:
        c.execute(
            "UPDATE matches "
            "SET winner = ?"
            "WHERE match_id = ?"
            , (playerid, match_id,))
    except:
        get_db().rollback()
        raise

    return match_id


def get_winner(gamename, match_id):
    """ Get the winner of a specified match.

    Args:
        gamename: Specific game that the action is related to.
        match: Integer that is describes the ID of a match.

    Returns:


    Raises:
        
    """

    #TODO (bjowi): Check that this is implementet correctly
    #especially the usage of "winner" and the "?"

    cursor = get_db_cursor()
    try:    
        cursor.execute(
            "SELECT winner"
            " FROM matches"
            " WHERE match_id = ?"
            , (match_id,))
        cfo = cursor.fetchone()

    except:
        get_db().rollback()
        raise

        return cfo.winner

# HIGHSCORE HANDLING

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
            " VALUES (?,?,?,?)"
            , (gamename, global_id, score,))
        c.commit()
    except:
        get_db().rollback()
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
        
    """
    if isinstance( number_of_results, int ):
        nor = number_of_results
    else:
        nor = 10

    cursor = get_db_cursor()
    try:
        cursor.execute("SELECT user_list.user_id"
                       ", high_scores.score"
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
        print 'Database error: ' + e.args[0]
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
        
    """
    if isinstance( number_of_scores, int ):
        nor = number_of_scores
    else:
        nor = 10

    cursor = get_db_cursor()
    try:
        cursor.execute("SELECT user_list.user_id"
                       ", high_scores.score"
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
        print 'Database error: ' + e.args[0]
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
    """

    if isinstance( number_of_scores, int ):
        nor = number_of_scores
    else:
        nor = 10

    cursor = get_db_cursor()
    try:
        cursor.execute("SELECT user_list.mac"
                       ", user_list.user_id"
                       ", high_scores.score"
                       " FROM high_scores"
                       " LEFT JOIN user_list"
                       " ON high_scores.player_id=user_list.global_id"
                       " WHERE high_scores.gamename = ?"
                       " ORDER BY high_scores.score DESC"
                       " LIMIT ?"
                       , (gamename, nor,))
        cfa = cursor.fetchall()
    except sqlite3.Error as e:
        print 'Database error: ' + e.args[0]
        cfa = None
    if cfa is None:
        return {'mac': None
                , 'user_id': None
                , 'score': None}
    result = []
    for row in cfa:
        result.append(dict_factory(cursor, row))
    return result 