
# SQLAlchemy和Flask结合使用

SQLAlchemy和Flask结合的一个组件: Flask-SQLAlchemy
```
pip3 install Flask-SQLAlchemy
```

基本使用
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
*  db.create_all(app=app) db.drop_all(app=app)用于创建删除数据库
*  class UserInfo(db.Model)中db.Model相当于以前使用的Base

