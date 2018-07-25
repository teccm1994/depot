#IntegratedReadAnalysisController
#年度借阅量
def library_year_analysis
	start_date=(Time.now.beginning_of_year).strftime("%F")
	end_date=(Time.now.end_of_year).strftime("%F")
	filter=[]
	filter<<{range:{borrowed_time:{gte:start_date,lte:end_date}}}
	 response = $elastic.search index: "book_library_infos",body:{
	         size: 0,
	         query:{
	             bool:{
	                 filter:filter
	             }
	         }
	     }
	     #年度书籍借阅总量
	     @year_total=response["hits"]["total"]#313254
	     #总借阅量
	     @all_total = $elastic.count index:'book_library_infos'#372669,
	     response = $elastic.search index: "book_library_infos",body:{
          size: 0,
          query:{
              bool:{
                  filter:filter
              }
          },
          aggs: {
              month_average:{
                  terms: {field:'borrowed_month',size:0,order:{_term:"asc"}}
              }
          }
      }
      @month_average={}
      response["aggregations"]["month_average"]["buckets"].each do |x|
      		@month_average.merge!({x["key"]=>x["doc_"]})
      end
#============================================================
   	start_date=(Time.now.beginning_of_year).strftime("%F")
	end_date=(Time.now.end_of_year).strftime("%F")
	filter=[]
	filter << {"borrowed_time"=>{gte: start_date,lte: end_date}}
	query_hash = {
        query:{
            must:filter
        }
    }
   	response=book_library_infos_api(query_hash)
     #年度书籍借阅总量
     @year_total=response["hits"]["total"] #313254,
     query_hash = {
        query:{
            must:[]
        }
    }
    response=book_library_infos_api(query_hash)
     #总借阅量
     @all_total = response["hits"]["total"]#372669,
     hash = {group:[{field:'borrowed_month',size: 0,order:{_term:"asc"}}]}
     query_hash = {
        query:{
            must:filter
        },
        aggs:hash
    }
    response=book_library_infos_api(query_hash)
    @month_average={}
     response["aggregations"]["terms_borrowed_month"]["buckets"].each do |x|
     		@month_average.merge!({x["key"]=>x["doc_count"]})
     end
end		

def book_library_infos_api(query_hash)
 	request_params={}
    request_params[:conditions] = query_hash
    request_params[:debug]=true
    request_url = "hnapi.aggso.com/open_api/library/borrows_detail/statistics"
    request_params[:access_token] = CampusDataApi.access_token
    body = RestClient.post(request_url,request_params.to_json,:content_type => :json)
    response = JSON.parse(body)
    return response
end

#社会/自然科学top5
def social_top5_library
	start_date=(Time.now.beginning_of_year).strftime("%F")
	end_date=(Time.now.end_of_year).strftime("%F")
	social_type = BOOK_TYPE.to_a[0..10].to_h.values
	natural_type = BOOK_TYPE.to_a[11..21].to_h.values
	hash = {group:[{field:'book_name',size:0,order:{_term:"desc"}}]}
	filter=[]
	filter << {"borrowed_time"=>{gte: start_date,lte: end_date}}
	filter << {"category_1st"=>social_type}
	 query_hash = {
        query:{
            must:filter
        },
        aggs:hash
    }
 response=book_library_infos_api(query_hash)
social_order={}
response["aggregations"]["terms_book_name"]["buckets"].each do |x|
social_order.merge!({x["key"]=>x["doc_count"]})
end
@social_order=social_order.sort{|x,y| y[1]<=>x[1]}.first(5).to_h
end

#总借阅top10
def top10_library
	start_date=(Time.now.beginning_of_year).strftime("%F")
	end_date=(Time.now.end_of_year).strftime("%F")
	hash = {group:[{field:'book_name',size:0,order:{_term:"desc"}}]}
	filter=[]
	filter << {"borrowed_time"=>{gte: start_date,lte: end_date}}
	 query_hash = {
        query:{
            must:filter
        },
        aggs:hash
    }
 response=book_library_infos_api(query_hash)
