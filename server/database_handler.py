#!bin/python

import sqlite3
from flask import g, app, Flask
from contextlib import closing

app = Flask(__name__)

DATABASE = 'database.db'
DATABASE_SCHEMA = '../database.schema'


# SUPPORT METHODS
def dict_factory(cursor, row):
    """Create dict from cursor."""
    d = {}
    if row is None:
        return d
    for idx,col in enumerate(cursor.description):
        d[col[0]] = row[idx]
    return d


# DATABASE HANDLING
def init_db():
    """Initiate the database."""
    with app.app_context():
        db = get_db()
        with app.open_resource(DATABASE_SCHEMA, mode='r') as f:
            db.cursor().executescript(f.read())
        db.commit()
    #return True


def connect_db():
    """Connect to database."""
    return sqlite3.connect(DATABASE)


def close_db():
    """Close database."""
    db = getattr(g, 'db', None)
    if db is not None:
        db.close()
    return None


def get_db():
    """Get database."""
    db = getattr(g, 'db', None)
    if db is None:
        db = g.db = connect_db()
    return db


def get_db_cursor():
    """Return cursor for database."""
    return get_db().cursor()


def persist_db():
    """Commit changes to database."""
    get_db().commit()
    return None