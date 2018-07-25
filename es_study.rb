require "elasticsearch"


$elastic = Elasticsearch::Client.new hosts: [ '115.28.208.37:9200'], randomize_hosts: true, log: true

#创建或更新一个文档
$client.index index: 'myindex',
             type: 'mytype',
             id: '1',
             body: {
              title: 'Test',
              tags: ['yww'],
              published: true,
              published_at: Time.now.utc.iso8601,
              counter: 1
            }

$client.index index: 'myindex', type: 'mytype', id: '1', body: { title: 'TEST' }, refresh: true
$client.search index: 'myindex', q: 'title:test'

# #用一个特定的过期时间创建一个文档 

# # Decrease the default housekeeping interval first:
# $client.cluster.put_settings body: { transient: { 'indices.ttl.interval' => '1s' } }

# # Enable the `_ttl` property for all types within the index
# $client.indices.create index: 'myindex', body: { mappings: { mytype: { _ttl: { enabled: true } }  } }

# $client.index index: 'myindex', type: 'mytype', id: '1', body: { title: 'TEST' }, ttl: '5s'

# sleep 3 and $client.get index: 'myindex', type: 'mytype', id: '1'
# # => {"_index"=>"myindex" ... "_source"=>{"title"=>"TEST"}}

# sleep 3 and $client.get index: 'myindex', type: 'mytype', id: '1'
# # => Elasticsearch::Transport::Transport::Errors::NotFound: [404] ...



# #创建一个文档
$client.create index: 'hotel',
              type: 'tec',
              id: '100',
              body: {
               title: 'Test 1',
               tags: ['y', 'z'],
               published: true,
               published_at: Time.now.utc.iso8601,
               counter: 1
              }

#get文档
puts $client.get index:'hotel',type:'rujia',id:'1111'
$client.get_source index:'hotel',type:'维也纳国际酒店',id:'1'


# #一次get多个文档
$client.mget index: 'hotel', type: '维也纳国际酒店', body: { ids: ['1', '2', '3'] }#全部文档
$client.mget index: 'hotel', type: '维也纳国际酒店', body: { ids: ['1', '2', '3'] }, fields: ['comment']#文档中的comment


#update更新局部文档
puts $client.update index:'hotel',type:'rujia',id:'1', body:{ doc:{"nihao":"jjj","userId":"000000","valid":10,"walkAim":"00","walkWay":"00"}}
puts $client.update index:'hotel',type:'rujia',id:'1',  body: { script: 'ctx._source.valid += tag',params:{tag:1}}

#批量操作
 $client.bulk body:[
	{index:{_index:'hotel',_type:'rujia',_id:'1111'}},
	{title:"My second blog postMy second blog postMy second blog postMy second blog post" },
	{delete:{_index:'hotel',_type:'rujia',_id:'2'}},
	{update:{_index:'hotel',_type:'rujia',_id:'3'}},
	{doc:{"nihao":"jjj","userId":"000000","valid":10,"walkAim":"00","walkWay":"00"}},
	{create:{_index:'hotel',_type:'rujia',_id:'111111'}},
	{title:"My first blog post" }
 ]

 $client.bulk body:[
	{index:{_index:'hotel',_type:'rujia',_id:'1111',data:{title:"second My  blog"}}},
	{delete:{_index:'hotel',_type:'rujia',_id:'1'}},
	{update:{_index:'hotel',_type:'rujia',_id:'3',data:{doc:{"nihao":"aaaaaa","userId":"11111111"}}}},
	{create:{_index:'hotel',_type:'rujia',_id:'111111',data:{title:"My first blog post"}}}
 	]



# #查询全部字段
$elastic.search index: 'weibo*', q: '从哪来'

#查询字符串
$elastic.search index: 'weibo*',
            body: {
              query: { match: { title: '杨澜' } }
            }


$elastic.search index: 'weibo*',
            body: {
              from:100,size:3,  #可以用来分页
              sort: [
                    { "text_word_count":'desc'}],
              query: { 
              	match: { title: '杨澜' }
              }
            }

