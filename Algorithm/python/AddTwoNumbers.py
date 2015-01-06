#!/usr/bin/python

# Definition for singly-linked list.
class ListNode:
    def __init__(self, x):
        self.val = x
        self.next = None

class Solution:
    # @return a ListNode
    def addTwoNumbers(self, l1, l2):
    	#if one is empty, return another
    	if l1 == None:
    		return l2
    	if l2 == None:
    		return l1

    	len1 = 0
    	len2 = 0

    	head = l1
    	while head != None:
			# calculate the length of l1
    		len1 += 1
    		head = head.next
    	
    	head = l2
    	while head != None:
    		# calculate the length of l2
    		len2 += 1
    		head = head.next

    	if len2 >= len1:
    		longer = l2
    		shorter = l1

    	else:
    		longer = l1
    		shorter = l2
    	
    	sum = None
    	carry = 0
    	
    	while shorter != None:
    		value = shorter.val + longer.val + carry
    		# if no carry occur, carry == 0
    		carry = value // 10
    		value -= carry * 10
    		
    		if sum == None:
    		    sum = ListNode(value)
    		    result = sum
    		    # referece, initial result as a linklist 

    		else:
			# store value to next node and then point to the next. 
    			sum.next = ListNode(value)
    			sum = sum.next
    		
    		shorter = shorter.next
    		longer = longer.next

    	while longer != None:
    		# run out of the shorter
    		value = longer.val + carry
    		carry = value // 10
    		value -= carry * 10
    		
    		sum.next = ListNode(value)
    		sum = sum.next
    		
    		longer = longer.next
    	
    	if carry != 0:  
    	    sum.next = ListNode(carry)  
        
        return result