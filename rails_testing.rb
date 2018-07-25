def caches_page(*actions)
	options = actions.extract_options!
	after_filter({only: actions}.merge(options)) do |c|
		c.cache_page(nil, nil, gzip_level)
	end
end
caches_page被声明的action就会带走一个after_filter执行cache_page这一个实例方法,最后得到response.body,写进public里头的对应目录文件里,下次访问这个路由Nginx会直接访问这个文件,应用服务器将不参与任何处理.

把整个项目详情页放入缓存,若项目里的数据没有任何更新,访问这个详情页就可以直接读取详情页的缓存;
若页面明显可以分成一个个的section就做分解,每个section设置为一个独立的缓存,若列表的数据没有更新,就在渲染项目详情页时,就直接从缓存里读取之前生成好的数据;
每个section里面的每个item也可放入独立的缓存,如果只有其中一条item更新,其他两条数据是不会被重新渲染,而是直接从缓存区读取的;
这种层级缓存就一层层嵌套起来形成了俄罗斯套娃.

套娃式的缓存,能够保证页面缓存利用率的最大化,任何数据的更新,只会导致某一个片段的缓存失效,这样在组装完整页面的时候,由于大量的页面片段都是直接从缓存里读取,所以页面生成的时间开销就很小.

<% cache @project do %>
	<% cache @top3_topics.max(&:updated_at) do %>
		...
	<% end %>
<% end %>
第一级套娃,这个cache使用@project作为方法参数,在cache方法内部,会把这个对象进行处理,最后生成一个字符串,大概是:views/projects/1-20170622102125,这就是cache_key,
Rails会使用这串字符串作为key,对应的页面片段作为内容,存储进缓存系统里.每次渲染页面时,会根据cache里的元素计算出对应的cache_key,然后拿这个cache_key到缓存里去找对应的内容,若有,则直接
从缓存里取出,若没有,则渲染cache里的HTML代码片段,并把内容存储进缓存里.
对于一个具体的Model对象,cache_key的生成机制简单来说,就是"对象对应的模型名称/对象数据库ID-对象的最后更新时间".
一个缓存判断最后是否过期,很大程度上只和数据最后更新时间有关,Rails在创建模型数据表时,创建的updated_at字段就是用来生成cache_key的最后更新时间.这个时间发生变化后,页面上对应的cache_key
也就会发生变化,这时<% cache @project %>也就自动过期了.

第二级套娃式各个section缓存,@top3_topics存储的是对应项目里最新创建的三条数据.若直接把@top3_topics对象作为cache的参数,得到的cache_key是这种形式:
views/topics/3-20140906112338/topics/2-20140906102338/topics/3-20140906092338
这是每个对象的cache组合,这个太复杂,特别是当列表元素超过3个,最简单的办法是取这组数据里最新一个被更新的数据的updated_at时间戳,这时cache_key就是这样的:
views/20140906112338
但是若@top3_topics一条数据都没有,对空对象调用max(&:updated_at)方法,返回的值永远都是nil,那所有nil的cache_key都一样,另外若加入任务清单section和讨论section最后更新的那条数据的时间戳恰好一样,
也会造成两个缓存片混淆的问题.解决办法就是给cache参数里增加一个特定的字符串标识,如:
<% cache @top3_topics.max(&:updated_at) %>	改成:
<% cache [:topics, @top3_topics.max(&:updated_at)] %>,这样即使一条数据都没有,生成的cache_key是:
views/topics/20140906112338, 带上了「topics」自己的标识，这样就能和其它 nil 类型的缓存区分开了。

有个问题:若改变了一条任务的内容,作废了任务partial自己的缓存,但是包裹任务的任务清单,以及包裹任务清单的项目都没有变化,这样当页面加载的时候,读取到第一个大套娃都没有更新,会直接返回被缓存了的整个
项目详情页,根本不回去走到渲染更新的任务partial.解决办法是Rails模型层的touch机制.
里面的子套娃在数据更新了之后,touch一下处在外面的套娃,告诉它也需要更新.
class Project < ActiveRecord::Base
	...
end

class Todolist < ActiveRecord::Base
	belongs_to :project, touch:true
end

class Todo < ActiveRecord::Base
	belongs_to :todolist, touch:true
end
使用 Rails model 的 belongs_to 来声明模型的从属关系，比如一个 Todo 属于一个 Todolist，一个 Todolist 属于一个 Project，而在 belongs_to 后面，我们还传入了一个 touch: true 的参数，这样，
当一条 Todo 更新的时候，会自动更新它对应的 Todolist 对象的 updated_at 字段，然后又因为 Todolist 和 Project 之间也有 touch 机制，所以对应 Project 对象的 updated_at 字段也会被更新。
通过层层touch的机制,确保子元素更新后,其父容器的缓存也能过期,整个套娃机制才能正常运作.

注意坑:
problem:在一个子元素的模板里,包含了父元素,在任务清单模板里,需要显示下项目的名称,这时若缓存是<% cache [:topics, @top3_topics.max(&:updated_at)] %>,当把项目名称修改了,这个缓存片是不会过期的,
因此任务清单列表里的项目名称也不会去改变.
<% cache [:todolists, @todolists.max(&:updated_at)] do %>
	<span>清单所属的项目是:<%= @project.name %></span>
<% end %>

resolution1:修改任务清单的缓存的cache_key,改成:
<% cache [:todolists, @project, @todolists.max(&:updated_at)] do %>
	<span>清单所属的项目是:<%= @project.name %></span>
<% end %>	
这样修改项目名称,就能导致缓存片过期,这就是把缓存里面存在的所有模型对象统一纳入cache_key里.但是这样存在一个问题,因为项目本身是经常被touch的,修改任务,创建评论都会导致这个任务清单的缓存片随时失效,缓存命中率降低.

resolution2:使用实际需要的模型字段来做缓存,改成:
<% cache [:todolists, @project.name, @todolists.max(&:updated_at)] do %>
	<span>清单所属的项目是:<%= @project.name %></span>
<% end %>	
这样只会在项目名称发生改变时,更新缓存片,这个方法性价比最高,但是若一个缓存里出现多个模型字段的时候,就要写一串这样的cache_key,和"只对一个具体资源缓存"的原则相悖,所以一般缓存的具体字段不要超过一个.

resolution3:在HTML结构上做调整,如果针对的是@todolists做缓存,则应该把其他无关的资源从HTML结构中提取出来,改成:
<input type="hidden" name="project_name" value="<%= @project.name %>" />
<% cache [:todolists, @project.name, @todolists.max(&:updated_at)] do %>
	<span id="project-name-span">清单所属的项目是:</span>
<% end %>	
这样可以通过 JS 读取这个属性，再重新注入到模板相应的元素里面。选择这种方案，需要提前根据设计做好规划，把那些需要提取出来的元素放在缓存以外。











