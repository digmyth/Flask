
# ORM之SQLAlchemy框架

无从致书以观，每假借于藏书之家，手自笔录，计日以还。

[参考1](http://www.cnblogs.com/wupeiqi/articles/8259356.html)

[参考2](http://www.cnblogs.com/wupeiqi/articles/5713330.html)


### 什么是ORM

ORM（object relation mapping） 对象关系映射关系 ，面向对象的对象模型和关系型数据之间的相互转换。

大白话就是基于类对象的方式操作数据库，一个类对应一张表，一个类对象对应一行数据。

### SQLAlchemy框架

SQLAlchemy是一个基于Python实现的ORM框架。该框架建立在 DB API之上，使用关系对象映射进行数据库操作，简言之便是：将类和对象转换成SQL，然后使用数据API执行SQL并获取执行结果。

```
pip3 install sqlalchemy
```


* Engine:框架的引擎
* Connection Pooling:数据库连接池,用来管理应用程序到数据库的连接
* Dialect:用来对接不同的数据库驱动，这些驱动要实现数据库的DB API:mysql,sqlite,oracle
* Schema/Types: 1.实现了对SQL的DDL(Data Definition Language)的封装，其实就是实现的类对应一张表，对象对应一行数据，SQL Expression Language的操作对象就是这里定义的Table，2.同时也是架构和类型,数据库升降级就是是通过schema控制的（db sync）
* SQL Exprression Language:SQL表达式语言实现了对数据库的SELECT、DELETE、UPDATE等语句的封装，是实现ORM层的基础。 

SQLAlchemy本身无法操作数据库，其必须以来pymsql等第三方插件，Dialect用于和数据API进行交流，根据配置文件的不同调用不同的数据库API，从而实现对数据库的操作，如：
```
MySQL-Python
    mysql+mysqldb://<user>:<password>@<host>[:<port>]/<dbname>
    
pymysql
    mysql+pymysql://<username>:<password>@<host>/<dbname>[?<options>]
    
MySQL-Connector
    mysql+mysqlconnector://<user>:<password>@<host>[:<port>]/<dbname>
    
cx_Oracle
    oracle+cx_oracle://user:pass@host:port/dbname[?key=value&key=value...]
    
更多：http://docs.sqlalchemy.org/en/latest/dialects/index.html
```
