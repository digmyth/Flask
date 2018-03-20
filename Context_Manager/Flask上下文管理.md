## Flask上下文管理

### 简单定义

上下文管理定义：(这里仅限于flask内部定义的上下文)

所谓上下文管理就是对用户请求相关所有数据在程序传递的过程中如何管理，也就是请求管理机制,类似于本地线程的这种堆栈实现

实现本质：当每个用户请求进来之后，将请求相关数据封装为一个对象，把这个对象放在Localstack()堆栈中，内部在一个列表中使用时，top()方法取出,请求结束，request从Localstack()堆栈中移除


## 上下文代码

类似于本地线程实现，不是原生本地线程,Flask自己创建的Local/localstack堆栈，

类似封装为如下格式
```
{'xxx':{'stack': [RequestContext('env')]}}
```

在看源代码之前先来补个知识点functools.partial(), 作用是封装一个参数在内部，返回新的函数，当调用新的函数时不必再传入这个参数，为什么flask里的request不是一级一级传递，就是因为这个partial封装实现的。

```
functools.partial()

functools.partial()是为一个函数自动传入一个值，返回一个新的函数
from functools import partial

def func(arg):
    return arg + 100

newfunc = partial(func,25)
x=newfunc()
print(x)
```

来看一下类似于本地线程的Local()类
```
from flask import session,request
try:
    from greenlet import getcurrent as get_ident
except ImportError:
    try:
        from thread import get_ident
    except ImportError:
        from _thread import get_ident

class Local(object):
    __slots__ = ('__storage__', '__ident_func__')

    def __init__(self):
        object.__setattr__(self, '__storage__', {})
        object.__setattr__(self, '__ident_func__', get_ident)

    def __iter__(self):
        return iter(self.__storage__.items())


    def __release_local__(self):
        self.__storage__.pop(self.__ident_func__(), None)

    def __getattr__(self, name):
        try:
            return self.__storage__[self.__ident_func__()][name]
        except KeyError:
            raise AttributeError(name)

    def __setattr__(self, name, value):
        ident = self.__ident_func__()
        storage = self.__storage__
        try:
            storage[ident][name] = value
        except KeyError:
            storage[ident] = {name: value}

    def __delattr__(self, name):
        try:
            del self.__storage__[self.__ident_func__()][name]
        except KeyError:
            raise AttributeError(name)

_local = Local()
_local.stack = []
print(_local.__storage__)
print(_local.__ident_func__())
print(_local.__storage__[_local.__ident_func__()])
```
其中构造函数用了`object.__setattr__(self, '__ident_func__', get_ident)`,其实就是`self.__ident_func__=get_ident`,但为什么不这样写呢，因为下面__setattr__()方法里调用了self.__ident_func__()，会形成死循环。
