#Elasticsearch 重启
1.关闭负载均衡(在一台服务器上重启即可)
curl -XPUT bdnode06:9200/_cluster/settings -d '{"transient":{"cluster.routing.allocation.enable": "none"}}' , 
2.关闭要调整的单个，多个或全部节点 ps aux|grep elastic(ps -ef|grep elastic),  cd ../home/elastic/es2.3.3/bin, su elastic
3.重启要调整的单个，多个或全部节点 ./elasticsearch -d --Xmx=12g --Xms=12g    
4.重启负载均衡等待集群状态变绿
curl -XPUT bdnode02:9200/_cluster/settings -d '{"transient":{"cluster.routing.allocation.enable": "all"}}'
1.count 返回索引文档数量 #Get the number of documents for the cluster, index, type, or a query
  a.$elastic.count #返回集群中所有文档数
  b.$elastic.count index:'card_transaction_201605' #返回某索引所有文档数
  c.$elastic.count index:'card_transaction_201605',body:{filter:{term:{sno:"2015301580014"}}} #返回符合某条件

#服务器清理缓存
sync # 释放前最好sync一下，防止丢数据
echo 3 > /proc/sys/vm/drop_caches
dmidecode | grep -A16 "Memory Device$" #查看内存条数
top#查看进程所占内存
free -h #查看服务器内存大小
echo 1 > /proc/sys/vm/drop_caches #(清理缓存)
echo > development.log #删除文件内容
: > filename #：是一个占位符，不会产生任何输入
ps aux输出格式：
USER PID %CPU %MEM VSZ RSS TTY STAT START TIME COMMAND
 
#Es出现open file错误时
1 查看进程的limits：cat /proc/{pid}/limits   
2 设置limts在root用户下：ulimit -n 200000
3 查看limits： ulimit -a

#动态设置复制分片数量
curl -XPUT 'fdbg06:9200/card_transaction_201608/_settings' -d '
{
    "index" : {
        "number_of_replicas" : 1
    }
}'

#es单个索引状态变red
$elastic.cat.allocation format:'json' #查看每个节点的shards分配情况
=>[{"shards":"292","disk.indices":"10.6gb","disk.used":"123.4gb","disk.avail":"368.6gb","disk.total":"492.1gb","disk.percent":"25","host":"192.168.10.35","ip":"192.168.10.35","node":"node-1"},
{"shards":"297","disk.indices":"10.6gb","disk.used":"54.7gb","disk.avail":"437.4gb","disk.total":"492.1gb","disk.percent":"11","host":"192.168.10.34","ip":"192.168.10.34","node":"node-1"},
{"shards":"11","disk.indices":null,"disk.used":null,"disk.avail":null,"disk.total":null,"disk.percent":null,"host":null,"ip":null,"node":"UNASSIGNED"}]   
这个是allocation 的，多了最后一条，重启后索引正常，分片正常
参考：http://blog.csdn.net/lisonglisonglisong/article/details/50728256

安装结束后后台启动es集群：./elasticsearch -d --Xmx=12g --Xms=12g
#curl命令
curl '192.168.2.184:9200/_cat/health?v' #查看集群健康
curl '192.10.86.10:9200/_cat/nodes?v' #查看节点情况
curl '192.10.86.18:80' #查看是否被转发访问
/opt/nginx$ curl localhost:8004 #在路径下看是否正常访问
curl 'bdnode05:9200/library_books/_mapping?pretty'#查看服务器mapping信息
curl 'bdnode06:9200/_cat/nodes'
curl 'bdnode02:9200/_cat/health'
curl '192.168.2.182:9200/_cat/indices'

puts Campus::Core::config.elastic.cat.indices
Campus::Core::config.elastic.count index:'xj_app_campus_undergraduate_students'
response = Campus::Core::config.elastic.search index:'xj_app_campus_undergraduate_students',body:{size:10,query:{bool:{filter:[]}},sort:[{ "created_at":'desc'}]}
response = Campus::Core::config.elastic.search index:'card_transaction_201711',body:{size:10,query:{bool:{filter:[]}},sort:[{ "transaction_time":'desc'}]}
Campus::Core::config.elastic.indices.get_mapping index:"card_transaction_201712"

#查询语句
$elastic #查看服务器连接信息
$elastic.cat.nodes #查看节点
$elastic.indices.get_mapping index:"" #查看某个索引的映射
$elastic.indices.delete index:"net_loan_url_*"
$elastic.cat.indices index:'net_loan_url_*' #查看某个索引的状况
$elastic.count index:'undergraduate_students' #查看某个索引的记录数
$elastic.delete index: 'warning_logs', type: 'warning_log', id: id #删除某条记录
$elastic.search index:'teacher_books' #默认返回10条数据
SportResult.search(query:{bool:{must:{term:{id:id}}}}).results.first #查询某条记录
UndergraduateStudent.search(query:{match_all:{}}).results.first #匹配所有
#测试语句
response = $elastic.search index:'undergraduate_students',body:{size:10,query:{bool:{filter:[]}}}
response["hits"]["hits"][0]
response["hits"]["hits"][0]["_source"]["wno"]
response = $elastic.search index:'undergraduate_students',body:{size:0,query:{bool:{filter:[term:{:department_name_no=>"计算机学院"}]}}}

filter = []
filter<<{term:{department_name:'计算机学院'}}
filter<<{range: {publish_year: {gte: (Time.now-10.year).year.to_s,lte: Time.now.year.to_s}}}
response = $elastic.search index: "teacher_books",body:{
    size: 0,
    query:{
        bool:{
            filter:filter
        }
    }
}

