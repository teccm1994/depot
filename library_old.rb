def book_classification_statistics_old
    #　tab切换全部/社会科学/自然科学
    three_classification

    #总藏书
    res = $elastic.count index:'library_books'
    @books_total = res['count']

    # 自然科学分类/社会科学分类总数
    # codes = BookCategories.where(:level=>1).collect(&:father_id).uniq
    codes = JSON.parse($redis.lrange("book_type",0,-1)[0]).keys

    filter=[]
    filter<<{terms:{category_code_1st:codes}}
    response = $elastic.search index: "library_books",body:{
        size: 0,
        query:{
            bool:{
                filter:[]
            }
        },
        aggs:{
            category_code_1st:{
                terms:{field: 'category_code_1st'}
            }
        }
    }
    @social_type=0
    @natural_type=0
    social_code = JSON.parse($redis.lrange("book_type",0,-1)[0]).keys.first(11)
    natural_code = JSON.parse($redis.lrange("book_type",0,-1)[0]).keys.last(11)
    response["aggregations"]["category_code_1st"]["buckets"].each do |x|
      if  social_code.include?(x["key"])
        @social_type += x["doc_count"]
      elsif natural_code.include?(x["key"])
        @natural_type += x["doc_count"]
      end
    end
      @social_ratio = ((@social_type / @books_total).to_f*10).round / 10.0
      @natural_ratio = ((@natural_type / @books_total).to_f*10).round / 10.0
  end

  def three_classification_old
    flag = (params[:flag] || 0).to_i
    social_code = JSON.parse($redis.lrange("book_type",0,-1)[0]).keys.first(11)
    natural_code = JSON.parse($redis.lrange("book_type",0,-1)[0]).keys.last(11)
    # social_code = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M']
    # natural_code = ['N','O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z']
    # 全部分类统计
    filter = []
    # 社会科学统计
    if flag == 1
      filter<<{terms:{category_code_1st:[social_code]}}
    # 自然科学统计
    elsif flag == 2
      filter<<{terms:{category_code_1st:[natural_code]}}
    end
    response = $elastic.search index: "library_books",body:{
        size: 0,
        query:{
            bool:{
                filter:filter
            }
        },
        aggs:{
            category_1st:{
                terms:{field: 'category_1st',size:0}
            }
        }
    }
    @books_type={}
    response["aggregations"]["category_1st"]["buckets"].each do |x|
      if x["key"]!=""
        @books_type.merge!({x["key"]=>x["doc_count"]})
      end
    end
  end

# 文献借阅部　>> 借阅人群分析（因教职工职称数据不明确，暂时搁置）
  def borrow_crowd_analysis
    @person_type = {}
    @start_date = params[:start_date]||(Time.now-3.year).strftime("%F")
    @end_date = params[:end_date]||Time.now.strftime("%F")
    flag = (params[:flag] || 1).to_i
    filter = []
    filter<<{range: {borrowed_time: {gte: @start_date.to_i,lte: @end_date.to_i}}}
    if flag == 1
      filter<<{term:{person_type:"1"}}
      response = $elastic.search index: "book_library_infos",body:{
          size: 0,
          query:{
              bool:{
                  filter:filter
              }
          },
          aggs: {
              teacher_type:{
                  terms: {field:'teacher_type',size:0}
              }
          }
      }
      response["aggregations"]["teacher_type"]["buckets"].each do |x|
        if x["key"]!=""
          @person_type.merge!({x["key"]=>x["doc_count"]})
        end
      end
    elsif flag == 2
      filter<<{term:{person_type:"0"}}
      response = $elastic.search index: "book_library_infos",body:{
          size: 0,
          query:{
              bool:{
                  filter:filter
              }
          },
          aggs: {
              stu_type:{
                  terms: {field:'stu_type',size:0}
              }
          }
      }
      response["aggregations"]["stu_type"]["buckets"].each do |x|
        if x["key"]!=""
          @person_type.merge!({x["key"]=>x["doc_count"]})
        end
      end
    end
  end

