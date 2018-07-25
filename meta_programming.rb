#2016.10.27 对象模型
class MyClass
	def my_method
		@v = 1
	end
end
obj = MyClass.new
obj.class 					  			=>MyClass
obj.my_method       			=>1
obj.instance_variables 		=>[:@v]
ps: 
实例变量：Ruby中对象的类和它的实例变量无关，对于同一个类，可创建具有不同实例变量的对象。
方法：Object>methods可获得对象的方法列表，对象会从类中继承方法。实例变量在对象中，方法在类中。
重访类：所有类最终都继承于Object，Object本身继承于BasicObject，BasicObject是Ruby对象体系中
的根节点。

方法查找：
接收者：调用方法所在的对象；调用一个方法时，接收者就成为self，所有的实例变量都是self的实例变量,
没有明确指明接收者的方法都在self上调用。
祖先链：类>超类>超类的超类>Object类>BasicObject类。Object>ancestors()获取一个类的祖先链。

module Printable
	def print
		#...
	end

	def prepare_cover
		#...
	end
end
module Document
	def print_to_screen
		prepare_cover
		format_for_screen
		print
	end
	def format_for_screen
		#...
	end
	def print
		#...
	end
end
class Book
	include Document
	include Printable
	#...
end
b = Book.new
b.print_to_screen 	=> nil
Book.ancestors 	   => [Book, Printable, Document, Object, Kernel, BasicObject]
...
class Book
	include Printable
	include Document
	#...
end
Book.ancestors 	   => [Book, Document, Printable, Object, Kernel, BasicObject]
小结：
>对象由一组实例变量和一个类的引用组成；
>对象的方法存在于对象所属的类中；
>类本身是Class类的对象；
>Class类是Module的子类。一个模块基本上是由一组方法组成的包。类除了具有模块的特性外，
还可以被实例化；
>常量像文件系统一样，是按照树形结构组织的；
>每个类都有一个祖先链，这个链从自己所属的类开始，向上直到BasicObject类结束；
>当调用一个方法时，Ruby先向右一步来到接收者所属的类，然后一直向上查找祖先链，
直到找到该方法或到达BasicObject为止；
>当调用一个方法时，接收者会扮演self的角色；
>当定义一个模块或类时，该模块或类扮演self的角色；
>任何没有明确指定接收者的方法调用，都当成是调用self的方法。

#2016.11.02 方法
class MyClass
	def my_method(my_arg)
		my_arg * 2
	end
end
obj = MyClass.new
obj.my_method(3) 				=>6
obj.send(:my_method, 5) 	=>10
ps:
动态派发：send()第一个参数是要发给对象的消息(方法名)，可用字符串或符号，所有剩下的参数／
代码块会直接传递给调用的方法。

class MyClass_1
	define_method :my_method do |my_arg|
		my_arg * 3
	end
end
obj = MyClass_1.new
obj.my_method(6) 		=>18
ps:
动态方法：define_method()方法在MyClass_1内部执行，是其实例方法，
在运行时定义方法的技术成为动态方法。通过send()和define_method()可大量减少重复代码。

require 'ruport'
table = Ruport::Data::Table.new :column_names =>["country","wine"],
			   :data =>[["France","Bordeaux"],["Italy","Chianti"],["France","Chablis"]]
puts table.to_text
ps:
Ruport是一个Ruby报表库，可通过调用Ruport::Data::Table类来创建表格数据及转换为不同的格式。
幽灵方法：被method_missing()，从调用者角度跟普通方法无差，但实际接收者没有相对应的方法。

require 'ostruct'
icecream = OpenStruct.new
icecream.flavor = "strawberry"
icecream.flavor	=>"strawberry"
ps:
OpenStruct类来自于Ruby标准库，一个OpenStruct对象的属性用起来就像是Ruby的变量。
若想要一个新属性，只需给它赋值即可(幽灵方法)。

