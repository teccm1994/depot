1.多数据库连接及配置
Python和数据库连接的宏观架构：
1) 建立和数据库系统的连接
2) 获取操作游标
3) 执行SQL，创建一个数据库（当然这一步不是必需的，因为我们可以用已经存在的数据库）
4) 选择数据库
5) 进行各种数据库操作
6) 操作完毕后，提交事务（这一步很重要，因为只有提交事务后，数据才能真正写进数据库）
7) 关闭操作游标
8) 关闭数据库连接


2.pagination分页做全局配置
3.geography应用
4.序列化与反序列化:序列化是为了返回json格式的数据给客户端查看和使用数据，那么当客户端需要修改、增加或者删除数据时，就要把过程反过来了，也就是反序列化，把客户端提交的json格式的数据反序列化。
5.viewsets
6.router路由处理

pip free > requirements.txt
pip -r install requirements.txt

1, settings.py数据库的配置,有几个库配几个
2, 比方生成了应用geography, 需要先配置geography/apps.py.    app_label, name, verbose_name
3, Models搬运原来的表, 声明非ID字段的主外键关联关系, 这个model实例在Console下的名称, verbose_name和verbose_name_plural
4, 强制书写serializers.py，views.py
5, views,py里每一个类都要提供一个集合对象 queryset = Zone.objects.all()
6, 在urls.py里注册路由

Django编写RESTful API学习:
http://www.cnblogs.com/zivwong/p/7427394.html
1.RESTful编写API
2.请求和响应,request与状态码,@api_view装饰器用在基于视图的方法上
3.APIView类用在基于视图的类上,轻松地构成可重复使用的行为
mixins可简化代码->generics进一步简化
4.认证和权限