def borrow_crowd_analysis
    @person_type = {}
    @start_date = params[:start_date]||(Time.now-3.year).strftime("%F")
    @end_date = params[:end_date]||Time.now.strftime("%F")
    flag = (params[:flag] || 1).to_i
    filter = []
    filter<<{range: {borrowed_time: {gte: @start_date.to_i,lte: @end_date.to_i}}}
    if flag == 1
      filter<<{term:{person_type:"1"}}
      response = $elastic.search index: "book_library_infos",body:{
          size: 0,
          query:{
              bool:{
                  filter:filter
              }
          },
          aggs: {
              teacher_type:{
                  terms: {field:'teacher_type',size:0}
              }
          }
      }
      response["aggregations"]["teacher_type"]["buckets"].each do |x|
        if x["key"]!=""
          @person_type.merge!({x["key"]=>x["doc_count"]})
        end
      end
    elsif flag == 2
      filter<<{term:{person_type:"0"}}
      response = $elastic.search index: "book_library_infos",body:{
          size: 0,
          query:{
              bool:{
                  filter:filter
              }
          },
          aggs: {
              stu_type:{
                  terms: {field:'stu_type',size:0}
              }
          }
      }
      response["aggregations"]["stu_type"]["buckets"].each do |x|
        if x["key"]!=""
          @person_type.merge!({x["key"]=>x["doc_count"]})
        end
      end
    end

end

def department_borrow_analysis  
    @start_date = params[:start_date]||(Time.now-3.year).strftime("%F")
    @end_date = params[:end_date]||Time.now.strftime("%F")
    filter = []
    filter<<{range: {borrowed_time: {gte: @start_date.to_i,lte: @end_date.to_i}}}
    response = $elastic.search index: "book_library_infos",body:{
      size: 0,
      query:{
        bool:{
          filter:filter
        }
      },
      aggs: {
        department_count: {
          terms: { field: "department_name",size:0,order:{book_count: "desc"}},
          aggs:{
            book_count:{
              value_count:{field: 'book_code'}
            }
          }
        }
      }
    }
    @department_count={}
    response["aggregations"]["department_count"]["buckets"].each do |x|
        if x["key"]!=""
          @department_count.merge!({x["key"]=>x["doc_count"]})
        end
      end
end

def major_borrow_analysis
    @start_date = params[:start_date]||(Time.now-3.year).strftime("%F")
    @end_date = params[:end_date]||Time.now.strftime("%F")
    department_code = params[:department_code]
    filter = []
    filter<<{range: {borrowed_time: {gte: @start_date.to_i,lte: @end_date.to_i}}}
    filter<<{term:{department_code:department_code}} if !department_code.blank?
     response = $elastic.search index: "book_library_infos",body:{
      size: 0,
      query:{
        bool:{
          filter:filter
        }
      },
      aggs: {
        department_count: {
          terms: { field: "major_name",size:0,order:{book_count: "desc"}},
          aggs:{
            book_count:{
              value_count:{field: 'book_code'}
            }
          }
        }
      }
    }
    @major_count={}
    response["aggregations"]["terms_major_name"]["buckets"].each do |x|
        if x["key"]!=""
          @major_count.merge!({x["key"]=>x["doc_count"]})
        end
      end
end

def average_depart_analysis
    @start_date = params[:start_date]||(Time.now-3.year).strftime("%F")
    @end_date = params[:end_date]||Time.now.strftime("%F")
    filter = []
    filter<<{range: {borrowed_time: {gte: @start_date.to_i,lte: @end_date.to_i}}}
    filter<<{term:{person_type:"0"}}
    #各院系学生总数统计
    student_analysis

    response = $elastic.search index: "book_library_infos",body:{
      size: 0,
      query:{
        bool:{
          filter:filter
        }
      },
      aggs: {
        department_count: {
          terms: { field: "department_name",size:0,order:{book_count: "desc"}},
          aggs:{
            book_count:{
              value_count:{field: 'book_code'}
            }
          }
        }
      }
    }
    #各院系借阅数量分析
    @department_count={}
    response["aggregations"]["department_count"]["buckets"].each do |x|
        if x["key"]!=""
          @department_count.merge!({x["key"]=>x["doc_count"]})
        end
      end
      
    #各院人均借阅量＝各院借阅量/各院学生总数
    re={}
    student_count.to_a.each do |x|
        if !@department_count[x[0]].blank?
            re.merge!({x[0]=>@department_count[x[0]]/x[1]})
        else
            re.merge!({x[0]=>0})
        end
    end