def method_missing(name,*args)
	super if !@data_source.respond_to?("get_#{name}_info")
		info = @data_source.send("get_#{name}_info",args[0])
		price = @data_source.send("get_#{name}_price",args[0])
		result = "#{name.to_s.capitalize}: #{info} ($#{price})"
		return " *#{result}" if price >= 100
		result
	end
end
ps:
幽灵方法不是真正的方法，在自动生成的文档中找不到，methods()方法列表也没有，
在覆写method_missing()方法时同时需要覆写respond_to?()方法。

class Roulette
	def method_missing(name,*args)
		person = name.to_s.capitalize
		3.times do
			number = rand(10) + 1
			puts "#{number}..."
		end
		"#{person} got a #{number}"
	end
end
number_of = Roulette.new
puts number_of.Bob  =>1... 3... 7... ......
puts number_of.Jim	  =>8... 4... 2... ......无限循环至报错
ps:使用幽灵方法经常出现的问题
由于调用未定义的方法会导致调用method_missing()方法，对象可能会因此接受一个
直接的错误方法调用，因此仅在必要时使用幽灵方法。上述bug修复如下：
class Roulette
	def method_missing(name,*args)
		person = name.to_s.capitalize
		super unless %w[Bob Frank Bill].include? person
		number = 0
		3.times do
			number = rand(10) + 1
			puts "#{number}..."
		end
		"#{person} got a #{number}"
	end
end
number_of = Roulette.new
puts number_of.Bob =>2... 6... 10... Bob got a 10
puts number_of.Tom  =>NoMethodError: undefined method 'Tom'

Object.instance_methods.grep /^d/ =>[:dup, :display, :define_singleton_method]
ps:动态代理的通病
当一个幽灵方法和一个真实方法发生名字冲突时，后者会胜出。为了安全起见，
应该在代理类中删除绝大多数继承来的方法，即白板类。
Module>undef_method()，删除所有包括继承来的方法；
Module>remove_method()，只删除接收者自己的方法，保留继承来的方法。

require 'builder'
xml = Builder::XmlMarkup.new(:target=>STDOUT, :indent=>2)
xml.coder {
	xml.name 'Matsumoto', :nickname=>'Matz'
	xml.language 'Ruby'
}
=>
#<coder>
#  <name nickname="Matz">Matsumoto</name>
#  <language>Ruby</language>
#</coder>
xml.semester {
xml.class 'Egyptology'
xml.class 'Orithology'
}
=>
# <semester>
#   <class>Egyptology</class>
#   <class>Orithology</class>
# </semester>
ps:
Builder中的XmlMarkup类继承自一个白板，其中删除了绝大多数继承自Object的方法，如class()。
小结：
消除代码重复性的两种方案：
１.动态方法和动态派发；
 2.动态代理和白板类。

 #2016.11.03 代码块
 def a_method(a,b)
 	a + yield(a,b)
 end
 a_method(1,2) {|x, y| (x + y) * 3}  =>10
ps:只有在调用一个方法时才可以定义一个块，块会被直接传递给这个方法，然后改方法可以用yeild关键字回调这个块。

def a_method
	return yield if block_given?
	'no block'
end
a_method											=>"no block" 
a_method { "here's a block!" }  =>"here's a block!"
ps:在一个方法中，可向Ruby询问当前的方法调用是否包含块，通过Kernel>block_given?()方法做到。

module Kernel
	def using(resource)
		begin
			yield
		ensure
			resource.dispose
		end
	end
end
ps:内核方法Kernel>using()以待管理的资源作为参数，还接受一个块在那里执行代码。无论块中的代码是否正常执行完成，
ensure语句都会调用resource的dispose()方法来释放它。如果发生了异常，Kernel>using()方法会将异常抛给调用者。

def my_method
	x = "Goodbye"
	yield("cruel")
end
x = "Hello"
my_method { |y| "#{x}, #{y} world" }  =>"Hello, cruel world"
ps:创建块时会获取到局部绑定，然后把块连同自己的绑定传给一个方法。
闭包：块的绑定包括一个名为x的变量，虽然方法中定义了一个变量x，但块看到的x是在块定义时绑定的x，
方法中的x对块来说是不可见的。

