import datetime
from sqlalchemy import create_engine
from sqlalchemy import Column, Integer, String, Text, ForeignKey, DateTime, UniqueConstraint, Index

from cm import db

##  单表创建
class UserInfo3(db.Model):
    __tablename__ = 'userinfo3'

    id = Column(Integer, primary_key=True)
    name = Column(String(32), index=True, nullable=False)