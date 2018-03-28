# Flask框架入门到源码

## 一、前言

Flask分为几大版块学习

* Flask 快速入门
* Flask 框架学习
* Flask 本地线程
* Flask 上下文管理
* Flask DBUtils连接池
* Flask Session会话
* Flask Signal信号
* Flask 特殊的装饰器
* Flask WTForm插件
* Flask SQLAlchemy

## Flask 快速入门

参考博客：  http://www.cnblogs.com/wupeiqi/articles/7552008.html

### 快速上手
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

### 反向生成URL

flask也可以反向生成URL，利用url_for,用法如下
```
from flask import Flask,url_for

app = Flask(__name__)

@app.route('/index',methods=['GET','POST'],endpoint='n1')
def index():
    x=url_for('n1')
    print(x)
    return 'test pagess ...'

if __name__ == '__main__':
    app.run()
```

###  URL传参

```
from flask import Flask

app = Flask(__name__)

@app.route('/index/<int:nid>')
def index(nid):
    print(nid)
    return '%s' % nid

if __name__ == '__main__':
    app.run()
```
可以看出指定了数据类型int整型，默认也是整型，但有时整型，有时浮点型，有时字符串，怎么弄，注意flask里面不支持正则表达式

？？问题，有办法？？

在这种URL有可变参数的情况下要反向生成URL，反向生成URL如何传参，方法如下：

```
from flask import Flask,url_for

app = Flask(__name__)

@app.route('/index/<int:nid>',endpoint='n1')
def index(nid):
    x=url_for('n1',nid=888)
    print(x)
    return '%s' % nid

if __name__ == '__main__':
    app.run()
```


## Flask 框架架构

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

符合wsgi标准的HTTP处理协议其中一个模块wekzeug,flask依赖实现了wsgi的模块werkzeug,本质就是创建socket监听请求和转发请求。

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

@app.route('/index')就是有参数装饰器的用法,其中endpoint是用于反向生成URL的别名

```
def route(self, rule, **options):
    def decorator(f):
        endpoint = options.pop('endpoint', None)
        self.add_url_rule(rule, endpoint, f, **options)
        return f
    return decorator
```

那么flask路由规则就可以改写成app.add_url_rule('/index','n1',index)


即然@app.router(*args,**kwargs) 可以传参，那么都可以传哪些参数呢？

可以传url,methods,endpoint,defaults

defaults是url上不必传参，但视图函数需要参数，此时可以用defaults传参

```
from flask import Flask

app = Flask(__name__)

@app.route('/index/<int:nid>',defaults={'cid':100})
def index(nid,cid):
    print(nid,cid)
    print(type(nid))
    return str(nid+cid)

if __name__ == '__main__':
    app.run()
```

@app.router(*args,**kwargs)更多可传参数
```
endpoint=None,              名称，用于反向生成URL，即： url_for('名称')
methods=None,               允许的请求方式，如：["GET","POST"]


strict_slashes=None,        对URL最后的 / 符号是否严格要求，
                            如：
                                @app.route('/index',strict_slashes=False)，
                                    访问 http://www.xx.com/index/ 或 http://www.xx.com/index均可
                                @app.route('/index',strict_slashes=True)
                                    仅访问 http://www.xx.com/index 
redirect_to=None,           重定向到指定地址
                            如：
                                @app.route('/index/<int:nid>', redirect_to='/home/<nid>')
                                或
                                def func(adapter, nid):
                                    return "/home/888"
                                @app.route('/index/<int:nid>', redirect_to=func)
subdomain=None,             子域名访问
                                    from flask import Flask, views, url_for

                                    app = Flask(import_name=__name__)
                                    app.config['SERVER_NAME'] = 'wupeiqi.com:5000'


                                    @app.route("/", subdomain="admin")
                                    def static_index():
                                        """Flask supports static subdomains
                                        This is available at static.your-domain.tld"""
                                        return "static.your-domain.tld"


                                    @app.route("/dynamic", subdomain="<username>")
                                    def username_index(username):
                                        """Dynamic subdomains are also supported
                                        Try going to user1.your-domain.tld/dynamic"""
                                        return username + ".your-domain.tld"


                                    if __name__ == '__main__':
                                        app.run()
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

简单系统登录就实现了，其中用到的知识点

request封装请求相关数据

```
print(request.args)  # get,类似字典形式
print(request.query_string)  #  get，为字符串
print(request.form) # post 
print(request.values)  # get and post
print(request.method)  # 请求方法
```

其它封装数据
```
# 请求相关信息
        # request.args
        # request.cookies
        # request.headers
        # request.path
        # request.full_path
        # request.script_root
        # request.url
        # request.base_url
        # request.url_root
        # request.host_url
        # request.host
        # request.files
        # obj = request.files['the_file_name']
        # obj.save('/var/www/uploads/' + secure_filename(f.filename))

        # 响应相关信息
        # return "字符串"
        # return render_template('html模板路径',**{})
        # return redirect('/index.html')

        # response = make_response(render_template('index.html'))
        # response是flask.wrappers.Response类型
        # response.delete_cookie('key')
        # response.set_cookie('key', 'value')
        # response.headers['X-Something'] = 'A value'
        # return response
```


s117
app.secret_key  = 'sss'
session['user_info'] = user

if session.get('user_info'): pass

s118
内容：
1 路由系统
2 视图函数
3 请求和响应 request.GET.urlencode()
4 模板语言
5 session
6 blueprint
7 闪现， 依赖session
8 扩展或称特殊装饰器，类似中间件的东西
9 数据库连接池


内容回顾：
实例化Falsk对象：__name__ 静态文件路径static_folder='static'，静态文件前缀static_url_path，模板路径template_forder
路由关系： 2种方式，
request
    request.args
    request.form
    request.values
    
response
    render_template()
    redirect()
    ''
    
    v=make_response('back_value')
    ? cookie/响应关，make_response()来加工对set_cookie的实现
    
    session remember add  app.secrect_key 回顾完
    
