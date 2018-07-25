require 'socket'
require 'parallel'

# Thread
# 线程可以共享程序内存，相对来说使用的资源更少
# 相对于进程，线程更加轻量，启动速度更快
# 相互之间通信也非常简单
# Ruby 由于 GIL(Global interpreter lock) 的原因，多线程并不能同时在多个 CPU 上执行
def thread_test
	a = [1, 2, 3, 4]
	b = []
	mutex = Mutex.new

	a.length.times.map do |i|
		Thread.new do
			v = [i, i ** 2].join(' - ')
			mutex.synchronize { b << v}
		end
	end.map(&:join)

	puts b
end

# Process
# 进程间无法共享内存数据进行读写
# 2.0 开始 Copy On Write 功能可以让 fork 的进程共享内存数据，只在数据修改时才会复制数据
# 每个进程可以运行于不同的 CPU 核心上，更充分的利用多核 CPU
# 进程间的数据隔离的同时也提高了安全性，避免了像多线程间数据错乱的风险
# 同样由于进程间的数据隔离，在进程间的通信相对来说更加困难
MAX_RECV = 100
def process_test
	sockets = 3.times.map do |i|
		parent_socket, child_socket = Socket.pair(:UNIX, :DGRAM, 0)
		fork do 
			pid = Process.pid
			parent_socket.close
			number = child_socket.recv(MAX_RECV).to_i
			puts "#{Time.now} process #{pid} receive #{number}"
			sleep 1
			child_socket.write("#{number} - #{number * 2}")
			child_socket.close
		end
		child_socket.close
		parent_socket
	end

	puts "send_jobs"
	sockets.each_with_index.each do |socket, index|
		socket.send((index + 1).to_s, 0)
	end

	puts "read result"
	sockets.map do |socket|
		puts socket.recv(MAX_RECV)
		socket.close
	end
end

def parallel_thread
	list = 10.times.to_a
	a = Proc.new { list.pop || Parallel::Stop }
	result = Parallel.map(a, in_threads: 3) do |number|
		sleep 0.5
		puts "process #{Process.pid} receive #{number}\n"

		number = number.to_i
		number * 2
	end
	puts "result: #{result.join('-')}"
end

def parallel_process
	list = 10.times.to_a
	a = Proc.new { list.pop || Parallel::Stop }
	result = Parallel.map(a, in_processes: 3) do |number|
		sleep 0.5
		puts "process #{Process.pid} receive #{number}\n"

		number = number.to_i
		number * 2
	end
	puts "result: #{result.join('-')}"
end


# thread_test
# process_test
# parallel_thread
parallel_process