end

def student_analysis
#各院系学生总数统计
      res_stu = $elastic.search index:"undergraduate_students",body:{
          size: 0,
          query:{
            bool:{
              filter:[]
            }
          },
          aggs:{
            student_count_year:{
              terms:{field:'department_name_no', size:0}
            }
          }
        }
        student_count = {}
        @average_depart = {}
        res_stu["aggregations"]["student_count_year"]["buckets"].each do |x|
            if x["key"]!=""
              student_count.merge!({x["key"]=>x["doc_count"]})
            end
        end
        #===============================================#
        res_stu = $elastic.search index:"undergraduate_students",body:{
          size: 0,
          query:{
            bool:{
              filter:[]
            }
          },
          aggs:{
            student_department:{
              terms:{field:'department_name_no', size:0},
              aggs:{
                student_year:{
                  terms:{field:'admission_grade', size:0}
                }
              }
            }
          }
        }
        student_count = []
        res_stu["aggregations"]["student_department"]["buckets"].each do |x|
             x["student_year"]["buckets"].each do |buck|
                student_count << [x["key"],[buck["key"],buck["doc_count"]]]
              end
        end
        student_count=student_count.sort.reverse.to_h
        in_school_student={}
        student_count.to_a.each do |x|
         begin
          count=student_count[x[0]]+student_count[(x[0].to_i-1).to_s]+student_count[(x[0].to_i-2).to_s]+student_count[(x[0].to_i-3).to_s]
          in_school_student.merge!({x[0]=>count}) 
         rescue Exception => e
         end
        end
end

def major_average_analysis
    @start_date = params[:start_date]||(Time.now-3.year).strftime("%F")
    @end_date = params[:end_date]||Time.now.strftime("%F")
    @year = params[:year] || (Time.now-3.year).year
    department_code = params[:department_code]
    filter = []
    # filter<<{range: {borrowed_time: {gte: @start_date.to_i,lte: @end_date.to_i}}}
    filter<<{term:{department_code:department_code}} if !department_code.blank?
    filter<<{term:{borrowed_year:@year}}
     response = $elastic.search index: "book_library_infos",body:{
      size: 0,
      query:{
        bool:{
          filter:filter
        }
      },
      aggs: {
        department_count: {
          terms: { field: "major_name",size:0,order:{book_count: "desc"}},
          aggs:{
            book_count:{
              value_count:{field: 'book_code'}
            }
          }
        }
      }
    }
    @major_count={}
    response["aggregations"]["terms_major_name"]["buckets"].each do |x|
        if x["key"]!=""
          @major_count.merge!({x["key"]=>x["doc_count"]})
        end
      end
end

#======================start===========================
#导出教师与学生进馆前100名
def download_excel
    @students = []
    @start_date = params[:start_date]||(Time.now-3.year).strftime("%F")
    @end_date = params[:end_date]||Time.now.strftime("%F")
    flag = (params[:flag] || 1).to_i
    filter = []
    filter<<{range: {borrowed_time: {gte: @start_date.to_i,lte: @end_date.to_i}}}
    if flag == 1
      filter<<{term:{person_type:"1"}}
      response = $elastic.search index: "book_library_infos",body:{
      size: 0,
      query:{
        bool:{
          filter:filter
        }
      },
      aggs: {
        teacher_count: {
          terms: { field: "person_no",size:0,order:{book_count: "desc"}},
          aggs:{
            book_count:{
              value_count:{field: 'book_code'}
            }
          }
        }
      }
    }
    statistics_analysis={}
      response["aggregations"]["terms_person_no"]["buckets"].each_with_index do |x, i|
        if x["key"]!=""
          statistics_analysis.merge!({x["key"]=>x["doc_count"]})
          @teachers=statistics_analysis.sort{|x,y| y[1]<=>x[1]}.to_h
        end
      end
    elsif flag == 0
      filter<<{term:{person_type:"0"}}
    response = $elastic.search index: "book_library_infos",body:{
      size: 0,
      query:{
        bool:{
          filter:filter
        }
      },
      aggs: {
        student_count: {
          terms: { field: "person_no",size:0,order:{book_count: "desc"}},
          aggs:{
            book_count:{
              value_count:{field: 'book_code'}
            }
          }
        }
      }
    }
      response["aggregations"]["student_count"]["buckets"].each_with_index do |x, i|
        if x["key"]!=""
          student = JSON.parse($redis.hget("UndergraduateStudent_info",x["key"]))
          name = student[0]
          person_no = x["key"]
          department_code = student[4]
          department_name  = $redis.hget("Department_info",department_code)
          read_count = x["doc_count"]
          @students << [i, name, person_no, department_name, read_count ]
        end
      end
     
      dir = "library_infos"
      filename = "#{Time.now.strftime("%F ")}借阅人群分析"
      first_row = ["序号","姓名", "借书人代码", "所属院系", "借阅量"]
      ExportToExcel.export_rows(dir, filename, first_row, students)
      send_file("#{Rails.root}/public/excel_files/#{dir}/#{filename}", :type => 'xls', :disposition => 'attachment', :filename => filename)
