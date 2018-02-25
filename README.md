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

## @app.route()原理

明显是装饰器用法，那么就有必要复习下装饰器了

无参装饰器
```
def wrapper(func):
    def inner(*args,**kwargs):
        return func(*args,**kwargs) + 'code'
    return inner

@wrapper
def func(arg):
    return arg
```

有参数的装饰器
```
def outer(arg):
    def wrapper(func):
        def inner(*args,**kwargs):
            return func(*args,**kwargs) + arg
        return inner
    return wrapper

@outer('666')  # @wrapper
def func(arg):
    return arg

x=func('123')
print(x)
```

@app.route('/index')就是有参数装饰器的用法

```
def route(self, rule, **options):
    def decorator(f):
        endpoint = options.pop('endpoint', None)
        self.add_url_rule(rule, endpoint, f, **options)
        return f
    return decorator
```

## flask实现登录

动手写一个flask实现登录来带入falsk基本知识的学习

app.py
```
from flask import Flask,render_template,request

app = Flask(__name__)

@app.route('/login',methods=['GET','POST'])
def login():
    if request.method == 'GET':
        return render_template('login.html')
    else:
        user = request.form.get("user")
        pwd = request.form.get("pwd")
        if user == 'wxq'  and pwd=='123':
            return 'welcomte to sites'
        return render_template('login.html',msg="用户名或密码错误")

if __name__ == '__main__':
    app.run()
```

当前目录下templates/login.html
```
<h1>登录</h1>
<form method="post">
    <p><input type="text" name="user"></p>
    <p><input type="text" name="pwd"></p>
    <input type="submit" value="提交">{{ msg }}
</form>
```

简单系统登录就实现了，那么


```
print(request.query_string)  #  get
print(request.form) # post 
print(request.values)  # get and post
print(request.method)  # 请求方法
```