social_order={}
response["aggregations"]["terms_book_name"]["buckets"].each do |x|
social_order.merge!({x["key"]=>x["doc_count"]})
end
@social_order=social_order.sort{|x,y| y[1]<=>x[1]}.first(10).to_h
end

#各院系人均借阅排行top10>>人均借阅量
def department_library_top10
	start_date=(Time.now.beginning_of_year).strftime("%F")
	end_date=(Time.now.end_of_year).strftime("%F")
	hash = {group:[{field:'department_name',size: 0,order:{_term:"asc"},aggs:{value_count:[{field:'book_code'}]}}]}
    filter = []
    filter << {"person_type"=>"0"}
    filter << {"borrowed_time"=>{gte: start_date,lte: end_date}}
    query_hash = {
        query:{
            must:filter
        },
        aggs:hash
    }
 response=book_library_infos_api(query_hash)
  if !response.blank?
      @department_count={}
      response["aggregations"]["terms_department_name"]["buckets"].each do |x|
        if x["key"]!=""
          @department_count.merge!({x["key"]=>x["doc_count"]})
        end
      end
    end
    @department_count=@department_count.sort{|x,y| y[1]<=>x[1]}.first(10).to_h

    #借阅来源
    url="hnapi.aggso.com/open_api/library/borrows_detail/statistics"
    start_date=(Time.now.beginning_of_year).strftime("%F")
	end_date=(Time.now.end_of_year).strftime("%F")
	hash = {group:[{field:'department_name',size: 10}]}
    filter = []
    filter << {"person_type"=>"0"}
    filter << {"borrowed_time"=>{gte: start_date,lte: end_date}}
    query_hash = {
        query:{
            must:filter
        },
        aggs:hash
    }
 	response=CommonQuery.group_result(query_hash,url)
 	department_order = {}
 	response["aggregations"]["terms_department_name"]["buckets"].each do |x|
        if x["key"]!=""
          department_order.merge!({x["key"]=>x["doc_count"]})
        end
      end
end

#学生&老师借阅情况>人均借阅量
def student_and_teacher_infos
	start_date=(Time.now.beginning_of_year).strftime("%F")
	end_date=(Time.now.end_of_year).strftime("%F")
	 filter = []
    filter << {"borrowed_time"=>{gte: start_date,lte: end_date}}

     #学生
	 filter << {"person_type"=>"0"}
      query_hash = {
          query:{
              must:filter
          }
      }
    response=book_library_infos_api(query_hash)
    stu_library = response["hits"]["total"]#295686

    end_year = Time.now.year
    month = Time.now.month
    if month<9
      start_year = end_year.to_i-4
    else
      start_year = end_year.to_i-3
    end
    filter = []
    filter << {"admission_grade"=>{gte: start_year.to_s,lte: end_year.to_s}}
    query_stu_hash ={
          query:{
              must:filter
          }
      }
    request_params={}
    request_params[:conditions] = query_stu_hash
    request_params[:debug]=true
    request_url = "hnapi.aggso.com/open_api/student/infos_detail/statistics"
    request_params[:access_token] = CampusDataApi.access_token
    body = RestClient.post(request_url,request_params.to_json,:content_type => :json)
    res_stu = JSON.parse(body)
    stu_total = res_stu["hits"]["total"]#28859
    @student_average = (stu_library/stu_total.to_f).round(1)

    #老师
    filter=[]
    filter << {"person_type"=>"1"}
      query_hash = {
          query:{
              must:filter
          }
      }
    response=book_library_infos_api(query_hash)
    teacher_library = response["hits"]["total"]

    options = []
    options << {"status_name"=>"在岗"}
    query_tea_hash = {
          query:{
              must:options
          }
      }
    request_params={}
    request_params[:conditions] = query_tea_hash
    request_params[:debug]=true
    request_url = "hnapi.aggso.com/open_api/employee/infos_detail/statistics"
    request_params[:access_token] = CampusDataApi.access_token
    body = RestClient.post(request_url,request_params.to_json,:content_type => :json)
    res_teacher = JSON.parse(body)
    teacher_total = res_teacher["hits"]["total"]#2789
    @teacher_average = (teacher_library/teacher_total.to_f).round(1)

    #总人均借阅量
    query_hash = {
	     query:{
	         must:filter
	     }
    }
   	response=book_library_infos_api(query_hash)
     #年度书籍借阅总量
     year_total=response["hits"]["total"] 
     people_total = teacher_total+stu_total
     @people_average =  (year_total/people_total.to_f).round(1)
