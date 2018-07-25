#数据类型
#encoding返回一个字符串的编码方式
s = "2 x 2 = 4"
s.encoding

#valid_encoding检查是否可使用该字符串的编码方式将其字节解释为一个有效的字符序列
s = "\xa4".force_encoding("utf-8")
s.valid_encoding?

#encode改变构成该字符串的底层字节,常见改变字符串编码的情形，是在将它们写入文件
#或通过网络连接进行发送的时候。
euro1 = "\u20AC"
puts euro1
euro1.encoding
euro1.bytesize  => 3

euro2 = euro1.encode("iso-8859-15")
puts euro2.inspect
euro2.encoding
euro2.bytesize  => 1

#对象的顺序
1 <=> 5 => -1 #左 < 右,返回-1
5 <=> 5 => 0  #左 < 右,返回0
9 <=> 5 => 1  #左 < 右,返回1
1.between?(0,10) => true
*******************************************
#迭代和并发
a = [1, 2, 3, 4, 5]
a.each {|x| puts "#{x}, #{a.shift}"}
=>1, 1
    3, 2
    5, 3
    a = [4, 5] 
******************************************
#纤程
require 'fiber'    
f = g = nil

f = Fiber.new{ |x|
	puts "f1: #{x}"
	x = g.transfer(x+1)
	puts "f2: #{x}"
	x = g.transfer(x+1)
	puts "f3: #{x}"
	x + 1
}
g = Fiber.new{ |x|
	puts "g1: #{x}"
	x = f.transfer(x+1)
	puts "g2: #{x}"
	x = f.transfer(x+1)
}
puts f.transfer(1)
********************************************
#方法别名，可以为一个方法增加新的功能
def hello
puts "Hello World!"
end
alias original_hello hello 
def hello
puts "Your attention please"
original_hello
puts "This has been a test"
end
hello
original_hello
*******************************************
# Proc & lamda
#创建proc:1> &
def makeproc(&p)
	p
end
adder = makeproc{|x,y| x+y }
sum = adder.call(2,2) => 4
#创建proc:2> Proc.new
p = Proc.new{ |x,y| x+y }
p.call(1,1)
#创建proc:3> Kernel#lambda
p = lambda{ |x| x > 0}
#lambda字面量
succ = lambda{ |x| x+1 } #ruby 1.8
succ = ->(x){ x+1 } #ruby 1.9
succ.call(2) => 3

#Proc对象的元数
#arity 返回期望的参数个数
lambda{|x,y| x+y }.arity

def it(s,&ope)
	puts s
	yield 
end
#闭包
#multiplier方法返回一个lambda,这个lambda在定义它的范围外
#被使用即为闭包，这个闭包封装了所绑定的方法参数n
def multiplier(n)
	lambda{ |data| data.collect{|x| x*n } }
end
doubler = multiplier(2)
puts doubler.call([1, 2, 3]) => 2, 4, 6

*********************************************
#Kernel，Object，Module列出各种名字的反射方法
class Point
	def initialize(x,y); @x, @y = x,y; end
	@@classvar = 1
	ORIGIN  = Point.new(0, 0)
end
Point::ORIGIN.instance_variables => [:@x, :@y] 
Point.class_variables		=> [:@@classvar] 
Point.constants			=> [:ORIGIN] 

#eval() ，可用于读写局部和全局变量
varname = "x"               
eval(varname)		=> 1
eval("varname = '$g' ")   => Set varname to "$g"
eval("#{varname} = x ")  =>Set $g to 1
eval(varname)	            => 1

#Object定义用于例举所定义方法名的方法
o = "a string"
o.methods  		#names of all public methods
o.public_methods	#the same thing
o.public_methods(false)  #Exclude inherited methods
o.protected_methods	#[ ]:there aren't any
o.private_methods	#array of all private methods
o.private_methods(false)#Exclude inherited private methods
def o.single; 1; end        #Define a singleton method
o.singleton_methods     #[:single]