#创建索引
# @example Create an index with specific settings, custom analyzers and mappings
$elastic.indices.create index: 'test',
                      body: {
                        settings: {
                          index: {
                            number_of_shards: 1,
                            number_of_replicas: 0
                            # 'routing.allocation.include.name' => 'node-1'
                          }
                        },
                        mappings: {
                          document: {
                            properties: {
                              title: {
                                type: 'multi_field',
                                fields: {
                                    title:  { type: 'string', analyzer: 'snowball' },
                                    exact:  { type: 'string', analyzer: 'keyword' },
                                    ngram:  { type: 'string'}
                                }
                              }
                            }
                          }
                        }
                      }

#获取索引
 $elastic.indices.get_mapping index: 'test'
 
#创建或更新map
 $elastic.indices.put_mapping index: 'test', 
 body: {
 	 mappings: {
      document: {
        properties: {
          desp: { type: 'string', analyzer: 'snowball' }
        }
      }
  	}
   }



# #查询文件是否存在
$client.search_exists index: 'hotel',type:'tec',
 body: {
                query: { match: { creator:'7BB3B05D4C278DFF' } },
                
              }


# #通过范围查找level:要查询的字段
$client.search_template index: 'hotel',
                       body: {
                         template: {
                           query: {
                             range: {
                               level: { gte: "{{start}}", lte: "{{end}}" }
                             }
                           }
                         },
                         params: { start: "4", end: "4" } }


# #一次请求,查询多个
$client.msearch \
  body: [
    { search: { query: { match_all: {} } } },
    { index: 'hotel', type: 'rujia', search: { query: { query_string: { level: '"2"' } } } },
    { search_type: 'count', search: { aggregations: { published: { terms: { field: 'imageCount' } } } } }
  ]

# #删除文档
$client.delete index: 'myindex', type: 'mytype', id: '1'      
$client.delete_by_query index: 'myindex', q: 'title:test'                
$client.delete_by_query index: 'myindex', body: { query: { term: { published: false } } }
****************************************************
#2016.12.14
#ES聚合分为metric(类似avg, max, min方法), bucket(类似group_by方法)
start_date = (Time.now-3.year).strftime("%F")
end_date = Time.now.strftime("%F")
sno="2015305201307"
filter = []
filter<<{range: {borrowed_time: {gte: start_date.to_i,lte: end_date.to_i}}}
filter<<{term:{person_no:sno}}
#>>单值聚合sum求和, min求最小值, max求最大值, avg 求平均值, cardinality 求唯一值，即不重复的字段有多少
response = $elastic.search index: "book_library_infos",body:{
    size: 0,
    query:{
        bool:{
            filter:filter
        }
    },
    aggs: {
        count_return:{
            avg: {field:'gpa_new'}
        }
    }
}
#>>多值聚合percentiles 求百分比,不是很明白？_？
response = $elastic.search index: "book_library_infos",body:{
    size: 0,
    query:{
        bool:{
            filter:filter
        }
    },
    aggs: {
        count_return:{
          percentile_ranks:{
              field:'gpa_new',
              values:[2.5,3.8]
          }
        }
    }
}
#>>多值聚合stats 统计,结果同时展示count, min, max, avg, sum多种聚合结果
#extend stats 扩展统计,在stats统计基础上，增加sum_of_squares, variance, upper, lower等多种结果                
response = $elastic.search index: "book_library_infos",body:{
    size: 0,
    query:{
        bool:{
            filter:filter
        }
    },
    aggs: {
        count_return:{
          extended_stats:{
              field:'gpa_new'
          }
        }
    }
}

 # 构建统计查询
['field1',['field21','field22'],['field31','field32'],'field4']
{aggs:{
  group:[{field:'field1',
          aggs:{
                group:[
                    {field:'field21',
                      aggs:{
                            group:[
                                  {field:'field31',
                                   aggs:{
                                        group:[
                                              {field:'field4'}]
                                        }
                                  },
                                  {field:'field32',
                                   aggs:{
                                        group:[
                                              {field:'field4'}]
                                        }
                                  }]
                            }
                     },
                     {field:'field22',
                      aggs:{
                            group:[
                                  {field:'field31',
                                   aggs:{
                                        group:[
                                              {field:'field4'}]
                                        }
                                  },
                                  {field:'field32',
                                   aggs:{
                                        group:[
                                              {field:'field4'}]
                                        }
                                  }]
                            }
                     }]
                }
          }]
    }
}