end

def top3_department
	year =  Time.now.year
    hash = {group:[{field:'department_name',size: 0,order:{_term:"desc"}}]}
    filter = []
    filter << {"borrowed_year"=>year}
    #学生
    filter << {"person_type"=>"0"}
    query_hash = {
        query:{
            must:filter
        },
        aggs:hash
    }
    response=book_library_infos_api(query_hash)
    if !response.blank?
      department_count={}
      response["aggregations"]["terms_department_name"]["buckets"].each do |x|
        if x["key"]!=""
          department_count.merge!({x["key"]=>x["doc_count"]})
        end
      end
    end
    @student_order=department_count.sort{|x,y| y[1]<=>x[1]}.first(3).to_h
    #老师
    filter << {"person_type"=>"1"}
    query_hash = {
        query:{
            must:filter
        },
        aggs:hash
    }
    response=book_library_infos_api(query_hash)
     if !response.blank?
      department_count={}
      response["aggregations"]["terms_department_name"]["buckets"].each do |x|
        if x["key"]!=""
          department_count.merge!({x["key"]=>x["doc_count"]})
        end
      end
    end
    @teacher_order=department_count.sort{|x,y| y[1]<=>x[1]}.first(3).to_h
end

#借阅明星
def library_star
	start_date=(Time.now.beginning_of_year).strftime("%F")
	end_date=(Time.now.end_of_year).strftime("%F")
	#排名前三
	hash = {group:[{field:'person_no',size: 100,order:{_term:"desc"},aggs:{value_count:[{field:'book_code'}]}}]}
    filter = []
    filter << {"person_type"=>"0"}
    filter << {"borrowed_time"=>{gte: start_date,lte: end_date}}
    query_hash = {
        query:{
            must:filter
        },
        aggs:hash
    }
 response=book_library_infos_api(query_hash)
 if !response.blank?
      studnet_list={}
      response["aggregations"]["terms_person_no"]["buckets"].each do |x|
        if x["key"]!=""
          studnet_list.merge!({x["key"]=>x["doc_count"]})
        end
      end
    end
    star_order=studnet_list.sort{|x,y| y[1]<=>x[1]}.first(3).to_h
    @student_star={}
    star_order.to_a.each do |star|
    	student = JSON.parse($redis.hget("UndergraduateStudent_one",star[0]))
    	department_code = student[3]
    	department_name = $redis.hget("Department_info",department_code)
    	@student_star.merge!({student[9]=>department_name})
    end
    #借阅分类
    sno=star_order.first[0]
    social_code = BOOK_TYPE.to_a[0..10].to_h.keys
	 natural_code = BOOK_TYPE.to_a[11..21].to_h.keys
    options = []
    options << {"person_no"=>sno}
    options << {"borrowed_time"=>{gte: start_date,lte: end_date}}
    options << {'category_code_1st'=>social_code}
    query_hash={
        query:{
            must:options
        }
    }
    res=book_library_infos_api(query_hash)
    social_book=res["hits"]["total"]#12

    options = []
    options << {"person_no"=>sno}
    options << {"borrowed_time"=>{gte: start_date,lte: end_date}}
    options << {'category_code_1st'=>natural_code}
    query_hash={
        query:{
            must:options
        }
    }
     res=book_library_infos_api(query_hash)
    natural_book=res["hits"]["total"]#27
    @total_books = social_book + natural_book#39
    @sum_books = []
    @sum_books << [social_book, (social_book/@total_books.to_f).round(2)*100]
    @sum_books << [natural_book, (natural_book/@total_books.to_f).round(2)*100]
    #月份借阅趋势
    opt = []
    opt << {"person_no"=>sno}
    opt << {"borrowed_time"=>{gte: start_date,lte: end_date}}
     hash = {group:[{field:'borrowed_month',size: 0}]}
     query_hash = {
        query:{
            must:opt
        },
        aggs:hash
    }
    response=book_library_infos_api(query_hash)
    @sno_month_average={}
     response["aggregations"]["terms_borrowed_month"]["buckets"].each do |x|
     		@sno_month_average.merge!({x["key"]=>x["doc_"]})
     end
