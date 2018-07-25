    # -*- coding:utf-8 -*-   
    require 'mysql2'  
    client=nil  
    infile=nil  
    begin  
      client = Mysql2::Client.new(:host => "localhost", :username => "root", :password => "1", :database => "mysql")  
      infile=File.new("");  
      number=1  
      buffer=""  
      infile.each do |line|  
        array=(line.strip+",").split(",")  
        string="(#{number},'#{array[0]}','#{array[1]}',#{array[2]},'#{array[3]}')"  
        if(number%1000==0)  
            buffer+=string  
            sql="insert into XXX values #{buffer};"  
            client.query(sql)  
            buffer=""  
            puts number  
        else  
            buffer+=string+","  
        end  
        #puts sql  
        number+=1  
      end  
      sql="insert into XXX values #{buffer.chop};"  
      client.query(sql)  
    rescue  
      #puts "error"  
      puts $!  
      puts $@  
    ensure  
      client.close  
      infile.close  
    end  