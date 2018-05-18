from flask import Blueprint

hm = Blueprint('hm',__name__)

@hm.route('/home')
def home():
    return 'home page'