end

#============================test===================================
filter_0=[]
query_hash_0 = {
    query:{
        must:filter_0
    }
}
response=CommonQuery.group_result(query_hash_0,@bookinfo_url)
card_transaction_201611==2689374
$elastic.indices.delete index:'card_transaction_201611'
start_date = "2016-11-01"
end_date = "2016-11-30"
CardTransaction.split_load_task(start_date, end_date) 
CardTransaction.dump_base_data_to_redis
nohup rails r CardTransaction.start_load_task & 

response = $elastic.search index:'consumption_warnings',body:{size:10,query:{bool:{filter:[]}}}
@start_date="2016-01-01"
@end_date="2016-12-31"    
name = "book_library_info"
index_name=DateTool.get_index(@start_date, @end_date,name)
filter = []
filter<<{range: {borrowed_time: {gte: @start_date,lt: (@end_date.to_time+1.day).strftime("%F %T")}}}
filter << {term:{:is_refill=>"0"}}
filter << {term:{:operate_type=>"0"}}
filter << {term:{:department_code=>"305000"}}
response = $elastic.search index: "#{index_name.join(",")}",body:{
    size: 0,
    query:{
      bool:{
        filter:filter
      }
    }
  }

  filter = []
filter<<{range: {borrowed_timestamp: {gte: @start_date.to_i,lte:@end_date.to_time.end_of_day.to_i}}}
filter << {term:{:is_refill=>"0"}}
filter << {term:{:operate_type=>"0"}}
filter << {term:{:department_code=>"305000"}}
response = $elastic.search index: "#{index_name.join(",")}",body:{
    size: 0,
    query:{
      bool:{
        filter:filter
      }
    }
  }

time_choose
end_year = @end_date.to_time.year
month = @end_date.to_time.month
if month<9
  start_year = end_year.to_i-4
else
  start_year = end_year.to_i-3
end
name = "book_library_info"
index_name=DateTool.get_index(@start_date, @end_date,name)
filter = []
# filter<<{range: {borrowed_timestamp: {gte: @start_date.to_time.to_i,lte: @end_date.to_time.end_of_day.to_i}}}
# filter << {term:{:person_type=>"0"}}
# filter << {term:{:is_refill=>"0"}}
# filter << {term:{:operate_type=>"0"}}
response = $elastic.search index: "undergraduate_students",body:{
    size: 0,
    query:{
      bool:{
        filter:filter
      }
    },
    aggs:{
            stu_type:{
              terms:{field: 'stu_type'}
            }
        } 
  }
BookLibraryInfo.where("borrowed_time>=? and borrowed_time<? and operate_type=? and is_refill=?","2016-01-01","2017-01-01","0","0").count
BookLibraryInfo.where("borrowed_time>? and borrowed_time<? ","2016-01-01","2017-01-01").count =>356152
BookLibraryInfo.where("borrowed_time>=? and borrowed_time<=? and operate_type=? and is_refill=? and department_name=?","2016-01-01","2016-12-31","0","0","园艺林学学院").count
UndergraduateStudent.where("admission_grade>=? and admission_grade<=? and department_code=?","2013","2016","301000").count  
UndergraduateStudent.where("admission_grade=? ","2017").count  
