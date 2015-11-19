#!bin/python

import sqlite3
from flask import g, app, Flask
from contextlib import closing

app = Flask(__name__)

DATABASE = 'database.db'
DATABASE_SCHEMA = 'database.schema'


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
    #return True


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


def get_db():
    """Get database.

    Args:

    Returns:

    Raises:
        
    """
    db = getattr(g, 'db', None)
    if db is None:
        db = g.db = connect_db()
    return db


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

def add_user(mac, playerid,):
    """Add new user to database.

    Args:
        mac: MAC address of player. To differentiate between units.
        playerid: User specific ID to seperate player from other players
            using the same unit.

    Returns:
        A boolean value to signal if the insertion went ok or not. TRUE
        if insertion went ok, otherwise FALSE.

    Raises:
        Raises generic python error.
    """
    c = get_db()
    try:
        c.execute("INSERT INTO user_list (mac"
            ", user_id) VALUES (?,?)"
            , (mac, playerid,))
    except:
        get_db().rollback()
        raise
    return True

def remove_user(mac, playerid):
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
    #TODO: Implement this function.

def get_user(mac):
    """Get user information from database.

    Args:
        mac: MAC address of player. To differentiate between units.

    Returns:
        A dict mapping database column to the corresponding table rows. For
        example if there are two users linked to the specified MAC-address:
        {'user_id': ('1', '2')}. 
        If no user could be found a dictionary with
        empty values will be returned.
    Raises:
        Will NOT raise an error.
    """

    cursor = get_db_cursor()
    try:
        cursor.execute("SELECT mac"
                       ", user_id"
                       " FROM user_list"
                       " WHERE mac = ?", (mac,))
        cfo = cursor.fetchone()
    except sqlite3.Error as e:
        print 'Database error: ' + e.args[0]
        cfo = None
    if cfo is None:
        return {'mac':None
                ,'user_id': None}
    return dict_factory(cursor, cfo);

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
        nom = 10
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

def add_round_score(gamename, match, mac, playerid, score):
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


def get_number_of_rounds(gamename, match):
    """ Get the number of played and completed rounds of a match.

    Args:
        gamename: Specific game that the action is related to.
        match: Integer that is describes the ID of a match.

    Returns:


    Raises:
        
    """

def get_match_score(gamename, match):
    """ Get the scores of all games of a match.

    Args:
        gamename: Specific game that the action is related to.
        match: Integer that is describes the ID of a match.

    Returns:


    Raises:
        
    """

def get_match_total_score(gamename, match):
    """ Get the sum of scores for each player in a match.

    Args:
        gamename: Specific game that the action is related to.
        match: Integer that is describes the ID of a match.

    Returns:


    Raises:
        
    """

def set_winner(gamename, match, mac, playerid):
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

def get_winner(gamename, match):
    """ Get the winner of a specified match.

    Args:
        gamename: Specific game that the action is related to.
        match: Integer that is describes the ID of a match.

    Returns:


    Raises:
        
    """


# HIGHSCORE HANDLING

def add_highscore(gamename, mac, playerid, score):
    """ Add highscore for specified player.

    Args:
        gamename: Specific game that the action is related to.
        mac: MAC-address for the player.
        playerid: An integer that specifies id for player of a set-top-box.
        score: Score to be saved.

    Returns:


    Raises:
        
    """

def get_highscore(gamename, mac, playerid, number_of_scores):
    """ Get highscore related to specific player.

    Args:
        gamename: Specific game that the action is related to.
        mac: MAC-address for the player.
        playerid: An integer that specifies id for player of a set-top-box.
        number_of_scores: An integer that describes the number of scores that
            is desired, e.g. 10 or 3.

    Returns:


    Raises:
        
    """

def get_global_highscore(gamename, number_of_scores):
    """ Get the top number of scores for specific game. Not depedent 
    on player.

    Args:
        gamename: Specific game that the action is related to.
        number_of_scores: An integer that describes the number of scores that
            is desired, e.g. 10 or 3.

    Returns:


    Raises:
        
    """