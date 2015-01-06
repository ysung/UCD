#!/usr/bin/python

# Definition for singly-linked list.
# class ListNode:
#     def __init__(self, x):
#         self.val = x
#         self.next = None

class Solution:
    # @return a ListNode
    def removeNthFromEnd(self, head, n):
        slow = head
        fast = head
        
        for i in range(n):  
            fast = fast.next  
            
        if fast != None:
            while fast.next != None:
                fast = fast.next
                slow = slow.next
        
            slow.next = slow.next.next
            # change the reference of head
            
            return head
        else:
            return head.next
            