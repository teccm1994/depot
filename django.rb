学业诊断django项目开发
1.环境配置
>git clone --recursive git@gitcode.xjgreat.com:xuegong_django/comprehensive_management.git
# 下载项目
>pip install -r requirements/local.txt #安装所需包
>.env #配置项文件
>interpreter中配置环境变量

2.应用拆分
规则管理,schoolwork_rules
权重管理,weights
任务管理,tasks

首页,home
学情查询-学情检索,learning_retrieve
学情查询-学风诊断,school_styles
学情查询-评优检索,excellent_searches
学前评估,before_schoolworks
学期分析,schoolworks
毕业管理,after_schoolworks
学生管理,student_managements

3.model层
AppConfig:基类描述了一个Django应用以及它的配置信息,部分配置项说明：
	name:django app的完整Python路径名
	app_label:唯一的名字，默认是name的最后部分
	verbose_name:别名，默认是label.title()

class Meta:元数据就是"不是一个字段的任何数据",常用可配置选项：
	ordering:返回的记录结果集按字段排序
	verbose_name:给模型类取别名
	verbose_name_plural:指定模型的复数形式，默认为verbose_name+"s"

执行model修改:python manage.py migrate --database=schoolwork
报错:django.core.exceptions.ImproperlyConfigured: Set the DEFAULT_DATABASE_URL environment variable
解决:export PYTHONUNBUFFERED=1 && export DJANGO_SETTINGS_MODULE=config.settings.local && export DJANGO_READ_DOT_ENV_FILE=True  && python manage.py migrate --database=schoolwork
 继续报错:ModuleNotFoundError: No module named 'custom_helper'
 解决:manage.py中current_path追加common_apps配置，base.py中新增SCHOOLWORK_APPS配置

python manage.py migrate --fake myappname zero #This reset all migrations
python manage.py migrate myappname

4.编写API的步骤
1)model表定义
2)在app下的serializers.py序列化文件，编写对应序列化代码
3)在app下的view中定义API方法
4)在app下的urls.py中添加对应的路由
5)在页面上查看api列表




问题：
1.为什么指定模型复数形式为字符串？
SchoolworkWeight.objects.create(name="学前预警", weight=50, published=True, desc="学前评估", created_user_id=1,created_by="初始化", updated_user_id=1, updated_by="初始化",created_at=datetime.now,updated_at=datetime.now)

SchoolworkWeight.objects.create(name="学前预警", weight=50, published=True, desc="学前评估", created_user_id=1,created_by="初始化", updated_user_id=1, updated_by="初始化")