end

#===================api===================
person_type = params[:person_type] || "0"
@start_year=params[:start_year]||Time.now.year-3
@end_year=params[:end_year]||Time.now.year
filter = []
filter << {"person_type"=>person_type} if !person_type.blank?
filter << {'doorcard_time_year'=>{gte:@start_year,lte:@end_year}}
hash = {group:[{field:'sno',size:100,aggs:{group:[{field:'doorcard_time_year'}]}}]}
query_hash={
      query:{
        must:filter
      },
      aggs:hash,size:0
    }
    request_params={}
    request_params[:conditions] = query_hash
    request_url = "hnapi.aggso.com/open_api/student/doors_detail/statistics"
    request_params[:access_token] = CampusDataApi.access_token
    body = RestClient.post(request_url,request_params.to_json,:content_type => :json)
    response = JSON.parse(body)
     @order_lists = []
    statistics_analysis={}
    if !response.blank?
      response["aggregations"]["terms_sno"]["buckets"].first(200).each do |res|
        if res["key"]!=""
          statistics_analysis.merge!({res["key"]=>res["doc_count"]})
          @results=statistics_analysis.sort{|x,y| y[1]<=>x[1]}.to_h
        end
      end
    end
#===================end=============================================
def into_library_history_download
    person_type = params[:person_type]
    @start_date = params[:start_date]||(Time.now-3.year).strftime("%F")
    @end_date = params[:end_date]||Time.now.strftime("%F")
    filter=[]
    filter<<{term:{person_type:person_type}} if !person_type.blank?
   response = $elastic.search index: "door_guards",body:{
      size: 0,
      query:{
        bool:{
          filter:filter
        }
      },
      aggs: {
        into_library_count: {
          terms: { field: "sno",size:0,order:{per_count: "desc"}},
          aggs:{
            per_count:{
              value_count:{field: 'doorcard_time_year'}
            }
          }
        }
      }
    }
    @order_lists = []
    statistics_analysis={}
    if !response.blank?
      response["aggregations"]["into_library_count"]["buckets"].first(100).each do |res|
        if res["key"]!=""
          statistics_analysis.merge!({res["key"]=>res["doc_count"]})
          @results=statistics_analysis.sort{|x,y| y[1]<=>x[1]}.to_h
        end
      end
    end
end

#============api for borrow_download_excel================
filter=[]
    filter << {"doorcard_time_year"=>{gte: @start_year.to_i,lte: @end_year.to_i}}
    filter << {'person_type'=>person_type} if !person_type.blank?
    hash = {group:[{field:'sno',size:100,order:{_term:"desc"},aggs:{value_count:[{field:'doorcard_time_year'}]}}]}
    query_hash={
        query:{
            must:filter
        },
        aggs:hash,size:0
    }
    request_params={}
    request_params[:conditions] = query_hash
    request_url = "hnapi.aggso.com/open_api/student/doors_detail/statistics"
    request_params[:access_token] = CampusDataApi.access_token
    body = RestClient.post(request_url,request_params.to_json,:content_type => :json)
    response = JSON.parse(body)
    @order_lists = []
    statistics_analysis={}
    if !response.blank?
      response["aggregations"]["terms_sno"]["buckets"].each do |res|
        if res["key"]!=""
          statistics_analysis.merge!({res["key"]=>res["doc_count"]})
          @results=statistics_analysis.sort{|x,y| y[1]<=>x[1]}.to_h
        end
      end
    end
