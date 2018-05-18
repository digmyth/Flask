from flask import Flask
from .views import account,home

from flask_sqlalchemy import SQLAlchemy

# 实例化db对象
db = SQLAlchemy()

from .models import  UserInfo3

def create_app():
    app = Flask(__name__)
    app.config.from_object('settings.Dev')

    app.register_blueprint(account.ac)
    app.register_blueprint(home.hm)

    db.init_app(app)  # 初始化

    return app
