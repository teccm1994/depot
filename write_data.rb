province = {1=>"湖北", 2=>"湖南", 3=>"广西", 4=>"河南", 5=>"北京", 6=>"西藏", 7=>"新疆", 8=>"云南", 9=>"黑龙江"}
::Dashboard::UndergraduateStudent.find_each do |x|
  x.native_province = province[rand(1..9)]
  x.save
end

#网格化管理：User, UserCampusApp, GridUserRole
#失联预警：User, UserCampusApp, Teacher
#数据检索：User, UserCampusApp, DataSearchUserRole
#学业预警：User, UserCampusApp, Teacher
#消费预警：User, UserCampusApp, Teacher
#困难生认定：User, UserCampusApp, Teacher
#身心预警：User, UserCampusApp, Teacher
#微信端相关：Employee，LostLeader，TeacherClass, ConsumptionWeixinUserList,  
#                HealthWeixinUserList,  PoorWeixinUserList,  SchoolwarkWeixinUserList
wnos, class_noes, emails = [], [], []
[{:wno=>'2011058',:class_no=>["15209080101", "15209080101", "15209080102", "15209080102"]},{:wno=>'2051010',:class_no=>["13217230201", "13217230202", "14217230201"]}].each do |x| 
	wnos << x[:wno]
	class_noes << x[:class_no]
	emails << "#{x[:wno]}@scuec.edu.cn"
end
wnos, class_noes, emails = [], [], []
[{:wno=>'2011058',:class_no=>["15209080101", "15209080101", "15209080102", "15209080102"]},{:wno=>'2051010',:class_no=>["13217230201", "13217230202", "14217230201"]}].each do |x| 
	 x[:class_no].each do |y|
	 	wnos << x[:wno]
	 	emails << "#{x[:wno]}@scuec.edu.cn"
	 	class_noes << y
	 end
end
lists = [{:user_id=>'271',:wno=>'2015110078',:level=>'1',:department_code=>'215'},
{:user_id=>'237',:wno=>'2014044',:level=>'1',:department_code=>'216'},
]
#ConsumptionWeixinUserList, HealthWeixinUserList,  PoorWeixinUserList,  SchoolwarkWeixinUserList
lists.each do |x|
	obj = SchoolwarkWeixinUserList.new
	obj.user_id = x[:user_id]
	obj.wno = x[:wno]
	obj.level = x[:level]
	obj.department_code = x[:department_code]
	obj.save
end
obj = ConsumptionWeixinUserList.new
	obj.user_id = '104'
	obj.wno = '2041507'
	obj.level = '2'
	obj.department_code = '109'
	obj.save

#User--ok
[{:name=>'丁文强',:wno=>'2016110247'},{:name=>'王铁',:wno=>'2014110495'}].each do |x| 
	obj = User.new
	obj.user_name = x[:name]
	obj.hashed_password = Digest::SHA1.hexdigest("123456")
	obj.email = "#{x[:wno]}@scuec.edu.cn"
	obj.person_type = 1
	obj.wno = x[:wno]
	obj.save
end
#Teacher--ok
[{:name=>'丁文强',:wno=>'2016110247',:department_code=>'213'},{:name=>'王铁',:wno=>'2014110495',:department_code=>'220'}].each do |x| 
	obj = Teacher.new
	obj.teacher_name = x[:name]
	obj.teacher_num = x[:wno]
	obj.department_num = x[:department_code]
	obj.level = 1
	obj.save
end
#UserCampusApp--ok
[{:user_id=>'288',:campus_app_id=>[2,3,4,5,6,7]}].each do |x|
	x[:campus_app_id].each do |y|
		obj  = UserCampusApp.new
		obj.user_id = x[:user_id]
		obj.campus_app_id = y
		obj.display = true
		obj.save
	end
end
#DataSearchUserRole--ok
[{:user_id=>'279',:wno=>'2015110236'},{:user_id=>'280',:wno=>'2016110247'}].each do |x| 
	obj  = DataSearchUserRole.new
	obj.user_id = x[:user_id]
	obj.wno = x[:wno]
	obj.data_search_role_id = 1
	obj.save