#es==============================start============================================
def association_score_student_analysis
#　学年筛选条件
    @school_year = school_year_filter
    # 成绩与借阅关联分析计算
    establish_time = params[:school_year] || "#{(Time.now-1.year).year}-#{(Time.now).year}"
    borrowed_year_start = establish_time.split("-")[0] || "#{(Time.now-1.year).year}"
    borrowed_year_end = establish_time.split("-")[1] || "#{(Time.now).year}"
    filter = []
    filter << {term:{person_type:"0"}}
    filter << {range:{borrowed_year:{gte:borrowed_year_start,lte:borrowed_year_end}}}
    response = $elastic.search index: "book_library_infos",body:{
        size: 0,
        query:{
            bool:{
                filter:filter
            }
        },
        aggs: {
            student_book: {
                terms: { field: "person_no",size:10},
                aggs:{
                    book_count:{
                        value_count:{field: 'book_code'}
                    },
                    gpa_count:{
                        terms:{field:'gpa_new'}
                    }
                }
            }
        }
    }
    @results={}
    if !response.blank?
      response['aggregations']['student_book']['buckets'].each do |x|
        next if x["gpa_count"]["buckets"][0].blank?
        @results.merge!( { x["key"] => [x["gpa_count"]["buckets"][0]["key"].round(2),x["book_count"]["value"]  ] } )
      end
    end
end

#并列聚合
aggregations:{
    sno:{
      terms: {field:"sno"},
      aggregations:{
        sum_money:{
          sum:{field:"transaction_amount"}
        }
      }
    },
    merchant_name:{
      terms:{field:"merchant_name"},
      aggregations:{
        sum_money:{
          sum:{field:"transaction_amount"}
        }
      }
    }
  }

#=====================api==association_score_student_analysis=================
@school_year = "2015-2016"
establish_time = params[:school_year] || "#{(Time.now-1.year).year}-#{(Time.now).year}"
borrowed_year_start = establish_time.split("-")[0] || "#{(Time.now-1.year).year}"
borrowed_year_end = establish_time.split("-")[1] || "#{(Time.now).year}"
filter = []
filter << {"person_type"=>"0"}
filter << {"borrowed_time"=>{gte: borrowed_year_start,lte: borrowed_year_end}}
hash = {group:[{field:"person_no",size:0,aggs:{field:"book_code"},field:"gpa"}]}

query_hash = {
    query:{
        must:filter
    },
    aggs:hash,size:0
}
request_params={}
request_params[:conditions] = query_hash
request_params[:debug]=true
request_url = "hnapi.aggso.com/open_api/library/borrows_detail/statistics"
request_params[:access_token] = CampusDataApi.access_token
body = RestClient.post(request_url,request_params.to_json,:content_type => :json)
response = JSON.parse(body)
@results={}
response['aggregations']['terms_gpa']['buckets'].each do |x|
  @results.merge!({ x["key"] =>x["doc_count"]})
end
#=======================end=====================================================
  # 文献借阅部　>> 成绩与进馆次数关联分析
  def association_score_frequency_analysis
    #　学年筛选条件
    @school_year = []
    month = Time.now.month
    if month<9
      (0..3).each do |i|
        @school_year << "#{(Time.now-(i+1).year).year}-#{(Time.now-i.year).year}"
      end
    else
      (0..3).each do |i|
        @school_year << "#{(Time.now-i.year).year}-#{(Time.now-i.year+1.year).year}"
      end
    end
    # 成绩与进馆次数关联分析计算
    school_year = params[:school_year] || "#{(Time.now-1.year).year}-#{(Time.now).year}"
    doorcard_time_start = school_year.split("-")[0] || "#{(Time.now-1.year).year}"
    doorcard_time_end = school_year.split("-")[1] || "#{(Time.now).year}"
    filter = []
    filter << {term:{person_type:"0"}}
    filter << {range:{doorcard_time_year:{gte:doorcard_time_start,lte:doorcard_time_end}}}
    response = $elastic.search index: "door_guards",body:{
        size: 0,
        query:{
            bool:{
                filter:filter
            }
        },
        aggs: {
            student_door: {
                terms: { field: "sno",size:1000},
                aggs:{
                    door_count:{
                        terms:{field: 'doorcard_time_year'}
                    },
                    gpa_count:{
                        terms:{field:'gpa'}
                    }
                }
            }
        }
    }
    @results={}
    response['aggregations']['student_door']['buckets'].each do |y|
        sum=0
        y["door_count"]["buckets"].collect{|x| sum+=x["doc_count"]} 
        @results.merge!( { y["key"] => [sum , y["gpa_count"]["buckets"][0]["key"].round(2)] } )
    end
  end