0.object_id
100.object_id
nil.object_id
true.object_id
false.object_id
https://ruby-china.org/topics/15581,object_id的来龙去脉

#断言方法判断某个特定的类或模块是否定义了给定名称的实例方法
String.public_method_defined? :reverse
String.protected_method_defined? :reverse
String.private_method_defined? :initialize
String.method_defined? :upcase!
**********************************************
#String处理大小写的方法
s = "world"
s.upcase
s.downcase
s.capitalize  #first letter upper,rest lower
s.swapcase #alter case of each letter

#增加和删除空白符的方法
s = "hello\r\n"
s.chomp #remove one line terminator from end

s = "hello\n"
s.chop   #remove \n, \r, \r\n
"".chop!

s = "\t hello \n"
s.strip   #strip all \t, \r, \n
s.lstrip
s.rstrip

s = "x"
s.ljust(3) #control position
s.rjust(3)
s.center(3)
s.center(5,'-')

#字符串解析数字，字符串转换成符号的方法
"10".to_i(2)
"one".to_sym #string to symbol conversion
"two".intern   #intern 
"Hello, " << "world!"  =>"Hello, world!"
nil.inspect     	         =>"nil"
nil.to_s                        =>""
"a|delimited|string".scan("|") scan 是 将满足条件（如正则表达式过滤后）的字符串返回到数组，
"a|delimited|string".split("|") split 是将满足条件的内容为分割点，将分割点左右两边的字符串返回到数组中。
a,b = ["sss","sss"] a.__id__ != b.__id__ #string
a,b = [:sss, :sss] a.__id__ == b.__id__   #symbol
chr(), unchr(), ord() #字符或数字编码值，http://blog.chinaunix.net/uid-25525723-id-2977376.html

#Float类用于取整的方法
1.1.ceil		=> 2#smallest integer >= its argument
1.9.floor	=>1#largest integer <= its argument
1.1.round  	=>1#round to nearest integer
0.5.round	=>1#toward infinity when halfway between integer
1.1.truncate	=>1#chop off fractional part
-1.1.to_i		=>-1#synonym for truncate

#日期和时间
Time.new	#a synonym for Time.now
Time.local(2007, 7, 8)
Time.local(2007, 7, 8, 9, 10)
Time.utc(2007, 7, 8, 9, 10)
Time.gm(2007, 7, 8, 9, 10,11)

t = Time.now
t.strftime("%Y-%m-%d %H:%M:%S")
t.strftime("%H:%M")
t.strftime("%I:%M %p")
t.strftime("%A, %B %d")
t.strftime("%a, %b %d %y")
t.strftime("%x")
t.strftime("%X")

now = Time.now
past = now - 10
future = now + 10
future - now

#集合
(1..3).zip([4, 5, 6]){ |x| puts x.inspect } =>[1, 4], [2, 5], [3, 6]
(1..3).zip([4, 5, 6], [7, 8]){ |x| puts x }   =>1 4 7 2 5 8 3 6
(1..3).zip('a'..'c'){ |x,y| puts x,y } 	         =>1 a 2 b 3 c 

(1..8).select{ |x| x%2 == 0 }	=>[2, 4, 6, 8] 
(1..8).find_all{ |x| x%2 == 1}	=>[1, 3, 5, 7]
(1..8).reject{ |x| x%2 == 0 }	=>[1, 3, 5, 7]
(1..8).partition{ |x| x%2 == 0 }	=>[[2, 4, 6, 8], [1, 3, 5, 7]] 
(1..5).first(2)	=>[1, 2] 
(1..5).take(3)	=> [1, 2, 3]
(1..5).drop(3)	=>[4, 5] 

sum = (1..5).inject{ |total,x| total + x }	   => 15
prod = (1..5).inject{ |total,x| total * x }	   => 120
max = [1, 3, 2].inject{ |m,x| m>x ? m : x }  => 3
[1].inject{|total,x| total + x }		   => 1