end

user_ids = ['237','264','271','272','273','274','275','276','277','278','279','280','281']
ids = ["142","22", "280", "282", "283", "284", "285", "286", "287", "288", "289", "290", "291"]
teacher_ids = ['2014044','2013040','2015110078','2016015','2016110327','2016110382','2015110380','2015110148','2016110134','2015110527','2015110236','2016110247','2014110495']
#TeacherClass--ok
[{:teacher_id=>'289',:class_no=>['16213100101','16213100102','16213100501','16213100502','16213100601','16213100602','16213100603','16213100604','16213101201','16213101202','16213101203']},{:teacher_id=>'290',:class_no=>['16213100101','16213100102','16213100501','16213100502','16213100601','16213100602','16213100603','16213100604','16213101201','16213101202','16213101203']}].each do |x| 
	x[:class_no].each do |y|
		obj  = TeacherClass.new
		obj.teacher_id = x[:teacher_id]
		obj.class_no = y
		obj.save
	end
end
ids.each_with_index do |x,i|
	obj = TeacherClass.where(:teacher_id=>x).first
	obj.teacher_id = teacher_ids[i]
	puts teacher_ids[i]
	obj.save
end
#Employee--ok
[{:name=>'丁文强',:wno=>'2016110247',:department_code=>'213'},{:name=>'王铁',:wno=>'2014110495',:department_code=>'220'}].each do |x| 
	obj  = Employee.new
	obj.name = x[:name]
	obj.wno = x[:wno]
	obj.department_code = x[:department_code]
	obj.save
end

#LostLeader--ok
[{:user_id=>281,:teacher_id=>'291'},{:user_id=>280,:teacher_id=>'290'}].each do |x| 
	obj  = LostLeader.new
	obj.user_id = 281
	obj.teacher_id = '291'
	obj.level = 1
	obj.save
end

user_ids.each_with_index do |x,i|
	obj = LostLeader.new
	obj.user_id = x
	obj.teacher_id = wnos[i]
	obj.save
end

ids.each_with_index do |x,i|
	obj = LostLeader.where(:teacher_id=>x).first
	obj.teacher_id = teacher_ids[i]
	puts teacher_ids[i]
	obj.save
end

#user:user_name,hashed_password,person_type
#user_campus_app:     user_id,campus_app_id,display
#grid_user_role:     grid_id（区域id）,grid_role_id（权限id）,user_id,wno
#grid_role:　{"1"=>"校级"},{"2"=>"片区"},{"3"=>"楼宇"}
all = UserCampusApp.where("id > ? and id < ?",325,379)
all.each do |x|
  x.campus_app_id = 1
  x.save
  end

obj = DataSearchUserRole.new
obj.data_search_role_id = 1
obj.user_id = 42
obj.wno = "2029207"
obj.save


obj = GridUserRole.new #网格化管理
obj.grid_role_id = 1
obj.wno = "2015020"
obj.user_id = 162
obj.grid_id = "0"
obj.save

obj  = UserCampusApp.new
obj.user_id = 281
obj.campus_app_id = 6
obj.display = true
obj.save

obj = User.new
obj.user_name = "doctor"
obj.hashed_password = Digest::SHA1.hexdigest("123456")
obj.email = "doctor@xjgreat.com"
obj.person_type = 1
obj.wno = "00303888"
obj.save

obj = LostLeader.new #微信端消息推送
obj.user_id = 237
obj.level = 1
obj.teacher_id = "2014044"
obj.save
#快速插入数据
@campus_app = CampusApp.where(:name=>"失联预警").first
users = @campus_app.users
users.each do |user|
  level = Teacher.where(:teacher_num=>user.wno)
  obj = LostLeader.new #微信端消息推送
  obj.user_id = user.id
  obj.level = level
  obj.teacher_id = user.wno
  obj.save
end

#困难生预警规则poor_student_regular
obj = PoorStudentRegular.new
obj.name = "特别困难"
obj.low_rank = "0"
obj.high_rank = "5%"
obj.save