association_score_frequency_analysis api:
school_year = params[:school_year] || "#{(Time.now-1.year).year}-#{(Time.now).year}"
month = Time.now.month
if month < 9
  doorcard_time_start = "#{school_year.split("-")[0]}"+"-09-01" || "#{(Time.now-1.year).year}"+"-09-01"
  doorcard_time_end = school_year.split("-")[1]+"-07-30" || "#{(Time.now).year}"+"-07-30"
else
  doorcard_time_start = "#{school_year.split("-")[0]}"+"-09-01" || "#{(Time.now).year}"+"-09-01"
  doorcard_time_end = school_year.split("-")[1]+"-07-30" || "#{(Time.now+1.year).year}"+"-07-30"
end
filter = []
filter << {"person_type"=>"0"}
filter << {"doorcard_time"=>{gte:doorcard_time_start,lte:doorcard_time_end}}
hash = {group:[{field:"sno",size:0,aggs:{field:"doorcard_time"},field:"gpa"}]}
query_hash = {
          query:{
              must:filter
          },
          aggs:hash,size:0
      }
request_params={}
request_params[:conditions] = query_hash
request_params[:debug]=true
request_url = "hnapi.aggso.com/open_api/student/doors_detail/statistics"
request_params[:access_token] = CampusDataApi.access_token
body = RestClient.post(request_url,request_params.to_json,:content_type => :json)
response = JSON.parse(body)
@results={}
response['aggregations']['terms_gpa']['buckets'].each do |res|
  sum=0
  res["door_count"]["buckets"].collect{|x| sum+=x["doc_count"]}
  @results.merge!( { res["key"] =>  [ res["gpa_count"]["buckets"][0]["key"].round(2), sum] } )
end

#====================start=======================================
#==============文献借阅部　>> 图书超期缴费分析 es================
def books_overdue_download
    @start_time = params[:start_time] || Time.now.year
    @end_time = params[:end_time] || Time.now.year
    filter = []
    filter << {range:{pay_year:{gte:@start_time,lte:@end_time}}}
    res = $elastic.search index: "reader_payments", body: {
      query: {
        bool: {
          must: filter
        }
      },
        aggs: {
            pay_year: {
                terms: { field: "pay_year"},
                aggs:{
                    person_no:{
                        terms:{field:'person_no',size:0},
                        aggs:{
                          sum_money:{
                            sum:{field:"pay_money"}
                          },
                          sum_book:{
                            value_count:{field:"pay_date"}
                          }
                      }
                    }
                }
            }
        }
    }
    list = []
count = res["aggregations"]["pay_year"]["buckets"].count
  res["aggregations"]["pay_year"]["buckets"].each_with_index do |x,m|
        x["person_no"]["buckets"].each_with_index do |sno,n|
            if m!=0
            list << n+1+m*count
          else
            list << n+1
          end
      end
  end

    payment_analysis={}
    res["aggregations"]["pay_year"]["buckets"].each do |x|
        x["person_no"]["buckets"].each do |sno|
            payment_analysis.merge!({sno["key"]=>sno["doc_count"]})
        end
    end
end
#=========api===========library/payments_detail====================================
{group:[{field:'pay_year',
            aggs:{
                  group:[
                      {field:'person_no',size:10,
                        aggs:{
                              sum:[
                                    {field:'pay_money'},
                                    {field:'pay_date'}]
                              }
                       }]
                  }
            }]
      }
