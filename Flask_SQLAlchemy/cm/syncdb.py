from cm import db

from manage import app

with app.app_context():
    db.create_all()