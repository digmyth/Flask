class Base():
    SECRET_KEY = 'sdfsdf'
    SQLALCHEMY_DATABASE_URI = 'mysql+pymysql://root:qoioy@192.168.1.8:3306/db1?charset=utf8'
    SQLALCHEMY_POOL_SIZE = 10
    SQLALCHEMY_TRACK_MODIFICATIONS = False

class Dev(Base):
    pass
