# #创建线程
# require 'net/http'

# pages = %w( www.rubycentral.com www.baidu.com www.google.com )
# threads = [ ]

# for page_to_fetch in pages
# 	threads << Thread.new(page_to_fetch) do |url|

# 		h = Net::HTTP.new(url, 80)
# 		puts "Fetching: #{url}"
# 		resp = h.get( '/', nil )
# 		puts "Got #{url}: #{resp.message}"
# 	end
# end
# threads.each { |thr| thr.join }
****************************************************
#异常处理
# threads = [ ]
# 4.times do |number|
# 	threads << Thread.new(number) do |i|
# 		raise "Boom!" if i == 2
# 		print "#{ i }\n"
# 	end
# 	threads.each do |t|
# 		begin
# 			t.join
# 		rescue RuntimeError => e
# 			puts "Failed: #{e.message}"
# 		end
# 	end
# end
# # threads.each { |t| t.join }
****************************************************
#类与对象
a = "hello"
b = a.dup
class << a #为对象obj构建一个新类
     def to_s
         "The value is '#{self}'"
     end
     def two_times
         self + self
     end
end
a.to_s            => "The value is 'hello' "
a.two_times  => "hellohello"
b.to_s 			  => "hello"
*****************************************************
#Mixin模块
#ps:当类包含一个模块时，模块的实例方法会变为类的实例方法
module SillyModule
	def hello
		"Hello!"
	end
end

class SillyClass
	include SillyModule
end
s = SillyClass.new
s.hello => "Hello!"
*********************************************************
#扩展对象
module Humor
	def tickle
		"hee,hee!"
	end
end
#1>将一个模块混合到对象中
a = "Grouchy"
a.extend Humor 
a.tickle => "hee,hee!"
#2>将模块中的方法添加到类的级别
class Grouchy
	include Humor
	extend Humor
end
Grouchy.tickle
a = Grouchy.new
a.tickle => "hee,hee!"
********************************************************
#类和模块的定义
#Module是Class的祖先类，在类定义中调用其实例方法，无须指明接收者
#ps:类定义在执行时就是以这个类作为当前对象
class Test
	puts "Class of self = #{self.class}"
	puts "Name of self = #{self.name}"
end
=>Class of self = Class
	 Name of self = Test

#类实例变量
class Test
	@cls_var = 123
	def Test.inc 
		@cls_var += 1
	end
end
Test.inc 
Test.inc 
*****************************************************
#查看向模块和类添加基本的文档化功能,
#让doc方法在任何模块或类中都可使用,
#需要让它作为Module的一个实例方法
class Module
	@@docs = {}
	def doc(str)
		@@docs[self.name] = self.name + ":\n" + str.gsub(/^\s+/,'')
	end
	def Module::doc(aClass)
		aClass = aClass.name if aClass.class <= Module
		@@docs[aClass] || "No documentation for #{aClass}"
	end
end
class Example
	doc "This is a documentation string"
end
module Another
	doc <<-edoc
	And this is a documentation string
	in a module
	edoc
end
puts Module::doc(Example)
=>Example:
	This is a documentation string
puts Module::doc("Another")
=>Another:
	And this is a documentation string
	in a module
*****************************************************
#类名是常量,可以把类和其他Ruby对象一样对待，
#将它们作为参数传入方法，或在表达式中使用
def factory(klass, *args)
	klass.new(*args)
end
factory(String, "Hello") =>"Hello"
factory(Dir, ".") 				=> #<Dir:.> 

#若一个无名的类被赋值给一个常量，Ruby将常量作为类名
var = Class.new
var.name => ""

Wibble = var
var.name => "Wibble"
****************************************************

#Object
#遍历所有现存的对象
a = 102.7
b = 95.1
ObjectSpace.each_object(Numeric) {|x| p x }

#得到对象能响应的所有方法的一个列表
r = 1..10
list = r.methods
list.length
list[0..3] =>　[:==, :===, :eql?, :hash] 
#查看对象是否支持某个具体的方法
r.respond_to?("frozen?")  => true
r.respond_to?(:has_key?)  => false
"me".respond_to?("==")   => true

#确定对象的类以及的它的唯一对象ID,并测试与其他类的关系
num = 1
num.id 
num.class 	
#测试该对象是否是该类的某个子类的实例  => Fixnum
num.kind_of? Fixnum　　=> true
#检查一个对象所属的类
num.instance_of? Fixnum => true

#考察类
#超类和混入的模块
Fixnum.ancestors  =>  [Fixnum, Integer, Numeric, Comparable, Object, Kernel, BasicObject]
#得到任何类的父类
Fixnum.superclass => Integer
#遍历得到一个完整的类层次结构
ObjectSpace.each_object(Class) do |klass|
	p klass
end

#动态调用对象
#send
"John Col".send(:length) => 8
#call
miles = "Miles Davis".method("sub")
miles.call(/iles/, ".")        => "M. Davis" 
#eval
trane = %q{"	John Col".length }
eval trane

#性能比较:send/call快于eval
require 'benchmark'
include Benchmark
test = "Stormy Weather"
m = test.method(:length)
n = 100000
bm(12) { |x|
	x.report("call")   { n.times { m.call } }
	x.report("send") { n.times { test.send(:length) } }
	x.report("eval")  { n.times {eval "test.length" } }
}

*******************************************


