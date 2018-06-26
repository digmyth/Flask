
# SQLAlchemy和Flask结合使用

## 模块安装
SQLAlchemy和Flask结合的一个组件: Flask-SQLAlchemy
```
pip3 install Flask-SQLAlchemy
```

## 基本使用
```
from flask impoprt Flask
app=Flask(__name__)
from flask-sqlalchemy import SQLAlchemy
db = SQLAlchemy() # 创建flask-sqlalchemy()对象
db.init_app(app)  # 关联app
```

这个flask-sqlalchemy()对象内部自动封装了一系列信息：

*  自带连接数据库相关engine参数：如数据库连接池大小，数据库连接URI（用户名，密码，IP，库名），
*  db.session就相当于session=scoped_session(SessionClass)可以直接用于数据库操作，如db.session.query(UserInfo).all()
*  db.create_all(app=app) 、 db.drop_all(app=app)用于创建删除数据库
*  class UserInfo(db.Model)中db.Model相当于以前使用的Base

tip
```
from cm import db
from manage import app
with app.app_context(): #  其实是执行AppContext(app)类的`__enter__`方法
    db.create_all()
```

## 创建表结构
```
# models.py
import datetime
from sqlalchemy import create_engine
from sqlalchemy import Column, Integer, String, Text, ForeignKey, DateTime, UniqueConstraint, Index
# from sqlalchemy.ext.declarative import declarative_base
# Base = declarative_base()
from cm import db

##  单表创建
class UserInfo2(db.Model):
    __tablename__ = 'userinfo2'

    id = Column(Integer, primary_key=True)
    name = Column(String(32), index=True, nullable=False)
    email = Column(String(32), unique=True)
    ctime = Column(DateTime, default=datetime.datetime.now)
    # extra = Column(Text, nullable=True)

    __table_args__ = (
        # UniqueConstraint('id', 'name', name='uix_id_name'),
        Index('ix_id_name', 'name', 'email'),
    )
```

## 注意项

写项目过程中注意点
```
from flask import Flask
from flask_sqlalchemy import SQLAlchemy
db = SQLAlchemy()  # 注意这里实例化在前

from .views import home,account  # Blueprint注册在后，否则出现db导入失败的错误
from .models import  UserInfo2
app.register_blueprint(home.hm)
app.register_blueprint(account.ac)
```

