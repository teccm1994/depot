#encoding: utf-8
require 'roo'
require 'roo-xls'

def read_file(file)
	hash = []
	type = file.split(".").last
    begin
      case type
      when "xlsx" then
        obj = Roo::Excelx.new(file)
      when "xls" then
        obj = Roo::Excel.new(file)
      when "csv" then
        obj = Roo::CSV.new(file)
      end
    rescue Exception=>e
      p e
      return false
    end
     obj.sheets.each_with_index do |s,index|
     	obj.default_sheet = s
     	break if index>0
     	for i in (obj.first_row+1)..obj.last_row
              results= {}
     		results[obj.cell(1,'A').to_s.strip] = obj.cell(i,'A').to_s.strip
     		results[obj.cell(1,'B').to_s.strip] = obj.cell(i,'B').to_s.strip
     		results[obj.cell(1,'C').to_s.strip] = obj.cell(i,'C').to_s.strip
     		results[obj.cell(1,'D').to_s.strip] = obj.cell(i,'D').to_s.strip
     		results[obj.cell(1,'E').to_s.strip] = obj.cell(i,'E').to_s.strip
              hash << results
     	end
     end
     puts "results:========#{type}"
     puts hash
end
# file="/home/cm/ruby_test/3_visit.xlsx"
# file="/home/cm/ruby_test/study.xls"
file="/home/cm/ruby_test/csv_test.csv"
read_file(file)