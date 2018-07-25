因migrate文件注释导致rake错误：
1.取消注释
2.删除migrating表的这条记录
3.执行rake db
4 执行初始化方法
rollback  或者用rails db  mysql 手动加字段

git checkout --patch master /a/b.txt #把master分支上的b.txt文件更新到当前分支

文件已存在导致rake报错：
1.SchemaMigration.judge_migration #跳过已经执行过的迁移
2.bundle exec rake db:migrate
delete from schema_migrations where version=20160728061359;#删除某个版本的迁移文件

一卡通es跑数据：
start_date="2016-09-01"
end_date="2016-09-30"
CardTransaction.remove_load_task　#删除redis已存在的任务
CardTransaction.split_load_task(start_date, end_date)　#按月份的起止时间分解任务
CardTransaction.dump_base_data_to_redis 　#将任务加载到es
nohup rails r CardTransaction.start_load_task & 　#后台执行分解任务
$elastic.indices.delete index:'card_transaction_201609'　 #删除错误索引

部署应用：
1.campus_app, user_campus_app新增应用及用户数据
2.在nginx/conf/vhost下新增school_library.conf文件并配置端口和IP或域名　
3.重启nginx：nginx: ./nginx -s reload
4.修改database.yml数据库连接信息
5.bundle install后启动项目bundle exec unicorn_rails -c unicorn.rb -D -E development

端口配置：
listen 8003;(school_library.conf)
server_name  61.183.159.77;
home_url="http://61.183.159.77:8003/new_library_analysis";(campus_apps数据)<before>>>>>>>>>>>>>>>>>>>>>>>>>
listen 80;
#server_name  61.183.159.77;
listen 8003;
home_url="http://whsxy-tsg.aggso.com:61957/new_library_analysis"<after>>>>>>>>>>>>>>>>>>>>>

域名配置：
listen 80;
server_name whsxy-tsg.aggso.com;(school_library.conf)
home_url="http://whsxy-tsg.aggso.com/new_library_analysis";(campus_apps数据)

bundle exec unicorn_rails -c unicorn.rb -D -E production
bundle exec unicorn_rails -c unicorn.rb -D -E development
bundle exec unicorn_rails -c unicorn.rb -D -E test
rails s -d -b 114.55.73.26 -p 2555 -e development

使用puma:
关于所有的配置参数，https://github.com/puma/puma/blob/master/examples/config.rb
启动重启：bundle exec puma -C config/puma.rb --daemon


Digest::SHA1.hexdigest("123456")
sudo netstat -lpn |grep :80 #查看端口使用情况
gem list|grep unicorn  #查看gem包列表
tail -f log/unicorn.stdeer.log#查看日志
sidekiq:
ps aux|grep sidekiq
cat tmp/pids/sidekiq.pid
bundle exec sidekiq  -d 

redis:
redis-cli #启动本机redis
./redis-server & #后台启动redis
$redis.hset("LibraryBook", x.book_code, x.call_no) #存入redis的key

key="book_type"
book= {"A"=>"马列主义、毛泽东思想、邓小平理论", "B"=>"哲学、宗教", "C"=>"社会科学总论", "D"=>"政治、法律", "E"=>"军事", "F"=>"经济", "G"=>"文化、科学、教育、体育", "H"=>"语言、文字", "I"=>"文学", "J"=>"艺术", "K"=>"历史、地理", "N"=>"自然科学总论", "O"=>"数理科学与化学", "P"=>"天文学、地球科学", "Q"=>"生物科学", "R"=>"医药、卫生", "S"=>"农业科学", "T"=>"工业技术", "U"=>"交通运输", "V"=>"航空、航天", "X"=>"环境科学,安全科学", "Z"=>"综合性图书"} 
$redis.lpush(key,book.to_json) #lpush<=>lrange
JSON.parse($redis.lrange("$redis.smembers("DoorGuard_dates").count",0,-1)[0]) #lrange<=>lpush
$redis.sadd("LibraryBook_ids", "1117232") #sadd
$redis.spop("LibraryBook_ids") #spop
$redis.del("LibraryBook_ids") #del
$redis.keys #查看所有key
$redis.keys.include?("LibraryBook_info") #查看是否含某个key
$redis.hgetall("DEPARTMENT") #查看某个key的所有值
$redis.hgetall("Department_info").count #查看某个key的总数
$redis.smembers("DoorGuard_dates").count #查看sadd进去的数据
JSON.parse($redis.hget("STU_KIND","stu_kind"))

