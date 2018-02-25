# Flask框架学习

## 一、Flask基础

参考博客：  http://www.cnblogs.com/wupeiqi/articles/7552008.html

```
pip3 install flask
```

Django Flask比较
```
Django: 无socket,有中间件，路由系统，视图，模板，ORM，cookie,Session,admin.Form,缓存，信号，序列化
Flask:  无socket,有中间件（弱）路由系统，视图，无模板（三方Jinja2），无orm,有Cookie,Session弱
```

都说flask轻量，体现在哪里，快速上手一个试试

```
from flask import Flask

app = Flask(__name__)
@app.route("/index")
def index():
    return "index..."

if __name__ == '__main__':
    app.run() #app.__call__()
```

路由匹配还可以改为如下，原码就是这么实现的
```
def index():
    return "index..."

app.add_url_rule('/index','n1',index) # 参数分别：url/别名/执行函数
```

flask/app.py`__call__()`方法是程序入口,用于封装用户请求，路由匹配，执行函数，返回结果。
```
def __call__(self, environ, start_response):
    """Shortcut for :attr:`wsgi_app`."""
    return self.wsgi_app(environ, start_response)
```

什么是wsgi?

Web Server gateway interface: web服务网关接口或协议，socket实现的一种封装,用于监听用户请求。

符合wsgi标准的HTTP处理协议其中一个模块wekzeug,flask依赖实现了wsgi的模块werkzeug

用`werkzeug`模块实现一个监听并返回结果
```
from werkzeug.wrappers import Request, Response
from werkzeug.serving import run_simple

@Request.application
def hello(request):
    return Response('Hello World!')

if __name__ == '__main__':
    run_simple('localhost', 4001, hello)  # hello如果是类，将执行call()方法
```


