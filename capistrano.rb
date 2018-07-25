1，部署项目地址，在github上上传depot项目，保证本机和github可通信
2，服务器上相关环境部署，ruby，rails，unicorn，capistrano
3，部署做的事情是什么，如何实现的，弄清楚原理
4，开始部署

1.1 创建本地git库
	创建项目，即本地仓库
	git init，初始化git仓库，生成.git隐藏文件夹
	git add > git commit，添加文件到git仓库

	git config命令的--global参数，用了这个参数，表示这台机器上所有的Git仓库都
	会使用这个配置；针对某个仓库指定不同的用户名和Email地址，可在项目根目录
	下进行单独配置：
	$ git config user.name "gitlab's Name"
	$ git config user.email "gitlab@xx.com"
	$ git config --list #查看当前配置, 在当前项目下面查看的配置是全局配置+当前项目
	#的配置, 使用的时候会优先使用当前项目的配置

	①同一台本机连接两个git账号，email地址不一样，本机保存两个id_rsa.pub文件？
	http://www.cnblogs.com/qingguo/p/5686247.html，暂未解决
1.2 添加远程库
	在github上创建一个项目仓库
	git remote add origin git@github.com:teccm1994/depot.git
	git push -u origin master

2.1 环境版本
	ruby : ruby 2.0.0p648
	rails  : Rails 4.2.5.1
	unicorn : unicorn v5.1.0
2.2 安装capistrano
	需要在服务器上安装，还是在项目中引用gem即可？
	staging.rb文件配置问题，keys是服务器上的密钥？

3.1 capistrano : 可靠地将Web应用程序部署到任何数量的机器上，同时，在序列或作为一个滚动集;
	      任何数量的机器自动审核（检查登录日志，列举的正常运行时间，应用安全补丁）;
	      在SSH脚本任意工作流;
	      在软件团队中实现常见的任务.
工具：可互换的输出格式（过程、HTML等）；易于添加的其他源代码管理控制软件的支持；
	     运行Capistrano交互基本多控制台；主机和角色过滤器部分部署，或部分群维护；
	     数据库迁移；复杂环境的支持。
要求：Ruby版本2.0或更高版本；git管理控制的项目；scm检查需要部署的项目；bundler
        	     参考：https://github.com/capistrano/capistrano/blob/master/README.md
