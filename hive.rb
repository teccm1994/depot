HADOOP_USER_NAME=hdfs sqoop import --connect jdbc:mysql://bjuthadoop06:8080/dashboard --username root -P --split-by id --table card_transactions --target-dir /user/hive/warehouse/dashboard/card_transactions --fields-terminated-by "," --hive-import --create-hive-table --hive-table dashboard.card_transactions
HADOOP_USER_NAME=hdfs sqoop import --connect jdbc:mysql://bjuthadoop06:8080/dashboard --username root -P --split-by id --table undergraduate_students --target-dir /user/hive/warehouse/dashboard/undergraduate_students --fields-terminated-by "," --hive-import --create-hive-table --hive-table dashboard.undergraduate_students

HADOOP_USER_NAME=hdfs spark-shell --master yarn --executor-memory 4g --num-executors 2 --executor-cores 4
HADOOP_USER_NAME=hdfs hive

sqlContext.sql("use dashboard")

Impala.connect('bjuthadoop02', 21000) do |conn|
  conn.query("select department_name,sum(transaction_amount) from dashboard.card_transactions c join dashboard.undergraduate_students s"+
" on c.sno=s.sno" +
" where transaction_time>='2018-01-01' and transaction_time<'2018-05-01'"+
" group by department_name")
end

