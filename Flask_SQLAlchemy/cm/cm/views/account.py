from flask import Blueprint


from cm import db
from cm.models import UserInfo3

ac = Blueprint('ac',__name__)

@ac.route('/login')
def login():
    # result = db.session.query(UserInfo3).all()
    # print('sql...',result)
    return 'login page'

@ac.route('/logout')
def logout():
    return 'logout page'