sum = (1..5).reduce(:+)			=> 15
prod = (1..5).reduce(:*)			=> 120
letters = ('a'..'e').reduce("-", :concat)	=>"-abcde"
********************************************************
#数组
a = %w[a b c d]
a.at(2)			=>"c"
a.fetch(0)		=>"a"
a.slice(0..1)		=>["a","b"]
a.first(3)		=>["a","b","c"]
a.last(2)			=>["c","d"]
a.values_at(0,2)		=>["a","c"]
a[0,3]			=>["a","b","c"]
a[4,100]			=>[]
a[5,0]			=>nil
a.push(:last)		=>["a", "b", "c", "d", :last]
a.pop			=>:last
a.prepend(2)      	=>["a","b","c","d",2]
a.unshift(:first)		=>[:first, "a", "b", "c", "d"]#按指定项填充数组
a.shift()			=>:first
a+a 			=>["a","b","c","d","a","b","c","d"]
a.concat(["x","y"])	=>["a","b","c","d","x","y"]
a.delete(1)		=>["a","c","d","x","y"]
a.fill(0)			=>[0,0,0,0,0]
a.fill(nil,1,3)		=>[0,nil,nil,nil,0,0]
a.clear			=>[]
#数组迭代器
a = %w[a b c]
a.each {|item| print item}		=>abc
a.reverse_each {|e| print e}		=>cba
a.cycle {|e| print e}			=>abcabcabcabcabcabc...
a.each_index {|e| print e}		=>012
a.each_with_index {|e,i| print e,i}	=>a0b1c2
a.map {|x| x.upcase}			=>["A","B","C"]
a.map! {|x| x.upcase}			=>["A","B","C"]
a.map.with_index { |x, i| x * i } 	    	=>["", "b", "cc"]
a.collect! {|x| x.downcase!}		=>["a","b","c"]
a.map 					=>#<Enumerator: ["a", "b", "c"]:map>
#数组杂项方法
[1,2,3,4].pack("CCCC")	    =>"\x01\x02\x03\x04"
[1234].pack("i")		    =>"\xD2\x04\x00\x00"
[1234].pack("i").unpack("i") =>[1234]
[0,1]*3			    =>[0, 1, 0, 1, 0, 1] 
[1,[2,[3]]].flatten		    =>[1, 2, 3] 
[1,2,3].in_groups_of(2) 	    =>[[1,2], [3,nil]]
a = [ "a", "b", "c", "d" ]
a.collect { |x| x + "!" }         #=> ["a!", "b!", "c!", "d!"]
a.map.with_index { |x, i| x * i } #=> ["", "b", "cc", "ddd"]
a.map  =>#<Enumerator: ["a", "b", "c", "d"]:map>  
a = ["item 1", "item 2", "item 3", "item 4"]
a.each_slice(2).to_h
arr = [1,2,3,4]
Hash[*arr] #=> gives {1 => 2, 3 => 4}
a = [[1, 2], [3, 4]]
Hash[*a.flatten]
[{a: 1}, {b: 2}].reduce({}) { |h, v| h.merge v }
=> {:a=>1, :b=>2}
#哈希
#字面量创建哈希对象
{:one =>1, :two => 2}	   =>{:one=>1, :two=>2}
{one:1, two:2}		   =>{:one=>1, :two=>2}
hash.deep_stringify_keys

a = Hash.new{|h,keys| h[keys]=[222,333]}
a["aa"]
#哈希索引及成员判别
h = { :a => 1, :b => 2}
h.key?(:a)		   =>true
h.has_key?(:b)		   =>true
h.include?(:c)		   =>false
h.member?(:d)		   =>false
h.fetch(:a)		   =>1
h.values_at(:a, :b)	   =>[1,2]#一次取多个值

