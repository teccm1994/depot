require 'socket'
require 'parallel'

# Thread
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