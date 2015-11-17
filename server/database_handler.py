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
        
    Raises:
        
    """

def get_user():
    """Get user information from database.

    Args:
        mac: MAC address of player. To differentiate between units.
        playerid: User specific ID to seperate player from other players
            using the same unit.

    Returns:
        
    Raises:
        
    """

# MATCH HANDLING
def get_match_history(gamename, mac, playerid, number_of_matches):
    """ write_description_here

    Args:

    Returns:


    Raises:
        
    """


def add_match(gamename, mac, playerid):
def add_round_score(gamename, match, mac, playerid, score):
def get_number_of_rounds(gamename, match):
def get_match_score(gamename, match):
def get_match_total_score(gamename, match):
def set_winner(gamename, match, mac, playerid):
def get_winner(gamename, match):


# HIGHSCORE HANDLING

def add_highscore(gamename, mac, playerid, score):
def get_highscore(gamename, mac, playerid, number_of_scores):
def get_global_highscore(gamename, number_of_scores):