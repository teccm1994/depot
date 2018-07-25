 require 'impala'
Impala.connect('172.21.98.179', 21000) do |conn|
    conn.query("SELECT ct.sno, sum(ct.transaction_amount) transaction_amount FROM `dashboard.card_transactions` ct right join dashboard.undergraduate_students us on ct.sno = us.sno COLLATE utf8_unicode_ci where us.school_roll = 1 and us.in_school_status = 1 and stu_type = 1 and transaction_time between '2018-05-08 00:00:00' and '2018-05-15 00:00:00' group by ct.sno")
end

Impala.connect('172.21.98.179', 21000) do |conn|
    conn.query("select sno, 
      sum(case when breakfast > 0 then 1 else 0 end) as breakfast,
sum(case when lunch > 0 then 1 else 0 end) as lunch ,
sum(case when surper > 0 then 1 else 0 end) as surper
from (
select sno,transaction_date,
sum(case when hour(transaction_time) < 10 and hour(transaction_time) >= 6 then 1 else 0 end) as breakfast,
sum(case when hour(transaction_time) <= 13 and hour(transaction_time) >= 10 then 1 else 0 end) as lunch,
sum(case when hour(transaction_time) <= 20 and hour(transaction_time) >= 17 then 1 else 0 end) as surper
 from dashboard.card_transactions
where transaction_date >= cast(DATE_ADD(NOW(),INTERVAL -24 DAY) as varchar(50))
group by sno,transaction_date) t
group by sno")
end

Impala.connect('172.21.98.179', 21000) do |conn|
    conn.query("select ct.sno, sum(ct.transaction_amount) transaction_amount from dashboard.card_transactions ct join dashboard.undergraduate_students us on ct.sno = us.sno where us.school_roll = '1' and us.in_school_status = '1' and stu_type = 1 and ct.transaction_type = '2' group by ct.sno")
end
conn = Impala.connect('172.21.98.179', 21000)
cursor = conn.execute("select stu_tmp.department_name, count(distinct stu_tmp.sno) count from (select sno, department_name from dashboard.undergraduate_students where sno not in (select sno from dashboard.card_transactions where transaction_type = '2') and school_roll='1' and in_school_status='1' and stu_type=1) stu_tmp group by stu_tmp.department_name")

cursor = conn.execute("use dashboad; select ct.sno, sum(ct.transaction_amount) transaction_amount from card_transactions ct join undergraduate_students us on ct.sno = us.sno where us.school_roll = '1' and us.in_school_status = '1' and stu_type = 1 and ct.transaction_type = '2' group by ct.sno")

start_time, end_time = Date.today-100.day, Date.today
cursor.each do |row|
	puts row
end

结果：计算最近7天，全校学生消费总餐数
要求：
1.进餐:一顿饭（早餐：06:00-10:00、中餐：10:00-13:00、晚餐：17:00-20:00）
2.在进餐时间段内，出现一次或多次刷卡记录均记为一餐

方案1：
查最近7天的所有早餐数据  然后按照人group  数人头就可以了  结果就是最近7天所有人早餐 总餐数
查最近7天的所有中餐数据  然后按照人group  数人头就可以了  结果就是最近7天所有人中餐 总餐数
查最近7天的所有晚餐数据  然后按照人group  数人头就可以了  结果就是最近7天所有人晚餐 总餐数
然后加起来

方案2：
查最近7天数据 然后按照 早中晚的 时间group  然后在按照人group

select sum(mymoney) as totalmoney,count(*) as sheets from card_transactions group by date_format(transaction_time, '%Y-%m-%d %H ') where transaction_time between 'Thu, 10 May 2018 00:00:00 CST +08:00' and 'Wed, 16 May 2018 00:00:00 CST +08:00 ';

::Dashboard::CardTransaction.find_by_sql("
select ct.sno, date_format(ct.transaction_time, '%H') as byhour from card_transactions ct join undergraduate_students us on ct.sno = us.sno COLLATE utf8_unicode_ci where us.school_roll = 1 and us.in_school_status = 1 and stu_type = 1  and ct.transaction_time > 'Thu, 10 May 2018 00:00:00 CST +08:00' and ct.transaction_time < 'Wed, 16 May 2018 00:00:00 CST +08:00'  group by byhour, ct.sno;")


::Dashboard::CardTransaction.find_by_sql("
select sno,transaction_date,hour(transaction_time) as byhour, (case 
when(hour(transaction_time)>=6 and  hour(transaction_time)<10) then '早餐'    
when(hour(transaction_time)>=10 and hour(transaction_time)<=13) then '中餐' 
when(hour(transaction_time)>=17 and hour(transaction_time)<=20) then '晚餐' 
else '其他' END
) as tag from dashboard.card_transactions where transaction_date >= cast(DATE_ADD(NOW(),INTERVAL -24 DAY) as varchar(50))  group by transaction_date,tag,sno;")

##---allright impala-shell---#
Impala.connect('172.21.98.179', 21000) do |conn|
    conn.query("select sno ,sum(cntasall) as cnt from (select sno ,transaction_date,count(*) as cntasall from(select sno, transaction_date,(case 
when(hour(transaction_time)>=6 and  hour(transaction_time)<10) then '早餐'    
when(hour(transaction_time)>=10 and hour(transaction_time)<=13) then '中餐' 
when(hour(transaction_time)>=17 and hour(transaction_time)<=20) then '晚餐' END
) as tag, count(*) as mealsbydate from dashboard.card_transactions where transaction_date >= cast(DATE_ADD(NOW(),INTERVAL -24 DAY) as varchar(50))  group by transaction_date,sno,tag) as dt1 where tag is not null group by sno,transaction_date) as dt2 group by sno;")
end



select sno ,sum(cntasall) as cnt from (select sno ,transaction_date,count(*) as cntasall from(select sno, transaction_date,(case 
when(hour(transaction_time)>=6 and  hour(transaction_time)<10) then '早餐'    
when(hour(transaction_time)>=10 and hour(transaction_time)<=13) then '中餐' 
when(hour(transaction_time)>=17 and hour(transaction_time)<=20) then '晚餐' END
) as tag, count(*) as mealsbydate from dashboard.card_transactions where transaction_date >= cast(DATE_ADD(NOW(),INTERVAL -24 DAY) as varchar(50)) and sno = "16041527" group by transaction_date,sno,tag) as dt1 where tag is not null group by sno,transaction_date;

select sno,HOUR(transaction_time) as byhour, (case 
when(HOUR(transaction_time)>'6' and  HOUR(transaction_time)<='10') then '早餐'    
when(HOUR(transaction_time)>'10' and HOUR(transaction_time)<='13') then '中餐' 
when(HOUR(transaction_time)>'17' and HOUR(transaction_time)<='20') then '晚餐' 
else '其他' END
) as tag from card_transactions where transaction_time > 'Thu, 10 May 2018 00:00:00 CST +08:00' and transaction_time < 'Wed, 16 May 2018 00:00:00 CST +08:00'  group by byhour,tag;


 select distinct transaction_date from dashboard.card_transactions where transaction_date >= cast(DATE_ADD(NOW(),INTERVAL -24 DAY) as varchar(50));

 select ct.sno, us.current_grade, ct.transaction_amount from card_transactions ct join undergraduate_students us on ct.sno = us.sno where us.school_roll = "1" and us.in_school_status = "1"and stu_type = 1  and ct.transaction_date between '2018-04-20' and '2018-05-21';
 select ct.sno, sum(ct.transaction_amount) transaction_amount from dashboard.card_transactions ct join dashboard.undergraduate_students us on ct.sno = us.sno where us.school_roll = '1' and us.in_school_status = '1' and stu_type = 1 and ct.transaction_type = '2'  and ct.transaction_date between '2018-04-20' and '2018-05-21' group by ct.sno;

 select stu_tmp.department_name, count(distinct stu_tmp.sno) count from (select us.sno, us.department_name, ct.transaction_date from card_transactions ct right join undergraduate_students us on ct.sno = us.sno where us.school_roll = "1" and us.in_school_status = "1" and stu_type = 1 and ct.transaction_date between '2018-04-20' and '2018-05-21') stu_tmp where stu_tmp.transaction_date is null group by stu_tmp.department_name;

 select stu_tmp.department_name, count(distinct stu_tmp.sno) count from (select sno, department_name from undergraduate_students 
where sno not in (select sno from card_transactions where transaction_type = "2" and transaction_date between '2018-04-20' and '2018-05-21') and 
school_roll="1" and in_school_status="1" and stu_type=1) stu_tmp group by stu_tmp.department_name;

select stu_tmp.department_name, count(distinct stu_tmp.sno) count from (select sno, department_name from undergraduate_students where sno not in (select sno from card_transactions where transaction_type = "2" and transaction_date between '2018-04-20' and '2018-05-21') and school_roll="1" and in_school_status="1" and stu_type=1) stu_tmp group by stu_tmp.department_name;
#时间段内，每一天没有消费的学号,日期,是否消费
select sno, department_name from undergraduate_students where sno not in (select sno from card_transactions where transaction_type = "2" and transaction_date between '2018-04-20' and '2018-05-21') and school_roll="1" and in_school_status="1" and stu_type=1;

select stu_tmp.sno, stu_tmp.transaction_date, (case 
when round(stu_tmp.transaction_amount) <> 0 then 1 
when round(stu_tmp.transaction_amount) = 0 then 0 end) as is_consume from (select max(ct.sno) sno, max(ct.transaction_date) transaction_date, sum(ct.transaction_amount) transaction_amount from card_transactions ct where ct.transaction_type = "2" group by ct.transaction_date union select "", "", 1 from undergraduate_students us where us.school_roll = "1" and us.in_school_status = "1" and us.stu_type = 1) as stu_tmp; 

select max(ct.sno) sno, max(ct.transaction_date) transaction_date, sum(ct.transaction_amount) transaction_amount from card_transactions ct where ct.transaction_type = "2" and sno="S201711023" group by ct.transaction_date;

select max(ct.sno) sno, max(ct.transaction_date) transaction_date, sum(ct.transaction_amount) transaction_amount from card_transactions ct where ct.transaction_type = "2" and sno="S201711023" group by ct.transaction_date;

select * from card_transactions where sno = "S201711023" and transaction_date = "2018-04-22";

select ct.sno, sum(ct.transaction_amount) amount from card_transactions ct join undergraduate_students us on ct.sno = us.sno where us.school_roll = "1" and us.in_school_status = "1" and stu_type = 1 and ct.transaction_type = "1" group by ct.sno order by sum(ct.transaction_amount);

select ct.sno, max(us.sname) sname, max(us.department_name) department_name, sum(ct.transaction_amount) amount from card_transactions ct join undergraduate_students us on ct.sno = us.sno where us.school_roll = "1" and us.in_school_status = "1" and stu_type = 1 and ct.transaction_type = "1" group by ct.sno order by sum(ct.transaction_amount);

select max(us.department_name) department_name, count(distinct ct.sno) sno_sum, sum(ct.transaction_amount) transaction_amount from card_transactions ct right join undergraduate_students us on ct.sno = us.sno where us.school_roll = "1" and us.in_school_status = "1" and stu_type = 1 and ct.transaction_type = "1" group by us.department_code;

select sno, transaction_date from card_transactions union select sno, department_name from undergraduate_students limit 100;

select sno, transaction_date from card_transactions where transaction_amount is null and transaction_type = "1" union select sno, department_name from undergraduate_students where school_roll = "1" and in_school_status = "1" and stu_type = 1;


select * from card_transactions where transaction_date between '2018-05-26' and '2018-05-30' and transaction_type = 2;

select B.sno,C.transaction_date from (select sno ,transaction_date from card_transactions  group by transaction_date) C RIGHT join  undergraduate_students B on C.sno=B.sno;


#=====difficult_diggings===================
params = {}
params[:department_code] = nil
params[:gender_code] = nil
params[:current_grade] = nil
params[:poor_level] = "2" #["1","困难生"],["2","非困难生"]]
params[:month_lists] = ["2018-03"].to_json
params[:sno] = "1,2,3"
params[:month_meals] = 20
params[:day_amount] = 15
a=Campus::Scholarship::DifficultDiggings.get_select_res(params)
card_filter,stu_filter,all_stu_filter,database = a
months = JSON.parse(params[:month_lists]).size
search_snos = params[:sno].split(',')
search_stu_filter = search_snos.present? ? " and us.sno in (#{search_snos.map {|x| "'#{x}'"}.join(',')})" : ''
month_meals = params[:month_meals] # 月均消费餐数
day_amount = params[:day_amount] # 日均消费金额

res.map{|x| [x[:sno], x[:meals]]}.to_h
res.each do |row|
	puts row
end

start_time = '2018-03-01'
end_time = '2018-03-07'
database = 'dashboard'

#======impala testing================
1.扫描查询,对整个表执行表扫描
SELECT COUNT(*)
FROM card_transactions
WHERE sno = '15373119';
2.聚合查询,扫描单个表、对行分组并计算每个组的大小
SELECT sno, count(*) cnt
FROM card_transactions
GROUP BY sno
ORDER BY cnt DESC LIMIT 10;
3.联接查询
SELECT tmp.stu_type, ROUND(tmp.count, 2) AS count
FROM (
  SELECT undergraduate_students.stu_type AS stu_type, COUNT(undergraduate_students.sno) AS count
  FROM undergraduate_students JOIN card_transactions ON (
    card_transactions.sno = undergraduate_students.sno
    AND card_transactions.transaction_date BETWEEN '2018-04-01' AND '2018-05-25'
  )
  GROUP BY undergraduate_students.stu_type
) tmp
ORDER BY count DESC LIMIT 10;

优化1：
# 为准备进行联接，impala通过仅包含stu_type，sno的undergraduate_students表构建hash，card_transactions表没有任何内容在内存中进行缓存，但是因为impala在此广播右侧表，所以undergraduate_students表会复制到需要undergraduate_students表进行联接的所有节点。此查询仅适用于 4 GB 输入类，对 8 GB 及更大大小会失败，因为会出现内存不足错误。
SELECT tmp.stu_type, ROUND(tmp.count, 2) AS count
FROM (
  SELECT undergraduate_students.stu_type AS stu_type, COUNT(undergraduate_students.sno) AS count
  FROM card_transactions JOIN undergraduate_students ON (
    card_transactions.sno = undergraduate_students.sno
    AND card_transactions.transaction_date BETWEEN '2018-04-01' AND '2018-05-25'
  )
  GROUP BY undergraduate_students.stu_type
) tmp
ORDER BY count DESC LIMIT 10;

优化2：
# 此查询对高达 64 GB 的输入类，可获得内存效率比第一个版本高 16 倍的查询
SELECT tmp.stu_type, ROUND(tmp.count, 2) AS count
FROM (
  SELECT undergraduate_students.stu_type AS stu_type, COUNT(undergraduate_students.sno) AS count
  FROM undergraduate_students JOIN card_transactions ON (
    card_transactions.sno = undergraduate_students.sno
    AND card_transactions.transaction_date BETWEEN '2018-04-01' AND '2018-05-25'
  )
  GROUP BY undergraduate_students.stu_type
) tmp
ORDER BY count DESC LIMIT 10;

#=======hive建索引尝试=========
select ct_tmp.sno, us_tmp.current_grade, ct_tmp.transaction_amount from (select ct.sno, ct.transaction_amount from dashboard.card_transactions ct where ct.transaction_type = 2 and ct.transaction_date between '2018-03-01' and '2018-03-02') ct_tmp join (select us.sno, us.current_grade from dashboard.undergraduate_students us where us.school_roll = 1 and us.in_school_status = 1 and stu_type in (0,1,4,6,7)) us_tmp on ct_tmp.sno = us_tmp.sno;
=> hive cost 35.3s

select ct.sno, ct.transaction_amount from dashboard.card_transactions ct where ct.transaction_type = 2 and ct.transaction_date between '2018-03-01' and '2018-03-02';
=> hive cost 24.324s, impala cost 114.06s

create index card_transactions_index on table card_transactions(transaction_date) as 'org.apache.hadoop.hive.ql.index.compact.CompactIndexHandler' with deferred rebuild in table card_transactions_index_table;
alter index card_transactions_index on card_transactions rebuild;
select * from card_transactions_index_table limit 1;
=> hive cost 23.239s, impala cost 43.25s

drop index card_transactions_index on card_transactions;

#=====hive分区尝试===========
create table card_transactions partitioned by (transaction_date);

alter table card_transactions add partition (transaction_date='2018-03-01');

alter table card_transactions drop partition (etl_dt=20161118);