# 冒泡排序：
# 1.比较相邻的元素，若前一个比后一个大，就调换位置
# 2.对每一对相邻元素作比较，从开始第一对到结尾最后一对，最后的元素是最大的数
# 3.针对所有元素重复以上步骤，除了最后一个
# 4.持续每次对越来越少的元素重复上面的步骤，直到没有任何一对数据需要比较。
# 平均时间复杂度：O(n^2)，稳定
def bubble_sort(a)  
  (a.size-2).downto(0) do |i|  
  	puts i
    (0..i).each do |j|  
      a[j], a[j+1] = a[j+1], a[j] if a[j] > a[j+1]  
    end  
  end  
  return a  
end 

# 选择排序：
# 1.初始时在序列中找到最小或最大元素，放到序列的序列的起始位置作为已排序序列
# 2.从剩余未排序元素中继续找最小或最大元素，放到已排序序列末尾，直到所有元素均排序完毕
# 平均时间复杂度：O(n^2)，不稳定
def selection_sort(a)  
  b = []  
  a.size.times do |i|  
    min = a.min  
    b << min  
    a.delete_at(a.index(min))  
  end  
  return b  
end 

# 插入排序：
# 1.从第一个元素开始，认为该元素已排序
# 2.取出下一个元素，在已经排序的元素序列中从后向前扫描
# 3.若该元素(已排序)大于新元素，将该元素移到下一位置
# 4.重复步骤3，直到找到已排序的元素小于或等于新元素的位置
# 5.将新元素插入到该位置后
# 6.重复步骤2-5
# 平均时间复杂度：O(n^2)，稳定
def insertion_sort(a)  
  a.each_with_index do |el,i|  
    j = i - 1  
      while j >= 0  
        break if a[j] <= el  
        a[j + 1] = a[j]  
        j -= 1  
      end  
    a[j + 1] = el  
  end  
  return a  
end 

# 希尔排序：
# 递减增量排序，是基于插入排序的改进方法
# 平均时间复杂度，根据不常序列的不同而不同
def shell_sort(a)  
  gap = a.size  
  while(gap > 1)  
    gap = gap / 2  
    (gap..a.size-1).each do |i|  
      j = i  
      while(j > 0)  
        a[j], a[j-gap] = a[j-gap], a[j] if a[j] <= a[j-gap]  
        j = j - gap  
      end  
    end  
  end  
  return a  
end 

# 归并排序
# 1.申请空间，使大小为两个已经排序序列之和，该空间用来存放合并后的序列
# 2.设定两个指针，最初位置分别为两个已经排序序列的起始位置
# 3.比较两个指针所指向的元素，选择相对小的元素放入到合并空间，并移动指针到下一位置
# 4.重复步骤3直到某一指针到达序列尾
# 平均时间复杂度：O(nlogn)，稳定
def merge(l, r)  
  result = []  
  while l.size > 0 and r.size > 0 do  
    if l.first < r.first  
      result << l.shift  
    else  
      result << r.shift  
    end  
  end  
  if l.size > 0  
    result += l  
  end  
  if r.size > 0  
    result += r  
  end  
  return result  
end  
  
def merge_sort(a)  
  return a if a.size <= 1  
  middle = a.size / 2  
  left = merge_sort(a[0, middle])  
  right = merge_sort(a[middle, a.size - middle])  
  merge(left, right)  
end  

# 堆排序：
# 堆数据结构：近似完全二叉树
# 1.由输入的无序数组构造一个最大堆，作为初始的无序区
# 2.把堆顶元素(最大值)和堆尾元素互换
# 3.把堆(无序区)的尺寸缩小1，并调用heapify(A,0)从新的堆顶元素开始进行堆调整
# 4.重复步骤2，直到堆的尺寸为1
# 平均时间复杂度：O(nlogn)，
# 在堆顶元素与A[i]交换时导致元素不稳定，不稳定排序算法
def heapify(a, idx, size) 
 # 左孩子索引 
  left_idx = 2 * idx + 1  
  # 右孩子索引
  right_idx = 2 * idx + 2  
  # 选出当前结点与其左右孩子三者之中的最大值
  bigger_idx = idx  
  bigger_idx = left_idx if left_idx < size && a[left_idx] > a[idx]  
  bigger_idx = right_idx if right_idx < size && a[right_idx] > a[bigger_idx]  
  if bigger_idx != idx  
  	# 把当前结点和它的最大(直接)子节点进行交换
    a[idx], a[bigger_idx] = a[bigger_idx], a[idx]  
    # 递归调用，继续从当前结点向下进行堆调整
    heapify(a, bigger_idx, size)  
  end  
end 
# 建堆，时间复杂度为O(n)
def build_heap(a)  
  last_parent_idx = a.length / 2 - 1  
  i = last_parent_idx 
  # 从每一个非叶节点开始向下进行堆调整 
  while i >= 0  
    heapify(a, i, a.size)  
    i = i - 1  
  end  
end  
  
def heap_sort(a)  
  return a if a.size <= 1  
  size = a.size 
  # 建堆 
  build_heap(a)  
  while size > 0  
    a[0], a[size-1] = a[size-1], a[0]  
    size = size - 1  
    heapify(a, 0, size)  
  end  
  return a  
end  

# 快速排序：
# 1.从序列中挑出一个元素，作为基准
# 2.把所有比基准值小的元素放在基准前面，所有比基准值大的元素放在基准的后面，相同的数可以放在任一边，即分区操作
# 3.对每个分区递归地进行步骤1-2，递归的结束条件是序列的大小是0或1
# 平均时间复杂度：O(nlogn)，不稳定
def quick_sort(a)  
  (x=a.pop) ? quick_sort(a.select{|i| i <= x}) + [x] + quick_sort(a.select{|i| i > x}) : []  
end  

# Counting sort
def counting_sort(a)  
  min = a.min  
  max = a.max  
  counts = Array.new(max-min+1, 0)  
  
  a.each do |n|  
    counts[n-min] += 1  
  end  
  
  (0...counts.size).map{|i| [i+min]*counts[i]}.flatten  
end  

# 基数排序(Radix sort)
def kth_digit(n, i)  
  while(i > 1)  
    n = n / 10  
    i = i - 1  
  end  
  n % 10  
end  
  
def radix_sort(a)  
  max = a.max  
  d = Math.log10(max).floor + 1  
  
  (1..d).each do |i|  
    tmp = []  
    (0..9).each do |j|  
      tmp[j] = []  
    end  
  
    a.each do |n|  
      kth = kth_digit(n, i)  
      tmp[kth] << n  
    end  
    a = tmp.flatten  
  end  
  return a  
end  


# 桶排序(Bucket sort)
def quick_sort(a)  
  (x=a.pop) ? quick_sort(a.select{|i| i <= x}) + [x] + quick_sort(a.select{|i| i > x}) : []  
end  
  
def first_number(n)  
  (n * 10).to_i  
end  
  
def bucket_sort(a)  
  tmp = []  
  (0..9).each do |j|  
    tmp[j] = []  
  end  
    
  a.each do |n|  
    k = first_number(n)  
    tmp[k] << n  
  end  
  
  (0..9).each do |j|  
    tmp[j] = quick_sort(tmp[j])  
  end  
  
  tmp.flatten  
end  
  
a = [0.75, 0.13, 0, 0.44, 0.55, 0.01, 0.98, 0.1234567]  
bucket_sort(a)  
  
