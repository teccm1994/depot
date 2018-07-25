#encoding: utf-8
#xlsx
require 'roo'

# obj = Roo::Excel.new("/home/cm/ruby_test/3_visit.xls")
obj = Roo::Excelx.new("/home/cm/ruby_test/3_visit.xlsx")
obj.default_sheet  = obj.sheets.first
obj_results = []
3.upto(obj.last_row) do |line|
	title = obj.cell(line,'A')
	total = obj.cell(line,'B')
	month = obj.cell(line,'C')
	time = obj.cell(line,'D')
	obj_results << [title, total, month, time]
	# new_obj = LibraryWebsiteStatistic.new
	# new_obj.title = title
	# new_obj.total_click = total
	# new_obj.month_click = month
	# new_obj.visit_time = time
	# new_obj.save
end

#xls
#encoding: utf-8 
require 'roo-xls'
obj = Roo::Excel.new("/home/cm/ruby_test/study.xls")
obj.default_sheet  = obj.sheets.first
results = []
2.upto(4) do |line|
	title = obj.cell(line,'A')
	total = obj.cell(line,'B')
	month = obj.cell(line,'C')
	time = obj.cell(line,'D')
	results << [title, total, month, time]
end

require 'parseexcel'  
# require 'spreadsheet'
book = Spreadsheet.open('/home/cm/ruby_test/study.xls')
sheet = book.worksheet 0
sheet.each { |row|  
  j=0  
  i=0  
  if row != nil  
  #遍历该行非空单元格  
  row.each { |cell|  
    if cell != nil  
      #取得单元格内容为string类型  
      contents = cell 
      puts "Row: #{j} Cell: #{i}> #{contents}"  
    end  
    i = i+1  
  }  
  end  
}  
#ruby -rubygems test.rb study.xls  

#csv
#read
require 'csv'  
res=[]
Roo::CSV.new("/home/cm/ruby_test/csv_test.csv").each do |person|  
    res << person  
end 

#write
CSV.open("/home/cm/ruby_test/csv_test.csv", "wb") do |csv|
  csv << ["wno", "name", "code"]
  csv << ["001", "xiaoming","66"]
  # ...
end

