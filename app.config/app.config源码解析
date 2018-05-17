# app.config源码解析

时间过得真快，一天天的，其实今天一整天也没有做什么，不知不觉又是晚上，那就闲来写写吧.

在Flask里最常用变量就secret_key = 'sfadf',这个变量可以直接写在主程序里，但更多的是写在app.config['xxx'] = 'yyy'

变量一多不免繁锁，那么app.config到底是个什么呢？还有哪些更程序化的配置方法呢？

通过源码可知：
```
from flask import Flask
app = Flask(__name__)
# 相当于aap.config就是一个字典
# app.config=make_config(instance_relative_config)=config_class(root_path, self.default_config)=Config(dict)
```