Impala.connect('172.21.98.179', 21000) do |conn|
    conn.query("select sno, sum(*) as cnt
from (
select sno,transaction_date,
case when (sum(case when hour(transaction_time) < 10 and hour(transaction_time) >= 6 then 1 else 0 end) as breakfast) > 0 then 1 else 0 end ,
sum(case when hour(transaction_time) <= 13 and hour(transaction_time) >= 10 then 1 else 0 end) as lunch,
sum(case when hour(transaction_time) <= 20 and hour(transaction_time) >= 17 then 1 else 0 end) as surper
 from dashboard.card_transactions
where transaction_date >= cast(DATE_ADD(NOW(),INTERVAL -24 DAY) as varchar(50))
group by sno,transaction_date) t where breakfast <> 0 and lunch <> 0 and surper <> 0
group by sno;")
end



Impala.connect('172.21.98.179', 21000) do |conn|
    conn.query("
select sno,transaction_date,
sum(case when hour(transaction_time) < 10 and hour(transaction_time) >= 6 then 1 else 0 end) as breakfast,
sum(case when hour(transaction_time) <= 13 and hour(transaction_time) >= 10 then 1 else 0 end) as lunch,
sum(case when hour(transaction_time) <= 20 and hour(transaction_time) >= 17 then 1 else 0 end) as surper
 from dashboard.card_transactions
where transaction_date >= cast(DATE_ADD(NOW(),INTERVAL -24 DAY) as varchar(50))
group by sno,transaction_date")
end

Impala.connect('172.21.98.179', 21000) do |conn|
    conn.query("select ct.sno, date_format(ct.transaction_time, '%H') as time_hour from dashboard.card_transactions ct join undergraduate_students us on ct.sno = us.sno COLLATE utf8_unicode_ci where us.school_roll = 1 and us.in_school_status = 1 and stu_type = 1  and ct.transaction_date >= NOW() - 7 group by time_hour, ct.sno")
end

Impala.connect('172.21.98.179', 21000) do |conn|
    conn.query("select cast(DATE_ADD(NOW(),INTERVAL -7 DAY) as varchar(50))")
end

Impala.connect('172.21.98.179', 21000) do |conn|
    conn.query("select hour(cast('2018-10-10 11:11:11' as datetime))")
end

Impala.connect('172.21.98.179', 21000) do |conn|
    conn.query("select hour('2018-10-10 13:11:11')")
end


Impala.connect('172.21.98.179', 21000) do |conn|
    conn.query("select sno, sum(case when breakfast > 0 then 1 else 0 end) as breakfast,sum(case when lunch > 0 then 1 else 0 end) as lunch ,sum(case when surper > 0 then 1 else 0 end) as surperfrom (select sno,transaction_date,sum(case when hour(transaction_time) < 10 and hour(transaction_time) >= 6 then 1 else 0 end) as breakfast,sum(case when hour(transaction_time) <= 13 and hour(transaction_time) >= 10 then 1 else 0 end) as lunch,sum(case when hour(transaction_time) <= 20 and hour(transaction_time) >= 17 then 1 else 0 end) as surper from dashboard.card_transactions
where transaction_date >= NOW() - 7 group by sno,transaction_date)
group by sno")
end

new Date()
sqlContext.sql("select department_name,sum(transaction_amount) from dashboard.card_transactions c join dashboard.undergraduate_students s"+
" on c.sno=s.sno" +
" where transaction_time>='2018-01-01' and transaction_time<'2018-05-01'"+
" group by department_name").show()
new Date()
sqlContext.sql("select department_name,sum(transaction_amount) from dashboard.card_transactions_parquet c join dashboard.undergraduate_students_parquet s"+
" on c.sno=s.sno" +
" where transaction_time>='2018-01-01' and transaction_time<'2018-05-01'"+
" group by department_name").show()
new Date()

curl -u admin:admin 'clouderamanager.zhdd.com/api/v9/clusters/Cluster1/services/impala/impalaQueries/364e76f05cdffsdf802b0:3a499cc3fb86bf8afsd'

/clusters/cluster1/services/{serviceName}/impalaQueries


select transaction_date,sum(transaction_amount) from dashboard.card_transactions c join dashboard.undergraduate_students s
 on c.sno=s.sno
 where transaction_time>='2017-03-01' and transaction_time<'2018-04-01'
 group by transaction_date;

select department_name,sum(transaction_amount) from dashboard.card_transactions_parquet c join dashboard.undergraduate_students_parquet s
 on c.sno=s.sno
 where transaction_time>='2018-01-01' and transaction_time<'2018-05-01'
 group by department_name;

CREATE external table if not exists `card_transactions_parquet`(
  `id` int, 
  `transaction_id` string, 
  `record_date` string, 
  `transaction_date` string, 
  `transaction_time` string, 
  `transaction_amount` int, 
  `transaction_balance` int, 
  `total_transaction_number` int, 
  `transaction_type` string, 
  `transaction_status` int, 
  `merchant_code` string, 
  `sno` string, 
  `card_account_num` string, 
  `created_at` string, 
  `updated_at` string, 
  `sub_merchant_code` string, 
  `person_type` string, 
  `sub_person_type` string)
STORED AS PARQUET;

insert into card_transactions_parquet select * from card_transactions;

CREATE external table if not exists `undergraduate_students_parquet`(
  `id` int, 
  `sno` string, 
  `sname` string, 
  `name_spelling` string, 
  `gender_code` int, 
  `gender` string, 
  `nation_code` string, 
  `nation_name` string, 
  `class_no` string, 
  `class_name` string, 
  `birth_date` string, 
  `email` string, 
  `department_code` string, 
  `department_name` string, 
  `major_code` string, 
  `admission_date` string, 
  `admission_grade` string, 
  `current_grade` int, 
  `current_major_name` string, 
  `current_major_code` string, 
  `student_politics_status` string, 
  `identify_num` string, 
  `native_place` string, 
  `is_important` int, 
  `weixin_id` string, 
  `phone` string, 
  `qq_num` string, 
  `stu_type` int, 
  `created_at` string, 
  `updated_at` string, 
  `origin_place_code` string, 
  `origin_place` string, 
  `candidate_num` string, 
  `grade` string, 
  `schooling_period` string, 
  `cultivat_mode_code` string, 
  `cultivation_mode` string, 
  `marital_status_code` string, 
  `marital_status` string, 
  `graduation_time` string, 
  `home_address` string, 
  `home_postcode` string, 
  `home_phone` string, 
  `difficult_code` string, 
  `difficult_name` string, 
  `normal_student_code` string, 
  `normal_student_name` string, 
  `dormitory` string, 
  `room_number` string, 
  `identify_type` string, 
  `student_head_pic` string, 
  `expect_graduation_year` string, 
  `blood_type` string, 
  `health_code` string, 
  `nationality` string, 
  `current_registration_place` string, 
  `native_province` string, 
  `native_city` string, 
  `major_name` string, 
  `student_politics_name` string, 
  `admission_score` string, 
  `stu_type_name` string, 
  `current_age` int, 
  `is_loan` int, 
  `cultivation_levlel_code` string, 
  `cultivation_level_name` string, 
  `in_school_status` string, 
  `school_roll` string, 
  `school_state_code` string, 
  `register_status` string, 
  `college_code` string, 
  `college_name` string, 
  `college_class_no` string, 
  `college_class_name` string)
STORED AS PARQUET;

insert into undergraduate_students_parquet select * from undergraduate_students;