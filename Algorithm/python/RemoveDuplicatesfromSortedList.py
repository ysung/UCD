# Definition for singly-linked list.
# class ListNode:
#     def __init__(self, x):
#         self.val = x
#         self.next = None

class Solution:
    # @param head, a ListNode
    # @return a ListNode
    def deleteDuplicates(self, head):
        if head == None or head.next == None:
            return head
            
        p = head
        
        while p != None:
            while p.next != None and p.next.val == p.val:
                if p.next.next == None:
                    p.next = None
                else:
                    p.next = p.next.next
            p = p.next
        
        return head
        