#清理学业预警及历史操作的脏数据
# SchoolwarkWarning：warning_term_code=nil，department_code=nil，grade=nil，current_lvl_name=nil
# WarningLog：source_id，warning_type
all = SchoolwarkWarning.where(:current_lvl_name=>nil)
all.each do |x|
  log = WarningLog.where(:source_id => x.id)
  if log.count != 0
    log.each do |y|
      y.delete
      y.save
    end
  end
  x.delete
  x.save
end

UndergraduateStudent.where(department_code:"14").limit(3).each do |x|
	hash={}
	hash = {:sno=>x.sno, :sname=>x.sname, :department_code=>x.department_code, :class_no=>x.class_no, :major_code=>x.major_code, :school_roll=>"1", :in_school_status=>"1"}
	hash[:warning_type] = "01"
	hash[:warning_term] = "2016-2017"
	hash[:warning_term_code] = "02"
	hash[:warning_code] = "38"
	hash[:data_source] = "0"
	hash[:operate_time] = Time.now-rand(2..10).day
	hash[:department_name] = Department.where(num:x.department_code).first.name
	hash[:major_name] = UndergraduateMajor.where(major_code:x.major_code).first.major_name
	obj = SchoolwarkWarning.new(hash)
	obj.save
end
UndergraduateStudent.where(department_code:"306").limit(5).each do |x|
	hash={}
	hash = {:sno=>x.sno, :sname=>x.sname, :department_code=>x.department_code, :class_no=>x.class_no, :major_code=>x.major_code, :school_roll=>"1", :in_school_status=>"1"}
	hash[:total_money] = 0.0
	hash[:warning_time] = Time.now-rand(1..2).day
	hash[:desp] = "低消费:48小时内无消费"
	hash[:warning_code] = "2"
	hash[:grade] = x.grade
	hash[:auditing_status] = "2"
	hash[:department_name] = Department.where(num:x.department_code).first.name
	hash[:major_name] = UndergraduateMajor.where(major_code:x.major_code).first.major_name rescue ""
	obj = ConsumptionWarning.new(hash)
	obj.save
end

NetworkWarning.each_with_index do |x,y|
y = 88888
obj = UndergraduateStudent.find(y)
if obj.blank?
x.sno = obj.sno
x.sname = obj.sname
x.class_no = obj.class_no
x.major_code = obj.major_code
x.major_name = UndergraduateMajor.where(major_code:obj.major_code).first.major_name rescue ""
x.department_code = obj.department_code rescue ""
x.department_name = Department.where(num:obj.department_code).first.name rescue ""
x.save
else 
end
end
end
Department.where(parent_num:"0").collect{|x| [x.name,x.num]}
 

#更新困难生认定的school_roll字段
all = PoorStudent.where(:school_roll=>"999")
all.each do |x|
	x.school_roll = "1"
	x.save
end


#商学院GridStudentInfo造数据
# def self.create_test_data
  y = 0
  PhysicalGrid.where(:lvl=>5).find_each do |x|
    students = UndergraduateStudent.offset(y).first(7)
    y += 7
    students.each do |s|
      if GridStudentInfo.where(:sno=>s.sno).blank?
        obj = GridStudentInfo.new
        obj.grid_id = x.grid_id
        obj.sno = s.sno
        obj.save
      end
    end
  end
# end

#写地图数据
name = '北区'
name = '南区'
map_grid_id= ''
lat = '3280' #纬度 Latitude
lng = '5601' #经度 Longitude 
g = PhysicalGrid.where(:name=>name).first
gs = g.get_grid_ids
gs.each do |x|
  a = PhysicalGrid.where(:grid_id=>x).first
  a.map_grid_id = map_grid_id
  a.lat = lat
  a.lng = lng
  a.save
end



#Employee表若昨日有新增数据，则更新整个es
def update_employee_es
	emp = Employee.where("created_at >= ?",Time.now.yesterday)
	if !emp.blank?
		begin 
			#删除索引
			Employee.__elasticsearch__.delete_index!
			#创建索引
		 	Employee.__elasticsearch__.create_index! force: true
		 	#索引数据
		 	Employee.create_index
	 	rescue Exception => e
	     puts e
	    end
   end
