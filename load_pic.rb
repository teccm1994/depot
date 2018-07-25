# require 'active_record'
# require 'digest'

# module Rails
#   class <<self
#     def root
#       File.expand_path("..", __FILE__)
#     end
#   end
# end
# def jpg_user
#   cw = 0
#   wjj = "user_imgs"

#   # Dir.mkdir("../public/#{wjj}")
#   StudentPic.find_each do |lin|
#     begin
#       puts sno = lin.sno
#       # puts class_no=UndergraduateStudent.where(:sno=>"#{sno}").first.class_no
#       md5 = Digest::MD5.hexdigest(sno)[0..1]
#       if File::directory?("../public/#{wjj}/#{md5}")#@redis.hexists("jpgss4", "#{class_no}")
#         puts "--------------cun zai--------------------"
#       else
#         Dir.mkdir("../public/#{wjj}/#{md5}")
#         puts "--------------OKWJ--------------------"
#       end
#       file_name = "../public/#{wjj}/#{md5}/#{sno}.jpg"
#       File.open(file_name,"a") do |file|
#         file.puts "#{lin.pic_file}"
#       end
#       puts "--------------OK--------------------"
#     rescue Exception => e
#       puts e
#       cw += 1
#     end
#   end
#   puts "================#{cw}"
# end


# def load_teacher_pic
#   dir_name = "teacher_imgs"
#   TeacherPic.find_each do |lin|
#     begin
#       puts wno = lin.wno
#       md5 = Digest::MD5.hexdigest(wno)[0..1]
#       if File::directory?("../public/#{dir_name}/#{md5}")
#         puts "-----------dir cun zai ---------"
#       else
#         Dir.mkdir("../public/#{dir_name}/#{md5}")
#         puts "--------------create ok --------------------"
#       end
#       file_name = "../public/#{dir_name}/#{md5}/#{wno}.jpg"
#       File.open(file_name,"a") do |file|
#         file.puts "#{lin.pic_file}"
#       end
#       puts "----------------OK------------------"
#     rescue Exception => e
#       puts e
#     end
#   end
# end

# class StudentPic < ActiveRecord::Base
#   establish_connection YAML.load_file("../config/database.yml")["development"]
# end
# class UndergraduateStudent < ActiveRecord::Base
#   establish_connection YAML.load_file("../config/database.yml")["development"]
# end

# class TeacherPic < ActiveRecord::Base
#   establish_connection YAML.load_file("../config/database.yml")["development"]
# end

# jpg_user
# # load_teacher_pic
