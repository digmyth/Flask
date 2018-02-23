# Flask框架学习

参考博客：  http://www.cnblogs.com/wupeiqi/articles/7552008.html

pip3 install flask
Django: 无socket,有中间件，   路由系统，视图，模板，ORM，cookie,Session,admin.Form,缓存，信号，序列化
Flask:  无socket,有中间件（弱）路由系统，视图，无模板（三方Jinja2），无orm,有Cookie,Session弱


```
from flask import Flask

app = Flask(__name__)
@app.route("/index")
def index():
    return "index..."

if __name__ == '__main__':
    app.run()
```

什么是wsgi?

Web Server gateway interface: web服务网关接口或协议，socket实现的一种封装。
符合wsgi标准的HTTP处理协议其中一个模块wekzeug,flask依赖实现了wsgi的模块werkzeug