end
判断昨日mysql若有新增数据，然后有两种方案，1：先删除es
后更新整个es；2：更新选中的mysql数据的es，employee表没有
更新es的方法。鉴于数据不多，可选择第一种方案。

obj = ConsumptionWarningRule.new
obj.name = "月消费增长比例异常"
obj.warning_code = "5"
obj.value = 50
obj.save

#添加消费预警数据
UndergraduateStudent.first(100).each do |x|
  a = ConsumptionWarning.new
  a.status = 0
  a.sno = x.sno
  a.sname = x.sname
  a.total_money = 500.0
  a.class_no = x.class_no
  a.department_code = x.department_code
  a.major_code = x.major_code
  a.desp = "低消费"
  a.warning_time = Time.now
  a.warning_code = "2"
  a.grade = x.admission_grade
  a.department_name = Department.where(:num=>x.department_code).first.name rescue "未知"
  a.major_name = UndergraduateMajor.where(:major_code=>x.major_code).first.major_name rescue "未知"
  a.stu_type = "1"
  a.in_school_status = "1"
  a.school_roll = "1"
  a.auditing_status = "0"
  a.save
end

#Role表导入数据
[#<Role id: 1, name: "校级", created_at: "2016-07-11 06:14:07", updated_at: "2016-09-09 10:09:58", level: 2>, #<Role id: 2, name: "院级", created_at: "2016-07-11 06:14:07", updated_at: "2016-09-09 10:10:48", level: 3>, #<Role id: 3, name: "辅导员", created_at: "2016-07-11 06:14:07", updated_at: "2016-09-09 08:34:11", level: 1>
, #<Role id: 4, name: "管理员", created_at: "2016-07-11 06:14:07", updated_at: "2016-09-09 08:35:48", level: 4>, #<Role id: 9, name: "心理医生", created_at: "2016-08-07 07:41:50", updated_at: "2016-09-09 08:37:09", level: 6>, #<Role id: 10, name: "身体医生", created_at: "2016-08-07 07:41:50", updated_at: "2016-09-09 08:37:19", level: 7>]
roles = [{:name=>"校级",:level=>2},{:name=>"院级",:level=>3},{:name=>"辅导员",:level=>3},{:name=>"院级",:level=>3},{:name=>"管理员",:level=>4},{:name=>"心理医生",:level=>6},{:name=>"身体医生",:level=>7}]
roles.each do|role|
	obj = Role.new
	obj.name = role[:name]
	obj.level = role[:level]
	obj.save
end


学业预警：
SchoolwarkWarning，UndergraduateStudent，Department，UndergraduateMajor，ClassInfo
Teacher，CardAccount，SchoolwarkWarningLevel，SchoolwarkWarningRule
消费预警：　
ConsuptionWarning，ConsumptionWarningRule，ConsumptionWeixinUserList
身心预警：　
PsychologyWarningResult，PsychologyWarningLevel，PsychologyWarningRule，PsychologyWeixinUserList
SportResult, HealthWarningLevel, HealthWarningRule, HealthWeixinUserList
失联预警：　
CardTransaction, PossibleMissingStudent, MissingHistoryPerson, Employee, MissingHistory
UndergraduateStudentNetLog, TeacherClass, WhiteListLog,, LostWhiteList, User

department = Department.where("name LIKE ?",'%学院')
department.each do |x|
	x.parent_num = "0"
	x.save
end

key="DEPARTMENT"
book= {"317000"=>"信息学院", "315000"=>"公共管理学院", "302000"=>"动科动医学院", "305000"=>"园艺林学学院", "316000"=>"国际学院", "312000"=>"外国语学院", "307000"=>"工学院", "311000"=>"文法学院", "301000"=>"植物科学技术学院", "412000"=>"楚天学院", "308000"=>"水产学院", "310000"=>"理学院", "304000"=>"生命科学技术学院", "306000"=>"经济管理学院", "215000"=>"继续教育学院", "303000"=>"资源与环境学院", "309000"=>"食品科学技术学院", "314000"=>"马克思主义学院"} 
$redis.lpush(key,book.to_json) 
@departments = JSON.parse($redis.lrange("DEPARTMENT",0,-1)[0])
@departments.each do |x|
	puts x[0]
end

obj = CampusApp.new
obj.name = "读者行为分析"
obj.home_name = "读者行为分析"
obj.app_key = "20161118154411129"
obj.app_secret = "dd907947b92c6593c1c8d78163c253f9f05ec07a"
obj.status = 0
obj.home_url = ""
obj.is_published = 1
obj.home_page_icon = "/assets/home_page/anniu__53.png"
obj.home_page_small_icon = "/assets/home_page/tub6.png"
obj.is_published_college = 1
obj.save

app = UserCampusApp.new
app.user_id = 1
app.campus_app_id = 13
app.display = true
app.save


/*******武城职移动端部署数据绑定***************/
User.create(user_name:"曾芬", email:"zengfen@xjgreat.com", hashed_password: "7c4a8d09ca3762af61e59520943dc26494f8941b", wno:"zengfen", person_no:"zengfen", status:"1")
Teacher.create(teacher_name:"曾芬",teacher_num:"zengfen",level:2)
Employee.create(name:"曾芬",wno:"zengfen",department_code:"00022")
LostLeader.create(user_id:215, teacher_id:"zengfen", level:2)
GridUserRole.create(grid_role_id:1, wno:"chenming", user_id:217, grid_id:"0")

User.where(wno:"02003006")
Teacher.where(teacher_num:"02003006")[1]
Employee.where(wno:"02001049")
LostLeader.where(user_id:214)
UserCampusApp.where(user_id:1)


User.create(user_name:"冯娟", email:"fengjuan@whcp.edu.cn", hashed_password: "7c4a8d09ca3762af61e59520943dc26494f8941b", wno:"02003006", person_no:"02003006", status:"1")
Teacher.create(teacher_name:"冯娟",teacher_num:"02003006", department_num: "00016",level:2)
Employee.create(name:"陈明",wno:"chenming",department_code:"00022")
LostLeader.create(user_id:214, teacher_id:93, level:2)

UserCampusApp.create(user_id:217,campus_app_id:5,display:true,role_type:0)

GridUserRole.create(grid_role_id:1, wno:"chenming", user_id:216, grid_id:"0")


INSERT INTO `users` (`city`, `company`, `created_at`, `district`, `email`, `gender`, `hashed_password`, `head_pic`, `invite`, `is_developer`, `nike_name`, `person_no`, `person_type`, `phone`, `province`, `status`, `updated_at`, `user_name`, `user_type`, `validate_code`, `weixin`, `wno`) VALUES (NULL, NULL, '2018-01-16 18:00:21', NULL, 'fengjuan@whcp.edu.cn', NULL, '7c4a8d09ca3762af61e59520943dc26494f8941b', NULL, NULL, 0, NULL, '02003006', NULL, NULL, NULL, '1', '2018-01-16 18:00:21', '冯娟', 0, NULL, NULL, '02003006')


#user_info = [{name:"黄帅", user_name:"huangshuai", user_no:"02001049", department_code:"000`22", level:2}]
def import_data(user_info)
    employees = []
    user_info.each do |info|
        user = User.find_and_create({user_name:info[:name], email:"#{info[:user_name]}@whcp.edu.cn", hashed_password:"7c4a8d09ca3762af61e59520943dc26494f8941b", wno:info[:user_no], person_no:info[:user_no], status:"1"})
        UserCampusApp.find_and_create(user_id:user.id,campus_app_id:5,display:true,role_type:0)
        teacher =  Teacher.find_and_create({teacher_name:info[:name], teacher_num:info[:user_no], level:2})
        employees << {name:info[:name], wno:info[:user_no], department_code:info[:department_code]}
        LostLeader.find_and_create({user_id:user.id, teacher_id:teacher.id, level:info[:level]})
    end
    Employee.find_and_create(employees)
end