filter = []
filter << {"pay_year"=>{gte:@start_time,lte:@end_time}}
hash = {group:[{field:'pay_year',aggs:{group:[{field:'person_no',size:10,aggs:{value_count:[{field:'pay_money'},{field:'pay_date'}}}]}}]}
query_hash = {
        query:{
            must:filter
        },
        aggs:hash,size:0
    }
    request_params={}
    request_params[:conditions] = query_hash
    request_params[:debug]=true
    request_url = "hnapi.aggso.com/open_api/library/payments_detail/statistics"
    request_params[:access_token] = CampusDataApi.access_token
    body = RestClient.post(request_url,request_params.to_json,:content_type => :json)
    response = JSON.parse(body)
    @order_lists = []
    response["aggregations"]["terms_pay_year"]["buckets"].each do |x|
      begin
        x["terms_person_no"]["buckets"].each_with_index do |sno,n|
          teacher = JSON.parse($redis.hget("Employee_info",sno["key"])) rescue ""
          student = JSON.parse($redis.hget("UndergraduateStudent_info",sno["key"])) rescue ""
          list = n + 1
          if student.blank? && !teacher.blank?#老师
            name = teacher[0]
            person_no = sno["key"]
            department_code = teacher[3]
            department_name  = $redis.hget("Department_info",department_code)
            overdue_book = sno["terms_pay_date"]["doc_count"]
            pay_money = sno["terms_pay_money"]["key"]/100.to_f
            desp = "老师"
            @order_lists << [list, x["key"], name, person_no, department_name, overdue_book, pay_money, desp ]
          elsif !student.blank? && teacher.blank? #学生
            name = student[0]
            person_no = sno["key"]
            department_code = student[4]
            department_name  = $redis.hget("Department_info",department_code)
            overdue_book = sno["terms_pay_date"]["doc_count"]
            pay_money = sno["terms_pay_money"]["key"]/CARD_TIMES.to_f
            desp = "学生"
            @order_lists << [list, x["key"], name, person_no, department_name, overdue_book, pay_money, desp ]
          end
        end
      rescue Exception => e
        puts e
      end
    end

#========books_overdue_payment_analysis======================
hash = {group:[{field:'pay_year',
            aggs:{
                  sum:[
                      {field:'pay_money',
                        aggs:{
                              sum:[
                                    {field:'person_no'}]
                              }
                       }]
                  }
            }]
      }
hash = {group:[{field:"pay_year",size:10,aggs:{group:[{value_count:{field:"pay_money"},field:"person_no"}]}}]}
query_hash={
        query:{
            must:[]
        },
        aggs:hash,size:10
    }
    request_params={}
    request_params[:conditions] = query_hash
    request_url = "hnapi.aggso.com/open_api/library/payments_detail/statistics"
    request_params[:access_token] = CampusDataApi.access_token
    body = RestClient.post(request_url,request_params.to_json,:content_type => :json)
    response = JSON.parse(body)
    payment_analysis={}
    response["aggregations"]["pay_year"]["buckets"].each do |x|
      if flag=="0"
        @books_overdue_payment_info="册数"
        payment_analysis.merge!({x["key"]=>x["doc_count"]})
      elsif flag=="1"
        @books_overdue_payment_info="人数"
        payment_analysis.merge!({x["key"]=>x["person_no"]["value"]})
      elsif flag=="2"
        @books_overdue_payment_info="金额"
         payment_analysis.merge!({x["key"]=>(x["sum_money"]["value"].to_f/CARD_TIMES).round(2)})
      end
    end
    @books_overdue_payment_analysis=payment_analysis
#=========文献借阅部　>> 图书超期缴费分析 sidekiq==============
def books_overdue_download
    @start_time = params[:start_time] || Time.now.year
    @end_time = params[:end_time] || Time.now.year
    filter = []
    filter << {range:{pay_year:{gte:@start_time,lte:@end_time}}}
    DataExportWorker.perform_async('DocumentLendingDepartmentController',filter)
end

class DataExportWorker
  include Sidekiq::Worker

  def perform(class_name,params)
    kclass = Object.const_get class_name
    kclass.all_results_excel(params)
    puts 'data output done'
  end
end

def all_results_excel(params)
     res = $elastic.search index: "reader_payments", body: {
      query: {
        bool: {
          must: filter
        }
      },
        aggs: {
            pay_year: {
                terms: { field: "pay_year",size:100},
                aggs:{
                    person_no:{
                        terms:{field:'person_no'},
                        aggs:{
                          sum_money:{
                            sum:{field:"pay_money"}
                          },
                          sum_book:{
                            value_count:{field:"pay_date"}
                          }
                      }
                    }
                }
            }
        }
    }
    @order_lists = []
    res["aggregations"]["pay_year"]["buckets"].each_with_index do |x,m|
      begin
        sum = x["person_no"]["buckets"].count
        x["person_no"]["buckets"].each_with_index do |sno,n|
          teacher = JSON.parse($redis.hget("Employee_info",sno["key"])) rescue ""
          student = JSON.parse($redis.hget("UndergraduateStudent_info",sno["key"])) rescue ""
          if m!=0
            list = n+1+sum
          else
            list = n+1
          end
          if student.blank? && !teacher.blank?#老师
            name = teacher[0]
            person_no = sno["key"]
            department_code = teacher[3]
            department_name  = $redis.hget("Department_info",department_code)
            overdue_book = sno["sum_book"]["value"]
            pay_money = sno["sum_money"]["value"]/100.to_f
            desp = "老师"
            @order_lists << [list, x["key"], name, person_no, department_name, overdue_book, pay_money, desp ]
          elsif !student.blank? && teacher.blank? #学生
            name = student[0]
            person_no = sno["key"]
            department_code = student[4]
            department_name  = $redis.hget("Department_info",department_code)
            overdue_book = sno["sum_book"]["value"]
            pay_money = sno["sum_money"]["value"]/100.to_f
            desp = "学生"
            @order_lists << [list, x["key"], name, person_no, department_name, overdue_book, pay_money, desp ]
          end
        end
      rescue
      end
    end
    dir = "library_infos"
    filename = "#{Time.now.strftime("%F ")}图书超期缴费分析"
    first_row = ["序号", "年份", "姓名", "学号/工号", "所属院系", "超期天数","需缴费金额","备注"]
    ExportToExcel.export_rows(dir, filename, first_row, @order_lists.first(100))
    dir = "library_infos"
    filename = "#{Time.now.strftime("%F ")}图书超期缴费分析.xls"
    send_file("#{Rails.root}/public/excel_files/#{dir}/#{filename}", :type => 'xls', :disposition => 'attachment', :filename => filename)
end

  list=[]
count = (1..4).size
(1..4).each_with_index do |x,m|
    sum =  (1..4).size
    (1..4).each_with_index do |y,n|
        if m != 0
            list << n+1+count*m
          else
            list << n+1
          end
      end  
  end

list = []
count = res["aggregations"]["pay_year"]["buckets"].count
  res["aggregations"]["pay_year"]["buckets"].each_with_index do |x,m|
       sum = x["person_no"]["buckets"].count
        x["person_no"]["buckets"].each_with_index do |sno,n|
            if m!=0
            list << n+1+m*count
          else
            list << n+1
          end
      end
  end
#========================end===============================
#借阅人群数据核对
students = []
teachers = []
unknows = []
BookLibraryInfo.find_each do |r|
    student = $redis.hget("UndergraduateStudent_info",r.person_no)
    employee = $redis.hget("Employee_info",r.person_no)
    if student.blank? && !employee.blank?#老师
        em = JSON.parse(employee)
        teachers << r.person_no
    elsif !student.blank? && employee.blank? #学生
        stu = JSON.parse(student)
        students << r.person_no
    else   
        unknows << r.person_no
    end
end
#es
@person_type = {}
@start_date = params[:start_date]||(Time.now-3.year).strftime("%F")
@end_date = params[:end_date]||Time.now.strftime("%F")
flag = (params[:flag] || 1).to_i
filter = []
filter<<{range: {borrowed_time: {gte: @start_date.to_i,lte: @end_date.to_i}}}
filter<<{term:{person_type:"2"}}
response = $elastic.search index: "book_library_infos",body:{
      query:{
          bool:{
              filter:filter
          }
      }
  }
