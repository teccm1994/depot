#!/usr/bin/env python
# -*- coding: utf-8 -*- 

def binary_search(list, item):
	# list: 有序列表
	# item: 要检索的元素
	low = 0
	high = len(list) - 1
	while low <= high:
		mid = (low + high)
		guess = list[mid]
		if guess == item:
			return mid
		if guess > item:
			high = mid - 1
		else:
			low = mid + 1
	return None


list = [1, 3, 5, 7, 9]
print binary_search(list, 3)