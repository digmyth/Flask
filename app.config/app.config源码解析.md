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


## 配置方法一
```

```

## 配置方法二
```

```

## 配置方法三
```

```