v1 = 1
class MyClass 			 #作用域门:进入class
	v2 = 2				    
	local_variables     #=>["v2"]

	def my_method   #作用域门:进入def
		v3 = 3
		local_variables
	end  						  #作用域门:离开def
	local_variables	     #=>["v2"]
end                			  #作用域门:离开class
ps:作用域门：类定义，模块定义，方法

my_var = "Success"
MyClass = Class.new do
puts "#{my_var} in the class definition!"
	define_method :my_method do 
		puts "#{my_var} in the method!"
	end
end
MyClass.new.my_method   
=>Success in the method!
ps:扁平作用域：两个作用域被挤压在一起，即可共享各自的变量。可以使用Class.new()代替class，
Module.new()代替module，Module>define_method()代替def，就形成了扁平作用域。
共享作用域：在一个扁平作用域中定义多个方法，这些方法可用一个作用域门进行保护，并共享绑定。

class MyClass
	def initialize
		@v = 1
	end
end
obj = MyClass.new
obj.instance_eval do
	self
	@v
end
=> 1
v = 2
obj.instance_eval { @v = v }   => 2
obj.instance_eval { @v }         => 2
ps:instance_eval()可以访问接收者的私有方法和实例变量，在不碰其他绑定情况下修改self对象。

inc = Proc.new { |x| x + 1 }
inc.call(2)		=>3
ps:延迟执行技术：一个Proc就是一个转换成对象的块，可以通过把块传给Proc.new方法来创建一个Proc,
之后用Proc>call()方法来执行这个由块转换而来的对象。

dec = lambda { |x| x - 1}
dec.class 	    =>Proc 
dec.call(5)     => 4
ps:Proc:lambda()和proc()这两个内核方法可将块转换为Proc。

def math(a, b)
	yield(a, b)
end
def teacher_math(a, b, &operation)
	puts "Let's do the math:"
	puts math(a, b, &operation)
end
teacher_math(2, 3) { |x, y| x * y } 
=>#Let's do the math:
    #6
ps:将块传给另一个方法，给块取一个名字，给块附加到方法上，可方法的参数列表最后，
添加一个移&符号开头的参数。

def my_method(&the_proc)
the_proc
end
p=my_method { |name| "Hello, #{name}!" }
puts p.class         =>Proc
puts p.call("Bill")  =>Hello,Bill
ps:&操作符:这是Proc对象，当成一个块来使用。

def double(callable_object)
	callable_object.call * 2
end
l = lambda { return 10 }
double(1)           #=> 20

def another_double
p = Proc.new { return 10 }
result = p.call
return result * 2
end
another_double   #=>10
ps:lambda中，return仅表示从这个lambda中返回，proc中，是从proc的作用域中返回。

class MyClass
	def initialize(value)
		@x = value
	end
	def my_method
		@x
	end
end
obj = MyClass.new(1)
m = Object.method :my_method
m.call 
ps:调用Object>method()方法可获得一个用Method对象表示的方法，之后可用Method>call()对它进行调用。
lambda在定义它的作用域中执行，而Method对象会在自身所在对象的作用域中执行。

unbound = m.unbind
another_object = MyClass.new(5)
m = unbound.bind(another_object)
m.call 
ps:用Method>unbind()方法把一个方法跟它所绑定的对象分离，该方法再返回一个UnboundMethod对象。
不能执行UnboundMethod对象，但能把它绑定到一个对象上，使之再次成为一个Method对象。只能在
another_object与原先这个方法的对象属于同一类时才起作用。
小结：
>块在其定义的作用域中执行
>proc类的对象跟块一样，也在定义自身的作用域中执行
>方法绑定于对象，在所绑定对象的作用域中执行。他们可与这个作用域解除绑定，再重新绑定到另一个对象的作用域上。


