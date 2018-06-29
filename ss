
#  xx

http://www.cnblogs.com/wupeiqi/articles/8202353.html

在Flask中运用wtforms

```
# wtforms 生成表单并提交数据时校验数据

from wtforms import form    # 用于继承: form
from wtforms.fields import simple,core,html5  # 用于正则校验和生成标签： 正则regex

from wtforms import validators
from wtforms import widgets    # 插件

class MyForm(form.Form):
    x1 = simple.StringField(
        label='项目名称',
        render_kw={'class':'form-control','placeholder':'项目名称'}
    )

    x2 = simple.StringField(
        label='项目描述',
        render_kw={'class': 'form-control','placeholder':'项目描述'}
    )

    x3 = simple.StringField(
        label='项目地址',
        render_kw={'class':'form-control','placeholder':'项目地址'}
    )

    x4 = core.SelectMultipleField(
        label='主机',
        render_kw={'class': 'form-control'},
        # choices=(        #   如果定义了choices，它就该长这样
        #     ('bj', '北京'),
        #     ('sh', '上海'),
        # ),
        # choices=db.session.query(models.Host.id,models.Host.hostname).all(),  # 不能直接写在这里
        coerce=int
    )

    def __init__(self,*args,**kwargs):
        super(MyForm,self).__init__(*args,**kwargs)
        self.x4.choices = db.session.query(models.Host.id,models.Host.hostname).all()
```

对于上面的`choices=db.session.query(models.Host.id,models.Host.hostname).all()`,为什么不能直接写呢？有几点原因

第一： db.session.query()是一次性取值后赋值，不能做到数据库实时更新

第二： db.session.query()会连接数据库,sql URI放在app的配置文件里，程序启动时会报错，此时请求还没有到到来，哪来的app

故重写构造方法，程序启动时绕过数据库连接，当请求到来时实例化MyForm类才会执行`__init__`方法,这样就能正常取值了并且取得的值是最新的，做到实时更新

# 视图
```
@pr.route("/project/add")
def project_add():

    # ret = db.session.query(models.Host.id,models.Host.hostname).all()
    # print(ret)

    form = MyForm()
    return render_template('project_add.html',form=form)
```
