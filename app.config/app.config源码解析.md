# app.config源码解析

时间过得真快，一天天的，其实今天一整天也没有做什么，不知不觉又是晚上，那就闲来写写吧.

在Flask里最常用变量就secret_key = 'sfadf',这个变量可以直接形如Key,value写在主程序里，但更多的是app.config['xxx'] = 'yyy'形式封装在app.config里.

变量一多不免繁锁，那么app.config到底是个什么呢？还有哪些更程序化的配置方法呢？


通过源码可知：
```
from flask import Flask
app = Flask(__name__)
# 相当于aap.config就是一个字典
# app.config=make_config(instance_relative_config)=config_class(root_path, self.default_config)=Config(dict)
```

Note that: aa['xx'] 一般2种情况：一种是如下类，访问类的 __setitem__(self, key, value)方法
```
class Foo():
    def __setitem__(self, key, value):
        self.key = value
        print(key,value)

obj = Foo()
obj['xx'] = 123
```

一种是字典，app.config就是继承字典
```
class Foo(dict):
    def __init__(self,args):
        # super(Foo,self).__init__(args)
        dict.__init__(self,args)

    def __str__(self):
        return self

obj = Foo({'xxx':123})
obj['name'] = 'wxq'
print(obj)  # obj.__str__
```

找到Config(dict)类，里面有如下方法,所有配置都在这里处理完成.
```
import os
import types
class Config(dict):
    def __init__(self, root_path, defaults=None):
        dict.__init__(self, defaults or {})
        self.root_path = root_path

    def from_envvar(self, variable_name, silent=False):
        pass

    def from_pyfile(self, filename, silent=False):
        pass

    def from_object(self, obj):
        pass

    def from_json(self, filename, silent=False):
        pass

    def from_mapping(self, *mapping, **kwargs):
        pass

    def get_namespace(self, namespace, lowercase=True, trim_namespace=True):
        pass
```

## 配置方法一

当作字典存取数据，没什么可讲的
```
from flask import Flask
app = Flask(__name__)

app.config['name'] = 'wxq'
print(app.config['name'])
```

## 配置方法二

基于文件settings.py
```
# settings.py
MM = 'xxdf'
```

```
app.config.from_pyfile('settings.py')
print(app.config['MM'])   # 取出settings.py里的变量
```

源码
```
    def from_pyfile(self, filename, silent=False):
        filename = os.path.join(self.root_path, filename)
        d = types.ModuleType('config')
        d.__file__ = filename
        try:
            with open(filename, mode='rb') as config_file:
                exec(compile(config_file.read(), filename, 'exec'), d.__dict__)
        except IOError as e:
            if silent and e.errno in (errno.ENOENT, errno.EISDIR):
                return False
            e.strerror = 'Unable to load configuration file (%s)' % e.strerror
            raise
        self.from_object(d)  # d相当于类名 
        return True

    def from_object(self, obj):
        if isinstance(obj, string_types):
            obj = import_string(obj)
        for key in dir(obj):
            if key.isupper():
                self[key] = getattr(obj, key)

    def from_json(self, filename, silent=False):
        filename = os.path.join(self.root_path, filename)

        try:
            with open(filename) as json_file:
                obj = json.loads(json_file.read())
        except IOError as e:
            if silent and e.errno in (errno.ENOENT, errno.EISDIR):
                return False
            e.strerror = 'Unable to load configuration file (%s)' % e.strerror
            raise
        return self.from_mapping(obj)
```








## 配置方法三
```
import types

d = types.ModuleType('config') # __name__ = config
d.__file__ = 'settings.py'     #  __file__ = settings.py
with open('settings.py','rb') as f:
    exec(compile(f.read(),'settings.py','exec'),d.__dict__)  #定义的变量读出来放在d.__dict__ = {}字典里
print(dir(d)) # ['MM', '__builtins__', '__doc__', '__file__', '__loader__', '__name__', '__package__', '__spec__']

for key in dir(d):
    if key.isupper():
        x=getattr(d,key)
        print(x)
```
