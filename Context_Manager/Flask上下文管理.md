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

其中构造函数用了object.__setattr__(self, '__ident_func__', get_ident),其实就是self.__ident_func__=get_ident,但为什么不这样写呢，因为下面__setattr__()方法里调用了self.__ident_func__()，会形成死循环。

来看一个在Local()类基础上再次封装的Localstack()栈
```
class LocalStack(object):
    def __init__(self):
        self._local = Local()

    def __release_local__(self):
        self._local.__release_local__()

    def _get__ident_func__(self):
        return self._local.__ident_func__

    def _set__ident_func__(self, value):
        object.__setattr__(self._local, '__ident_func__', value)
    __ident_func__ = property(_get__ident_func__, _set__ident_func__)
    del _get__ident_func__, _set__ident_func__

    def __call__(self):
        def _lookup():
            rv = self.top
            if rv is None:
                raise RuntimeError('object unbound')
            return rv
        return LocalProxy(_lookup)

    def push(self, obj):
        """Pushes a new item to the stack"""
        rv = getattr(self._local, 'stack', None)
        if rv is None:
            self._local.stack = rv = []
        rv.append(obj)
        return rv

    def pop(self):
        """Removes the topmost item from the stack, will return the
        old value or `None` if the stack was already empty.
        """
        stack = getattr(self._local, 'stack', None)
        if stack is None:
            return None
        elif len(stack) == 1:
            release_local(self._local)
            return stack[-1]
        else:
            return stack.pop()

    @property
    def top(self):
        """The topmost item on the stack.  If the stack is empty,
        `None` is returned.
        """
        try:
            return self._local.stack[-1]
        except (AttributeError, IndexError):
            return None
```

...
