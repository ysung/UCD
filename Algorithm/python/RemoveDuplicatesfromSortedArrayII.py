#!/usr/bin/python

# Remove Duplicates from Sorted Array II
# O(n)

# O(n) with constant space 

class ListNode:
    def __init__(self, x):
        self.val = x
        self.next = None


head = ListNode(0)
head.next = ListNode(1)


tempHead = ListNode(head.val ^ 0x1)

# class Solution:
#     # @param A a list of integers
#     # @return an integer
#     def removeDuplicates(self, A):
#         if len(A) <= 2:
#             return len(A)
        
#         index = 0
#         count = 1
#         for i in A[1:]:
#             if i != A[index]:
#                 index += 1
#                 A[index] = i
#                 count = 1
#             elif i == A[index] and count < 2:
#                 index += 1
#                 A[index] = i
#                 count += 1
#             else:
#                 count += 1
                
#         return index + 1