2016.11.07 周一
南京理工es+应用环境部署：
服务器：
web服务器 :192.10.86.18(njustweb)
es集群节点 : 192.10.86.10(njust006), 192.10.86.11(njust007), 192.10.86.12(njust008)，
坑啊：web服务器需要外网访问，请不要随便答应好啦啦啦啦！

1.安装文件准备
git clone git@gitcode.aggso.com:liuxinyu/project_deploy.git #在有外网的服务器，克隆java的jdk文件及es2.3.3安装包
tar xvf jdk-8u111-linux-x64.tar.gz #解压jdk文件
scp -r ./jdk1.8.0_111/ root@192.10.86.12:/root/　#将下载的jdk文件上传至其他内网es集群服务器
scp -r ./es2.3.3 root@192.10.86.12:/home/elastic/　#将下载的es文件上传至其他内网es集群服务器
scp -r -P 252 42010619730825209X-曾祥发.jpg root@221.232.159.150:/pic/teachers_pic/图书馆 

scp -r -P 22 logo.png root@114.55.73.26:/root/projects/ccnu_campus/app/assets/images/campus/dist 
scp -r -P 22 logo.png root@114.55.73.26:/root/projects/ccnu_campus/app/assets/images/warning_scholarship/login
2.安装java
mv jdk1.8.0_111/ /usr/local/java/ #将root/下的java文件放至/usr/local下
update-alternatives --install /usr/bin/java java /usr/local/java/jdk1.8.0_111/bin/java 1000　#修改java优先级
java -version #查看java版本


3.es文件权限
adduser elastic #一路回车，不需要密码，创建elastic用户
cp -r  es2.3.3 ../elastic/　#若已存在elastic文件夹，则先备份其下文件夹内容后，新建用户重新复制内容后删除elastic文件夹
chgrp -R elastic es2.3.3 #修改用户组权限为elastic
chown -R elastic es2.3.3　#修改用户权限为elastic
 chown -R elastic:elastic elastic/
4.配置/es2.3.3/config/elastic.yml
su elastic #配置好文件后，切换elastic进入bin文件下启动es
es集群 :192.10.86.10~12,路径：/home/elastic, 用户：elastic
./elasticsearch -d  --Xmx=12g --Xms=12g #指定内存
2016.11.08 
应用环境部署：
rvm+bundler:
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
gem sources --add https://gems.ruby-china.org/ --remove https://rubygems.org/
 
nginx：/opt/nginx
redis : redis-server /etc/redis/redis.conf &(bind 127.0.0.1 改成 bind 0.0.0.0,任何地址都能访问,未修改)
mongo : /usr/bin/mongod --config /etc/mongodb.conf &（已修改）
mysql : root, njust123(账号密码)，192.10.86.18(ip)

Gemfile 加入 .gitignore	,
gem 'activerecord-oracle_enhanced-adapter', '~> 1.4.0' #使用oracle数据库
gem 'ruby-oci8', '~> 2.0.6'	
依赖关系报错：

oracle : njust/njust, 
sqlplus "njust/njust@orclrac" #连接oracle数据库

source /opt/project_deploy/dashboard.sql
 进入mysql的控制台后，使用source命令执行
Mysql>source 【sql脚本文件的路径全名】 或 Mysql>\. 【sql脚本文件的路径全名】

( redis-server --version)
 (db.version())

scp -r ./campus-warning root@10.231.253.5:/mnt/





	