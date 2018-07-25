file = "/campus_apps/wzu_scholarship/2017scholarship.xlsx"
Campus::Scholarship::PoorStudent.save_to_mysql(file, "2017",0)

release_warning_list = Campus::WarningLost::LostWarning.where("date(created_at)=? and sno not in (?) and status in (0,1)",warning_date - 1.day, warning_students.map(&:sno)).to_a

def name
	"失联预警"
end

sno_list = Campus::Warning::WarningRule.where(name: name).joins(:warning_rule_results).select('warning_rule_results.sno').map(&:sno)
Campus::Warning::WarningRule.joins(:warning_rule_results)
sno_list = Campus::Warning::WarningRuleResult.all.map(&:sno)

def rule_white_list
  Campus::Warning::WarningWhiteList
    .where("start_time<=DATE(NOW()) and end_time>=DATE(NOW()) and warning_type like '%失联预警%'")
    .select(&:sno).map {|x| x.sno.split(",")}.flatten
end

sno_list.include?("1010214103")

Campus::WarningLost::LostWarning.where("date(created_at)=?", Date.today)

rules_json = JSON.parse(Campus::Warning::WarningRule.first.rules)
rule.value.map {|x| {sno: x, warning_rule_id: Campus::Warning::WarningRule.first.id}}


rule_white_list = Campus::Warning::ArrayRule.new(
            "过滤白名单中的学生",
            Campus::Warning::WarningWhiteList
                .where("start_time<=DATE(NOW()) and end_time>=DATE(NOW()) and warning_type like '失联预警' and expired=true")
                .map {|x| x.white_list_students.pluck(:sno)}.flatten.uniq)
warning = Campus::Warning::WarningRule.where(name: '失联预警').first
rules_json = JSON.parse(warning.rules)
snos = rule.value
snos.include?("1010214103")
::Dashboard::CardTransaction.where("sno=?", "1010214103").last
rule = JSON.parse(Campus::Warning::WarningRule.where(name: "失联预警").first.rules).map {|x| x['data_source']}.join(',')



::Dashboard::UndergraduateStudent.school.joins("join teacher_classes e on undergraduate_students.#{Campus::Core.config.college ? 'college_class_no' : 'class_no'}=e.class_no COLLATE utf8_unicode_ci").joins('join employees f on e.wno=f.wno')

::Dashboard::TeacherClass.joins("join employees e on teacher_classes.wno = e.wno")

alter table lost_warnings add index sno_index (sno);
alter table lost_warnings add index department_code_index (department_code);
alter table lost_warnings add index status_index (status);
alter table lost_warnings add index created_at_index (created_at);
alter table lost_warnings add index last_track_time_index (last_track_time);

select ct.transaction_date, sum(ct.transaction_amount) transaction_amount from dashboard.card_transactions ct join dashboard.undergraduate_students us on ct.sno = us.sno where us.school_roll = '1' and us.in_school_status = '1' and stu_type = 1 and ct.transaction_type = '2'  and ct.transaction_date between '2018-05-27' and '2018-05-29' group by ct.transaction_date;
 

sno_test = Hash.new{|h,keys| h[keys]=[]}
test = Campus::Scholarship::GrowthBgQuestResult.find_by_sql("select gr.sno, go.option_score from growth_bg_quest_results gr join growth_bg_quest_options go on gr.quest_num = go.quest_num and find_in_set(go.option, gr.option)")
test = Campus::Scholarship::GrowthBgQuestResult.find_by_sql("select gr.sno, go.option_score from growth_bg_quest_results gr join growth_bg_quest_options go on find_in_set(go.option, gr.option) ")
test.map{|x| sno_test[x.sno] << x.try(:option_score)}
sno_test

"select substr('["A","B","C","D","E"]',instr('["A","B","C","D","E"]','A'),1),
substr('["A","B","C","D","E"]',instr('["A","B","C","D","E"]','B'),1),
substr('["A","B","C","D","E"]',instr('["A","B","C","D","E"]','C'),1),
substr('["A","B","C","D","E"]',instr('["A","B","C","D","E"]','D'),1),
substr('["A","B","C","D","E"]',instr('["A","B","C","D","E"]','E'),1),
substr('["A","B","C","D","E"]',instr('["A","B","C","D","E"]','F'),1),
substr('["A","B","C","D","E"]',instr('["A","B","C","D","E"]','G'),1) from growth_bg_quest_results "

# 民大辅导员与班级多对多测试
wno_class = Hash.new{|h,keys| h[keys]=[]}
::Dashboard::TeacherClass.group(:class_no).select(:wno,:class_no).map{|x| wno_class[x.class_no] << x.wno}

w_c = ::Dashboard::TeacherClass.where(wno:users).pluck(:wno,:class_no).to_h
::Dashboard::TeacherClass.where(class_no:"1421804020304").pluck(:wno)
cc = ::Dashboard::TeacherClass.where(class_no:w_c.values).group(:class_no).count.select{|k,v| v!=1}
{"14206110205"=>2, "14211090304"=>2, "1421804020304"=>2, "15208150402"=>2, "15210170202"=>2, "15212180104"=>2, "16208150403"=>2, "16212180104"=>2, "16217230202"=>2, "1621804020304"=>2, "1720313050502"=>2, "17206110904"=>2, "17210170202"=>2}
2011003, 2015110527
2016020, 8800035
2016016, 2014026 :)
dd=::Dashboard::TeacherClass.where(class_no:cc.keys).pluck(:wno)

'SELECT `school_works`.`department_name`, COUNT(`school_works`.`department_name`) AS `count` FROM `school_works` WHERE (`school_works`.`school_year` = 2017 AND `school_works`.`school_term` = 1) GROUP BY `school_works`.`department_name` ORDER BY NULL'

'select department_name, count(department_name) count from school_works where school_year=2017 and school_term=1 group by department_name' 

for p in Schoolwork.objects.raw('select department_name, count(department_name) count from school_works where school_year=2017 and school_term=1 group by department_name'):
	print(p)

for p in Schoolwork.objects.raw('select * from school_works limit 2'):

['32', '33', '34', '35', '36', '37', '38', '39', '42', '43', '44', '45', '46', '47', '48', '49']

2018.07.20