j = { :x => 5}
h.merge(j)		         =>{:a=>1, :b=>2, :x=>5} #合并hash对象
h.merge(j) {|key, h, j| (h+j)/2}  =>{:a=>1, :b=>2, :x=>5} 
#删除hash
h = { :a => 1, :b => 2, :c => 3, :d => "four"}
h.reject! {|k,v| v.is_a? String}   =>{:a=>1, :b=>2, :c=>3} 
h.delete_if {|k,v| k.to_s < 'b'}   =>{:b=>2, :c=>3}
h.clear			          =>{}
h.except(:a)		          =>{:b => 2, :c => 3, :d => "four"}

#从hash获得数组
h = { :a => 1, :b => 2, :c => 3}
h.keys				=>[:a, :b, :c] 
h.values 			=>[1, 2, 3] 
h.to_a	 			=>[[:a, 1], [:b, 2], [:c, 3]]
h.sort				=>[[:a, 1], [:b, 2], [:c, 3]]
#hash迭代器
h = { :a => 1, :b => 2, :c => 3}
h.each_key {|k| print k}		=>abc
h.each_value {|v| print v}	=>123
h.each_pair {|k,v| print k,v}	=>a1b2c3
#hash杂项方法
h = { :a => 1, :b => 2, :c => 3}	
h.invert				=>{1=>:a, 2=>:b, 3=>:c}
h.to_s 				=>"{:a=>1, :b=>2, :c=>3}"
h.inspect			=>"{:a=>1, :b=>2, :c=>3}"
hash.any?{ |k,v| block }
hash.all?{ |obj| block }
hash.symbolize_keys #把接收者中的键尽量变成符号
hash.deep_symbolize_keys #深度标准化hash格式
hash.transform_keys #接受一个块，使用块中的代码处理接收者的键
hash.stringify_keys #把接收者中的键都变成字符串，然后返回一个散列

a = [ "d", "a", "e", "c", "b" ]
a.sort                    #=> ["a", "b", "c", "d", "e"]
a.sort { |x,y| y <=> x }  #=> ["e", "d", "c", "b", "a"]
a.sort { |x,y| x <=> Y }  #=> ["a", "b", "c", "d", "e"]
sort和sort!函数，默认都使用 <=>比较，他们的区别在于：
sort! 可能会改变原先的数组，所以加个感叹号提醒
sort 返回的是新数组，没对原先的数组进行修改
在ruby的SDK里，能看到很多加了感叹号的函数，都意味着对函数操作的对象进行了状态更改。

depart_res={"工商管理学院"=>[31, 33.33], "旅游与酒店管学院"=>[26, 23.53], "商贸物流学院"=>[24, 29.63]} 
depart_res.sort_by{|k,v| v[1] }.first(3).reverse.to_h

level = [{code:"1", name:"11", level:3},{code:"2", name:"22", level:2},{code:"3", name:"33", level:1}]
level.sort_by{|x| x[:level]}
level.map{|x| puts x}
#文件和目录名
Dir.chdir("/usr/bin")

#代码简化
scope :during, lambda { |start_date, end_date| where(warning_time: (start_date.beginning_of_day...end_date.end_of_day)) }
scope :order_desc, -> { order("event_time desc") }
enum area_id: Campus::MapGrid::Area.pluck(:name, :id).to_h #枚举类型便于取数字中文对

class_no = current_user.employee.try(:teacher_classes).to_a.map{|x| x.try(:class_no)} 
try()防止nil报错，避免单独判断nil情况，try { |p| block}同样接受块，但会吞没方法方法错误，这时用try!()
instance_eval()动态接受实例化变量，https://ruby-china.org/topics/2442
proc对象,proc{ |x=0| }.arity，arity()#arity 返回期望的参数个数

delegate :pluck, :ids, to: :all
delegate :destroy, :destroy_all, :delete, :delete_all, :update, :update_all, to: :all
#ActiveRecord<<Querying，多看源代码，多试多用

find_or_create_by()
find_by()
#Rolify<<Adapter<<RoleAdapter,如何找到这些方法?
